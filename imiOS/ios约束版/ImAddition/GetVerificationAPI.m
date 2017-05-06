//
//  GetVerificationAPI.m
//  ios约束版
//
//  Created by yuhui wang on 2016/11/29.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "GetVerificationAPI.h"
#import "IMTcpProtocolHeader.h"
#import "DataInputStream.h"
#import "DataOutputStream.h"
#import "sm3.h"
#import "DataOutputStream+Addition.h"
#import "IMConstant.h"
#import "sm2.h"
#import "IMSessionKeyManager.h"
#import "ServerFeedbackConverter.h"

@implementation GetVerificationAPI

/**
 *  请求超时时间
 *
 *  @return 超时时间
 */
- (int)requestTimeOutTimeInterval
{
    return 10;
}

/**
 *  请求的commandID
 *
 *  @return 对应的commandID
 */
- (int)requestCommandID
{
    return IM_ACCOUNT;
}

/**
 *  请求返回的commandID
 *
 *  @return 对应的commandID
 */
- (int)responseCommandID
{
    return IM_ACCOUNT;
}

/**
 *  请求的subcommendID
 *
 *  @return 对应的subcommendID
 */
- (int)requestSubcommandID
{
    return IM_ACC_GET_VERIFICATION;
}

/**
 *  请求返回的subcommendID
 *
 *  @return 对应的subcommendID
 */
- (int)responseSubcommandID
{
    return IM_ACC_GET_VERIFICATION;
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
        resultString = [ServerFeedbackConverter convertServerFeedbackWithResultCode:resultCode];
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
        NSString *userName = object[0]; // 用户名
        NSLog(@"用户名：%@",userName);
        BOOL flag = [object[1] boolValue]; // 标识字段
        NSLog(@"标识：%d",flag);
        NSString *account = object[2]; // 手机 或 邮箱号
        NSLog(@"邮箱号：%@",account);
        DataOutputStream *dataout = [[DataOutputStream alloc] init];
        [dataout writeTcpProtocolHeaderWithCommandID:IM_ACCOUNT subcommandID:IM_ACC_GET_VERIFICATION packageID:packageID];
        
        [dataout directWriteBytes:[[IMSessionKeyManager instance] sessionKey]];
        [dataout writeUTF:userName];
        [dataout writeChar:flag];
        if (!flag) {
            [dataout directWriteUTF:account];
        } else {
            [dataout directWriteUTF:@"18866668888"];
            [dataout writeUTF:account];
        }
        
        unsigned char *dataPackageChar = (unsigned char*)[dataout ->data bytes];
        int dataPackageLength = (int)dataout -> length;
        NSLog(@"dataPackageLength:%d",dataPackageLength);
        int dataFiledLength = dataPackageLength + 64 + 32;
        NSLog(@"dataFiledLength:%d",dataFiledLength);
        // 进行公钥加密
        unsigned char *pub_x, *pub_y;
        unsigned char c1[64],c2[dataPackageLength], c3[32];
        unsigned char rng[32] = {'x', 'i', 'd', 'i', 'a','n','x', 'i', 'd', 'i', 'a','n','x', 'i', 'd', 'i', 'a','n',
            'x', 'i', 'd', 'i', 'a','n','x', 'i', 'd', 'i', 'a','n','x','i'};
        
        DataOutputStream *dataoutputStream = [[DataOutputStream alloc] init];
        [dataoutputStream writeH1:0x01 encryptType:0x01 serviceType:0x01 dataFiledLength:dataFiledLength packageID:packageID];
        //加载公钥
        NSString *pubPathx = [[NSBundle mainBundle] pathForResource:@"pubKey_x" ofType:nil];
        NSData *datax = [NSData dataWithContentsOfFile:pubPathx];
        pub_x = (unsigned char *)[datax bytes];
        
        NSString *pubPathy = [[NSBundle mainBundle] pathForResource:@"pubKey_y" ofType:nil];
        NSData *datay = [NSData dataWithContentsOfFile:pubPathy];
        pub_y = (unsigned char *)[datay bytes];
        // 1）plain：明文 2）5：明文长度 3）rng：32字节随机数 4）pub_x、pub_y：公钥，两个32字节
        // 5）C1：加密结果之一，64字节 6）C2：加密结果之二，与明文长度一致 7）C3：加密结果之三，32字节
        sm2_enc(dataPackageChar, dataPackageLength, rng, pub_x, pub_y, c1, c2, c3);
        
        NSData *c1Data = [NSData dataWithBytes:c1 length:sizeof(c1)];
        [dataoutputStream directWriteBytes:c1Data];
        NSData *c3Data = [NSData dataWithBytes:c3 length:sizeof(c3)];
        [dataoutputStream directWriteBytes:c3Data];
        NSData *c2Data = [NSData dataWithBytes:c2 length:sizeof(c2)];
        [dataoutputStream directWriteBytes:c2Data];
        
        [dataoutputStream writeCheckCode1];
        [dataoutputStream writeCheckCode2];
        return [dataoutputStream toByteArray];
    };
    return package;
}


@end
