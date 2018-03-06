//
//  SendSoundAPI.m
//  ImAddition
//
//  Created by tongho on 16/8/21.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "SendSoundAPI.h"
#import <AVFoundation/AVFoundation.h>
#import "IMTcpProtocolHeader.h"
#import "DataInputStream.h"
#import "DataOutputStream.h"
#import "DataOutputStream+Addition.h"
#import "IMConstant.h"
#import "sm4.h"
#import "IMSessionKeyManager.h"

@implementation SendSoundAPI
/**
 *  请求超时时间
 *
 *  @return 超时时间
 */
- (int)requestTimeOutTimeInterval
{
    return 5;
}

/**
 *  请求的commandID
 *
 *  @return 对应的commandID
 */
- (int)requestCommandID
{
    return IM_MESSAGE;
}

/**
 *  请求返回的commandID
 *
 *  @return 对应的commandID
 */
- (int)responseCommandID
{
    return IM_MESSAGE;
}

/**
 *  请求的subcommendID
 *
 *  @return 对应的subcommendID
 */
- (int)requestSubcommandID
{
    return IM_MESS_SOUND;
}

/**
 *  请求返回的subcommendID
 *
 *  @return 对应的subcommendID
 */
- (int)responseSubcommandID
{
    return IM_MESS_SOUND;
}

/**
 *  解析数据的block
 *
 *  @return 解析数据的block
 */
- (Analysis)analysisReturnData
{
    Analysis analysis = (id)^(NSData* data)
    {
        DataInputStream *datain = [[DataInputStream alloc] init];
        datain = [DataInputStream dataInputStreamWithData:data];
        short resultCode = [datain readShort];
        NSLog(@"返回状态:%04x",resultCode);
        NSArray* msgInfo = [[NSArray alloc] init];
        if (resultCode == 0) {
            NSLog(@"发送语音!");
            
            long sessionID = [datain readLong];
            NSNumber* sessionId = [NSNumber numberWithLong:sessionID];
            long time = [datain readLong];
            NSNumber* sendTime = [NSNumber numberWithLong:time];
            msgInfo = @[sessionId,sendTime];
        }else{
            msgInfo = nil;
        }
        return msgInfo;
    };
    return analysis;
}

/**
 *  打包数据的block
 *
 *  @return 打包数据的block
 */
- (Package)packageRequestObject
{
    Package package = (id)^(id object,uint32_t packageID)
    {
        int sessionType = [object[0] intValue];
        NSLog(@"会话类型：%d",sessionType);
        int toUserID = [object[1] intValue];
        NSLog(@"to USER：%d",toUserID);
        NSString *soundPath = object[2];
        
        int duration  =0;
       
        AVAudioPlayer *audioPlayer =  [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
        duration = (int)audioPlayer.duration;
            
        NSLog(@"11111%d",duration);
        NSData *soundData;
        while (0 == duration) {
           soundData = [NSData dataWithContentsOfFile:soundPath];
            NSLog(@"语音数据长度:%lu",(unsigned long)soundData.length);
        }
        
        soundData = [NSData dataWithContentsOfFile:soundPath];
        NSLog(@"语音数据长度:%lu",(unsigned long)soundData.length);
        
        DataOutputStream *dataout = [[DataOutputStream alloc] init];
        [dataout writeTcpProtocolHeaderWithCommandID:IM_MESSAGE subcommandID:IM_MESS_SOUND packageID:packageID];
        [dataout writeLong:0]; // 消息ID，置零
        [dataout writeLong:0]; // 中转时间，置零
        [dataout writeInt:sessionType];
        [dataout writeInt:0]; // 发送者ID
        [dataout writeInt:toUserID];
        [dataout writeInt:duration];
        [dataout writeBytes:soundData];
        
        unsigned char *dataPackageChar = (unsigned char*)[dataout ->data bytes];
        int dataPackageLength = (int)dataout -> length;
        NSLog(@"dataPackageLength:%d",dataPackageLength);
        
        // 进行对称加密
        // 加载会话密钥
        NSData *sessionKey = [[IMSessionKeyManager instance] sessionKey];
        unsigned char *key = [sessionKey bytes];
        // 1）key：密钥 2）1：表示加密，0表示解密 3）5：明文长度 4）plain：明文，5字节
        // 5）cipher：密文，长度16字节     函数返回值为密文长度
        int series = dataPackageLength/16 + 1;
        unsigned char cipher[series * 16];
        int cipher_len = sm4_crypt_ecb_ex(key, 1, dataPackageLength, dataPackageChar, cipher);
        
        if (cipher_len != sizeof(cipher)) {
            NSLog(@"你摊上事儿了！！！");
        }
        DataOutputStream *dataoutputStream = [[DataOutputStream alloc] init];
        [dataoutputStream writeH1:0x01 encryptType:0x02 serviceType:0x01 dataFiledLength:cipher_len packageID:packageID];
        NSLog(@"密文长度：%d",cipher_len);
        NSData *dataFiled = [NSData dataWithBytes:cipher length:cipher_len];
        [dataoutputStream directWriteBytes:dataFiled];
        
        [dataoutputStream writeCheckCode1];
        [dataoutputStream writeCheckCode2];
        
        return [dataoutputStream toByteArray];
    };
    return package;
}
@end
