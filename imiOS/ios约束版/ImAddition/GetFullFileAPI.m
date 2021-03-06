//
//  GetFullFileAPI.m
//  ImAddition
//
//  Created by tongho on 16/8/13.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "GetFullFileAPI.h"
#import "IMTcpProtocolHeader.h"
#import "DataOutputStream+Addition.h"
#import "DataOutputStream.h"
#import "DataInputStream.h"
#import "sm4.h"
#import "IMConstant.h"
#import "IMMessageEntity.h"
#import "Person.h"
#import "IMSessionKeyManager.h"

@implementation GetFullFileAPI
/**
 *  请求超时时间
 *
 *  @return 超时时间
 */
- (int)requestTimeOutTimeInterval
{
    return 5000;
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
    return IM_MESS_GET_FULL_FILE;
}

/**
 *  请求返回的subcommendID
 *
 *  @return 对应的subcommendID
 */
- (int)responseSubcommandID
{
    return IM_MESS_GET_FULL_FILE;
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
        short result = [datain readShort];
        NSLog(@"返回状态：%d",result);
        long msgID = [datain readLong];
        long time = [datain readLong];
        int sessionType = [datain readInt];
        int fromUserID = [datain readInt];
        int toUserID = [datain readInt];
        NSString* fileName = [datain readUTFWithInt];
        int fileLength = [datain readInt];
        NSData *file = [datain readDataWithLength:fileLength];
        
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [docPaths lastObject];
        
        
        //获取cache，存自建文件
        NSString *nowCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *nowPath = [filePath stringByAppendingPathComponent:@"nowUser.data"];
        Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];
        
        NSString *imgPath = [nowCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/File/%@",nowUser.userName,fileName]];
        
        [file writeToFile:imgPath atomically:YES];
        
        //NSString *msgContent = [NSString stringWithFormat:@"%@+%@+%d",imgPath,fileName,fileLength];
        
        IMMessageEntity *msg = [[IMMessageEntity alloc]initWithMsgID:msgID msgTime:time SessionType:sessionType senderID:fromUserID toUserID:toUserID IMMessageContentType:IMMessageTypeFile msgContent:[NSString stringWithFormat:@"File/%@",fileName]];
        return msg;
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
        long sessionID = [object[0] longValue];
        int sessionType = [object[1] intValue];
        
        DataOutputStream *dataout = [[DataOutputStream alloc] init];
        [dataout writeTcpProtocolHeaderWithCommandID:IM_MESSAGE subcommandID:IM_MESS_GET_FULL_FILE packageID:packageID];
        [dataout writeLong:sessionID];
        [dataout writeInt:sessionType];
        
        unsigned char *dataPackageChar = (unsigned char*)[dataout ->data bytes];
        int dataPackageLength = (int)dataout -> length;
        NSLog(@"dataPackageLength:%d",dataPackageLength);
        
        // 进行对称加密
        // 加载会话密钥
        NSData *sessionKey = [[IMSessionKeyManager instance] sessionKey];
        unsigned char *key = [sessionKey bytes];
        // 1）key：密钥 2）1：表示加密，0表示解密 3）5：明文长度 4）plain：明文，5字节
        // 5）cipher：密文，长度16字节     函数返回值为密文长度
        int series = dataPackageLength / 16 + 1;
        unsigned char cipher[series * 16];
        int cipher_len = sm4_crypt_ecb_ex(key, 1, dataPackageLength, dataPackageChar, cipher);
        
        if (cipher_len != sizeof(cipher)) {
            NSLog(@"你摊上事儿了！！！");
        }
        DataOutputStream *dataoutputStream = [[DataOutputStream alloc] init];
        [dataoutputStream writeH1:0x01 encryptType:0x02 serviceType:0x01 dataFiledLength:cipher_len packageID:packageID];
        NSData *dataFiled = [NSData dataWithBytes:cipher length:cipher_len];
        [dataoutputStream directWriteBytes:dataFiled];
        
        [dataoutputStream writeCheckCode1];
        [dataoutputStream writeCheckCode2];
        
        return [dataoutputStream toByteArray];
    };
    return package;
}
@end
