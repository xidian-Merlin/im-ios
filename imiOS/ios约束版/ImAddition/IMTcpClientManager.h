//
//  IMTcpClientManager.h
//  im
//
//  Created by yuhui wang on 16/7/27.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMSendBuffer;
@interface IMTcpClientManager : NSObject<NSStreamDelegate>
{
@private
    NSInputStream *_inStream;
    NSOutputStream *_outStream;
    NSLock *_receiveLock;
    NSMutableData *_receiveBuffer;
    NSLock *_sendLock;
    NSMutableArray *_sendBuffers;
    IMSendBuffer *_lastSendBuffer;
    BOOL _noDataSent;
    int32_t cDataLen;
    
}

+ (instancetype)instance;

-(void)connect:(NSString *)ipAdr
          port:(NSInteger)port
        status:(NSInteger)status;

-(void)disconnect;

-(void)writeToSocket:(NSMutableData *)data;
@end
