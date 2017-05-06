//
//  IMPackage.h
//  im
//
//  Created by yuhui wang on 16/7/16.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMPackage : NSObject
{
    @public int packageId;
}
@property short firstType;
@property short secondType;
@property int packageLength;



// 注册、登录
@property NSString *userName;
@property NSString *userPsw;
@property NSString *nickName;
@property NSString *portraitPath;
@property NSString *userOldPwd;
@property NSString *tel;
@property NSString *mail;
@property NSString *groupName;

@property int userId;
@property short limitCode; // 限制查看资料？
@property NSString *verifyInfo;

// use for result
@property short resultCode;


// 会话
@property int messageId;
@property int sessionType;
@property int receiverId;
@property NSString *content;
@property NSString *filePath;

// 传文件
@property int filePackageLength;
@property NSData *filePack;

+ (IMPackage *)initWithFirstType:(short) firstType
                      secondType:(short) secondType
                       packageId:(int) packageId
                   packageLength:(int) packageLength
                        userName:(NSString *)userName
                         userPsw:(NSString *)userPsw
                        nickName:(NSString *)nickName
                    portraitPath:(NSString *)portraitPath ;




@end
