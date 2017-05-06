//
//  GetGroupListAPI.m
//  ImAddition
//
//  Created by yuhui wang on 16/8/15.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "GetGroupListAPI.h"
#import "IMTcpProtocolHeader.h"
#import "IMConstant.h"
#import "DataOutputStream.h"
#import "DataInputStream.h"
#import "DataOutputStream+Addition.h"
#import "sm4.h"
#import "IMGroupEntity.h"
#import "IMSessionKeyManager.h"

@implementation GetGroupListAPI
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
    return IM_GRP_LIST;
}

/**
 *  请求返回的subcommendID
 *
 *  @return 对应的subcommendID
 */
- (int)responseSubcommandID
{
    return IM_GRP_LIST;
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
        NSMutableArray *groupList = [[NSMutableArray alloc] init];
        NSArray *groupArray = [[NSArray alloc] init];
        if (resultCode == 0) {
            NSLog(@"获取群列表成功!");
            int groupNumber = [datain readInt];
            [groupList addObject:[NSNumber numberWithInt:groupNumber]];
            NSLog(@"群组条目数量：%d",groupNumber);
            for (int i=0; i<groupNumber; i++) {
                int groupID = [datain readInt];
                NSString *name = [datain readUTFWithInt];
                int memmberNumber = [datain readInt];
                IMGroupEntity *group = [[IMGroupEntity alloc]initWithGroupID:groupID name:name memberNumber:memmberNumber];
                [groupList addObject:group];
            }
            groupArray = groupList;
        }else{
            NSLog(@"获取群列表失败!");
            groupArray = nil;
        }
        return groupArray;
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
        [dataout writeTcpProtocolHeaderWithCommandID:IM_GROUP subcommandID:IM_GRP_LIST packageID:packageID];
        
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
