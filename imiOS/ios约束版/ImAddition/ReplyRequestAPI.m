//
//  ReplyRequest.m
//  ImAddition
//
//  Created by yuhui wang on 16/8/7.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "ReplyRequestAPI.h"
#import "IMTcpProtocolHeader.h"
#import "DataInputStream.h"
#import "DataOutputStream.h"
#import "DataOutputStream+Addition.h"
#import "sm4.h"
#import "IMConstant.h"
#import "IMSessionKeyManager.h"

@implementation ReplyRequestAPI
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
    return IM_USER;
}

/**
 *  请求返回的commandID
 *
 *  @return 对应的commandID
 */
- (int)responseCommandID
{
    return IM_USER;
}

/**
 *  请求的subcommendID
 *
 *  @return 对应的subcommendID
 */
- (int)requestSubcommandID
{
    return IM_USER_ADD_REQUEST;
}

/**
 *  请求返回的subcommendID
 *
 *  @return 对应的subcommendID
 */
- (int)responseSubcommandID
{
    return IM_USER_ADD_RESULT;
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
        NSString *resultString=nil;
        if (resultCode == 0) {
            resultString = @"ReplySuccess";
        }else{
            resultString = @"ReplyFailure";
        }
        
        return resultString;
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
        int userID = [object[0] intValue];
        short addResult = [object[1] shortValue];
        NSString *text = object[2];
        short textLength = text.length;
        
        DataOutputStream *dataout = [[DataOutputStream alloc] init];
        [dataout writeTcpProtocolHeaderWithCommandID:IM_USER subcommandID:IM_USER_ADD_RESULT packageID:packageID];
        [dataout writeInt:userID];
        [dataout writeShort:addResult];
        [dataout writeShort:textLength];
        [dataout directWriteUTF:text];
        
        unsigned char *dataPackageChar = (unsigned char*)[dataout ->data bytes];
        int dataPackageLength = (int)dataout -> length;
        NSLog(@"dataPackageLength:%d",dataPackageLength);
        
        //加载会话密钥
        NSData *sessionKey = [[IMSessionKeyManager instance] sessionKey];
        unsigned char *key = [sessionKey bytes];
        // 1）key：密钥 2）1：表示加密，0表示解密 3）5：明文长度 4）plain：明文，5字节
        // 5）cipher：密文，长度16字节     函数返回值为密文长度
        int series = dataPackageLength / 16 + 1;
        unsigned char cipher[series * 16];
        int cipher_len = sm4_crypt_ecb_ex(key, 1, dataPackageLength, dataPackageChar, cipher);
        NSLog(@"dataFiledLength:%d",cipher_len);
        
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
