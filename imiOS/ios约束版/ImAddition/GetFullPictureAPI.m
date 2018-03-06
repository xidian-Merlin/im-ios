//
//  GetFullPictureAPI.m
//  ImAddition
//
//  Created by tongho on 16/8/12.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "GetFullPictureAPI.h"
#import "IMTcpProtocolHeader.h"
#import "DataOutputStream+Addition.h"
#import "DataOutputStream.h"
#import "DataInputStream.h"
#import "sm4.h"
#import "IMConstant.h"
#import "UIKit/UIKit.h"
#import "IMMessageEntity.h"
#import "Person.h"
#import "IMSessionKeyManager.h"

@implementation GetFullPictureAPI
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
    return IM_MESS_GET_FULL_PIC;
}

/**
 *  请求返回的subcommendID
 *
 *  @return 对应的subcommendID
 */
- (int)responseSubcommandID
{
    return IM_MESS_GET_FULL_PIC;
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
        int result = [datain readShort];
        //NSLog(@"返回状态：%d",result);
        long msgID = [datain readLong];
        //NSLog(@"xiaoxiID:%lu",msgID);
        long time = [datain readLong];
        //NSLog(@"zhongzhuannshijian:%lu",time);
        int sessionType = [datain readInt];
        //NSLog(@"huihualeixing:%d",sessionType);
        int fromUserID = [datain readInt];
        //NSLog(@"fromerID:%d",fromUserID);
        int toUserID = [datain readInt];
        //NSLog(@"receiverID:%d",toUserID);
        NSString* picName = [datain readUTFWithInt];
        //picName = @"tttttt.png";
        //NSLog(@"图片名:%@",picName);
        int imgLength = [datain readInt];
        //NSLog(@"picLen:%d",imgLength);
        NSData *img = [datain readDataWithLength:imgLength];
        
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [docPaths lastObject];
        
        //获取cache，存自建文件
        NSString *nowCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *nowPath = [filePath stringByAppendingPathComponent:@"nowUser.data"];
        Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];
        NSString *imgPath = [nowCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/Image/%@",nowUser.userName,picName]];
        NSLog(@"图片地址:,%@",imgPath);
        
        UIImage *image = [UIImage imageWithData:img]; // 取得图片
        
        BOOL success = [UIImageJPEGRepresentation(image, 1) writeToFile:imgPath atomically:YES];
        if (success){
            NSLog(@"写入本地成功");
        }else{
            NSLog(@"写入失败！！！");
        }
        
        IMMessageEntity *msg = [[IMMessageEntity alloc]initWithMsgID:msgID msgTime:time SessionType:sessionType senderID:fromUserID toUserID:toUserID IMMessageContentType:IMMessageTypeImage msgContent:[NSString stringWithFormat:@"Image/%@",picName]];
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
        [dataout writeTcpProtocolHeaderWithCommandID:IM_MESSAGE subcommandID:IM_MESS_GET_FULL_PIC packageID:packageID];
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
