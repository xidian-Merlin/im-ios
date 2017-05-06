//
//  InviteToGroupAPI.m
//  ImAddition
//
//  Created by yuhui wang on 16/8/14.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "InviteToGroupAPI.h"
#import "IMTcpProtocolHeader.h"
#import "DataInputStream.h"
#import "DataOutputStream.h"
#import "DataOutputStream+Addition.h"
#import "sm4.h"
#import "IMConstant.h"
#import "IMSessionKeyManager.h"

@implementation InviteToGroupAPI
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
    return IM_GROUP;
}

/**
 *  请求返回的commandID
 *
 *  @return 对应的commandID
 */
- (int)responseCommandID
{
    return IM_GROUP;
}

/**
 *  请求的subcommendID
 *
 *  @return 对应的subcommendID
 */
- (int)requestSubcommandID
{
    return IM_GRP_INVITE;
}

/**
 *  请求返回的subcommendID
 *
 *  @return 对应的subcommendID
 */
- (int)responseSubcommandID
{
    return IM_GRP_INVITE;
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
        NSMutableArray *users = [[NSMutableArray alloc] init];
        NSArray* userArray = [[NSArray alloc] init];
        if (resultCode == 0) {
            NSLog(@"邀请用户成功!");
            int number = [datain readInt];
            NSLog(@"邀请成功人数:%d",number);
            NSNumber *userNumber = [NSNumber numberWithInt:number];
            [users addObject:userNumber];
            for (int i=0; i<number; i++) {
                [users addObject:[NSNumber numberWithInt:[datain readInt]]];
            }
            userArray = users;
        }else{
            NSLog(@"搜索用户失败!");
            userArray = nil;
        }
        return userArray;
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
        DataOutputStream *dataout = [[DataOutputStream alloc] init];
        [dataout writeTcpProtocolHeaderWithCommandID:IM_GROUP subcommandID:IM_GRP_INVITE packageID:packageID];
        
        int ID = [object[0] intValue];
        [dataout writeInt:ID];
        int number = [object[1] intValue];
        [dataout writeInt:number];
        
        for (int i=2; i<number+2; i++) {
            [dataout writeInt:[object[i] intValue]];
        }
        
        unsigned char *dataPackageChar = (unsigned char*)[dataout ->data bytes];
        int dataPackageLength = (int)dataout -> length;
        NSLog(@"dataPackageLength:%d",dataPackageLength);
        
        // 进行对称加密
        //加载会话密钥
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
        NSData *dataFiled = [NSData dataWithBytes:cipher length:cipher_len];
        [dataoutputStream directWriteBytes:dataFiled];
        
        [dataoutputStream writeCheckCode1];
        [dataoutputStream writeCheckCode2];
        
        return [dataoutputStream toByteArray];
    };
    return package;
}

@end
