//
//  IMTcpClientManager.m
//  im
//
//  Created by tongho on 16/7/27.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "IMTcpClientManager.h"
#import "NSStream+NSStreamAddition.h"
#import "IMSendBuffer.h"
#import "DataInputStream.h"
#import "IMClientState.h"
#import "IMAPIScheduler.h"
#import "IMNotification.h"
#import "IMConstant.h"
#import "IMTcpProtocolHeader.h"
#import "sm4.h"
#import "IMSessionKeyManager.h"
#import <netdb.h>
#import <arpa/inet.h>

@interface IMTcpClientManager(PrivateAPI)

- (void)p_handleConntectOpenCompletedStream:(NSStream *)aStream;
- (void)p_handleEventErrorOccurredStream:(NSStream *)aStream;
- (void)p_handleEventEndEncounteredStream:(NSStream *)aStream;
- (void)p_handleEventHasBytesAvailableStream:(NSStream *)aStream;
- (void)p_handleEventHasSpaceAvailableStream:(NSStream *)aStream;
@end

@implementation IMTcpClientManager
+ (instancetype)instance
{
    static IMTcpClientManager* g_tcpClientManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_tcpClientManager = [[IMTcpClientManager alloc] init];
    });
    return g_tcpClientManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[IMClientState shareInstance] addObserver:self
                                        forKeyPath:IM_USER_STATE_KEYPATH
                                           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                           context:nil];
    }
    return self;
}

#pragma mark - PublicAPI
-(void)connect:(NSString *)ipAdr port:(NSInteger)port status:(NSInteger)status
{
    NSLog(@"IM client :connect ipAdr:%@ port:%ld",ipAdr,(long)port);
    cDataLen = 0;
    
    _receiveBuffer = [NSMutableData data]; // 初始化接受缓存区
    _sendBuffers = [NSMutableArray array]; // 设置发送缓冲区数组 可变数组
    _noDataSent = NO;                      // 初始化发送 flag
    
    _receiveLock = [[NSLock alloc] init];
    _sendLock = [[NSLock alloc] init];
    
    NSInputStream  *tempInput  = nil;
    NSOutputStream *tempOutput = nil;
    
    // 判断 IPv4 和 IPv6 网络
    NSString *ip;
    struct addrinfo * result;
    struct addrinfo * res;
    char ipv4[128];
    char ipv6[128];
    int error;
    BOOL IS_IPV6 = FALSE;
    //初始化，c语言中将 块中的前多少个字符赋值为0
    bzero(&ipv4, sizeof(ipv4));
    bzero(&ipv4, sizeof(ipv6));
    
    error = getaddrinfo([ipAdr UTF8String], NULL, NULL, &result);
    if(error != 0) {
        NSLog(@"error in getaddrinfo:%d", error);
    }
    for(res = result; res!=NULL; res = res->ai_next) {
        char hostname[1025] = "";
        error = getnameinfo(res->ai_addr, res->ai_addrlen, hostname, 1025, NULL, 0, 0);
        if(error != 0) {
            NSLog(@"error in getnameifno: %s", gai_strerror(error));
            continue;
        }
        else {
            switch (res->ai_addr->sa_family) {
                case AF_INET:
                    memcpy(ipv4, hostname, 128);
                    break;
                case AF_INET6:
                    memcpy(ipv6, hostname, 128);
                    IS_IPV6 = TRUE;
                default:
                    break;
            }
            NSLog(@"hostname: %s ", hostname);
        }
    }
    freeaddrinfo(result);
    if(IS_IPV6 == TRUE){
        ip = [NSString stringWithUTF8String:ipv6];
        //NSLog(@"ipv6:%@",[NSString stringWithUTF8String:ipv6]);
    }else{
        ip = [NSString stringWithUTF8String:ipv4];
        //NSLog(@"ipv4:%@",[NSString stringWithUTF8String:ipv4]);
    }
// 建立连接
    [NSStream getStreamsToHostNamed:ip port:port inputStream:&tempInput outputStream:&tempOutput];
    _inStream  = tempInput;
    _outStream = tempOutput;
    
    [_inStream setDelegate:self];
    [_outStream setDelegate:self];
    // RunLoop当_inStream、_outStream没有上锁时允许读、写
    [_inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_inStream open];
    [_outStream open];
}

-(void)disconnect
{
    NSLog(@"IM Client:disconnect");
    
    cDataLen = 0;
    
    _receiveLock = nil;
    _sendLock = nil;
    
    if(_inStream)
    {
        [_inStream close];
        [_inStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    _inStream = nil;
    
    if (_outStream) {
        [_outStream close];
        [_outStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    _outStream = nil;
    
    _receiveBuffer = nil;
    _sendBuffers = nil;
    _lastSendBuffer = nil;
    
    [IMNotification postNotification:IMNotificationTcpLinkDisconnect userInfo:nil object:nil];
    
}

-(void)writeToSocket:(NSMutableData *)data{
    [_sendLock lock];
    @try {
        if (_noDataSent ==YES) {
            
            NSInteger len;
            // 从 [data mutableBytes] 中写入至多 [data length] 字节数据到_outStream中，返回值：实际写入的数据
            len = [_outStream write:[data mutableBytes] maxLength:[data length]];
            _noDataSent = NO;
            //NSLog(@"WRITE - Written directly to outStream len:%li", len);
            if (len < [data length]) {
                // 当数据长度大于实际写入长度，即未写完时，将剩余数据存入一个 sendbuffer 当中
                //NSLog(@"WRITE - Creating a new buffer for remaining data len:%li", [data length] - len);
                _lastSendBuffer = [IMSendBuffer dataWithNSData:[data subdataWithRange:NSMakeRange(len,[data length]-len)]];
                [_sendBuffers addObject:_lastSendBuffer];
                
            }
            return;
        }
        
        if (_lastSendBuffer) {
            NSInteger lastSendBufferLength;
            NSInteger newDataLength;
            lastSendBufferLength = [_lastSendBuffer length]; // 已存在的数据长度
            newDataLength = [data length];
            if (lastSendBufferLength<1024) {
                NSLog(@"WRITE - Have a buffer with enough space, appending data to it");
                [_lastSendBuffer appendData:data];
                
              //  [_sendBuffers addObject:_lastSendBuffer];
                
                return;
            }
        }
        NSLog(@"WRITE - Creating a new buffer");
        _lastSendBuffer = [IMSendBuffer dataWithNSData:data];
        [_sendBuffers addObject:_lastSendBuffer];
        
    }
    @catch (NSException *exception) {
        NSLog(@" ***** NSException:%@ in writeToSocket of Client *****",exception);
    }
    @finally {
        [_sendLock unlock];
    }
}

#pragma mark -
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:IM_USER_STATE_KEYPATH])
    {
        switch ([IMClientState shareInstance].userState)
        {
            case IMUserKickout:
            case IMUserOffLineInitiative:
                [self disconnect];
                break;
                
            default:
                break;
        }
    }
}


#pragma mark - NSStream Delegate
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch(eventCode) {
        case NSStreamEventNone:
            //NSLog(@"Event type: EventNone");
            break;
        case NSStreamEventOpenCompleted:
            [self p_handleConntectOpenCompletedStream:aStream];
            break;
        case NSStreamEventHasSpaceAvailable:          //发送数据
            //NSLog(@"Event type: EventHasSpaceAvailable");
            [self p_handleEventHasSpaceAvailableStream:aStream];
            break;
        case NSStreamEventErrorOccurred:
            //NSLog(@"Event type: EventErrorOccured");
            [self p_handleEventErrorOccurredStream:aStream];
            break;
        case NSStreamEventEndEncountered:
            //NSLog(@"Event type: EventEndOccured");
            [self p_handleEventEndEncounteredStream:aStream];
            break;
        case NSStreamEventHasBytesAvailable:     //读取数据
            //NSLog(@"Event type: EventHasBytesAvailable");
            [self p_handleEventHasBytesAvailableStream:aStream];
            break;
    }
}

#pragma mark - PrivateAPI
- (void)p_handleConntectOpenCompletedStream:(NSStream *)aStream
{
    if (aStream == _outStream) {
        [IMNotification postNotification:IMNotificationTcpLinkConnectComplete userInfo:nil object:nil];
    }
}

- (void)p_handleEventHasSpaceAvailableStream:(NSStream *)aStream
{
    [_sendLock lock];
    
    @try {
        
        if (![_sendBuffers count]) {
            NSLog(@"WRITE - No data to send");
            _noDataSent = YES;
            
            return;
        }
        
        IMSendBuffer *sendBuffer = [_sendBuffers objectAtIndex:0];
        
        NSInteger sendBufferLength = [sendBuffer length];
        //空的sendBuffer
        if (!sendBufferLength) {
            if (sendBuffer == _lastSendBuffer) {
                _lastSendBuffer = nil;
            }
            
            [_sendBuffers removeObjectAtIndex:0];
            
            NSLog(@"WRITE - No data to send");
            
            _noDataSent = YES;
            
            return;
        }
        
        NSInteger len = ((sendBufferLength - [sendBuffer sendPos] >= 1024) ? 1024 : (sendBufferLength - [sendBuffer sendPos]));
        if (!len) {
            if (sendBuffer == _lastSendBuffer) {
                _lastSendBuffer = nil;
            }
            
            [_sendBuffers removeObjectAtIndex:0];
            
            NSLog(@"WRITE - No data to send");
            
            _noDataSent = YES;
            
            return;
        }
        
        
        //cichu
        //NSLog(@"write %ld bytes", len);
        len = [_outStream write:((const uint8_t *)[sendBuffer mutableBytes] + [sendBuffer sendPos]) maxLength:len];
        // NSLog(@"WRITE - Written directly to outStream len:%lid", (long)len);
        [sendBuffer consumeData:len]; // 即sendPos += length
        
        if (![sendBuffer length]) {
            if (sendBuffer == _lastSendBuffer) {
                _lastSendBuffer = nil;
            }
            
            [_sendBuffers removeObjectAtIndex:0];
        }
        
        _noDataSent = NO;
        
        return;
    }
    @catch (NSException *exception) {
        NSLog(@" ***** NSException in Cleint :%@  ******* ",exception);
    }
    @finally {
        [_sendLock unlock];
    }
}




- (void)p_handleEventErrorOccurredStream:(NSStream *)aStream
{
    NSLog(@"handle eventErrorOccurred");
    [self disconnect];
    if ([IMClientState shareInstance].userState != IMUserOffLineInitiative) {
        [IMClientState shareInstance].userState = IMUserOffLine;
    }
}

- (void)p_handleEventEndEncounteredStream:(NSStream *)aStream
{
    NSLog(@"handle eventEndEncountered");
    cDataLen = 0;
    
}

- (void)p_handleEventHasBytesAvailableStream:(NSStream *)aStream
{
    if (aStream) {
        uint8_t buf[1024];
        NSInteger len = 0;
        len = [(NSInputStream *)aStream read:buf maxLength:1024];
        
        if (len > 0) {
            
            [_receiveLock lock];
            [_receiveBuffer appendBytes:(const void *)buf length:len];
            
            while ([_receiveBuffer length] >= 12) {
                // 读取数据域长度
                NSRange range = NSMakeRange(4, 4);
                NSData *dataLenth = [_receiveBuffer subdataWithRange:range];
                DataInputStream *inputData = [DataInputStream dataInputStreamWithData:dataLenth];
                uint32_t pduLen = [inputData readInt];
                //如果数据域长度大于读入的数据的长度，说明不是一个完整的包，那么退出，继续读取数据，直至小于或等于（小于是，剩下的是下一个包的数据）
                if (pduLen > (uint32_t)[_receiveBuffer length] - 12 - 32) {
                    break;
                }
                range = NSMakeRange(12, pduLen);
                NSLog(@"receiveBuffer长度：%lu,数据域长度：%d",(unsigned long)[_receiveBuffer length],pduLen);
                NSData *dataWithoutH1 = [_receiveBuffer subdataWithRange:range];
                // 转为byte数组，解密SM4
                unsigned char *cipher = (unsigned char*)[dataWithoutH1 bytes];
                unsigned char *plain = malloc(pduLen * sizeof(char));
                NSData *key =[[IMSessionKeyManager instance] sessionKey];
                unsigned char *sessionkey = (unsigned char*)[key bytes];
                
                /*调用sm4.h中的sm4_crypt_ecb_ex函数。参数分别为：
                 1）key：密钥     2）1：表示加密，0表示解密  3）密文长度
                 4）cipher：密文  5）plain：明文    函数返回值为密文长度
                 
                 extern int sm4_crypt_ecb_ex(unsigned char key[16],
                 int mode,
                 unsigned int length,
                 unsigned char *input,
                 unsigned char *output);
                 */
                int plainLength = sm4_crypt_ecb_ex(sessionkey, 0, pduLen, cipher, plain);
                NSLog(@"返回明文长度为：%d",plainLength);
                // 转为NSData

                NSData* plainData = [NSData dataWithBytes:plain length:plainLength];
                DataInputStream *dataField = [DataInputStream dataInputStreamWithData:plainData];
                
                IMTcpProtocolHeader* tcpHeader = [[IMTcpProtocolHeader alloc] init];
                tcpHeader.commandID = [dataField readShort];
                tcpHeader.subcommandID = [dataField readShort];
                tcpHeader.packageID = [dataField readInt];
                
                NSLog(@"receive a packet commandID=%04x, subcommandID=%04x, packageID=%04d", tcpHeader.commandID, tcpHeader.subcommandID,tcpHeader.packageID);
                
                range = NSMakeRange(8, plainLength - 8);
                NSData *payloadData = [plainData subdataWithRange:range];
                
                uint32_t remainLen = (int)[_receiveBuffer length] - 12 - pduLen - 32;
                range = NSMakeRange(12 + pduLen + 32, remainLen);
                NSData *remainData = [_receiveBuffer subdataWithRange:range];
                //将下一个包的数据继续保存
                [_receiveBuffer setData:remainData];
                
                ServerDataType dataType = IMMakeServerDataType(tcpHeader.commandID, tcpHeader.subcommandID, tcpHeader.packageID);
                if (payloadData.length >0){
                    [[IMAPIScheduler instance] receiveServerData:payloadData forDataType:dataType];
//                    unsigned char* payloadBytes = [payloadData bytes];
//                    NSLog(@"%02x %02x",payloadBytes[0],payloadBytes[1]);
                }
                
            }
            
            [_receiveLock unlock];
        }
        else {
            NSLog(@"No buffer!");
        }
        
    }
    
}
@end
