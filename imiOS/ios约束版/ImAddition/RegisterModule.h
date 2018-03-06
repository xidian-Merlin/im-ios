//
//  RegisterModule.h
//  ImAddition
//
//  Created by tongho on 16/8/4.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class IMTCPServer,IMMsgServer;
@interface RegisterModule : NSObject
{
    IMTCPServer* _tcpServer;
    IMMsgServer* _msgServer;
}
+ (instancetype)instance;

/**
 *  注册接口
 *
 *  @param name     用户名
 *  @param password 密码
 *  @param success  成功后操作
 *  @param failure  失败后操作
 */
- (void)registerWithUsername:(NSString*)name
                        nick:(NSString*)nick
                    password:(NSString*)password
                      avatar:(UIImage*)avatar
                       phone:(NSString*)phone
                       email:(NSString*)email 
                verification:(NSString*)verification
                     success:(void(^)())success
                     failure:(void(^)(NSString* error))failure;
/**
 * 获取验证码接口
 * @ name       用户名
 * @ method     获取验证码方式 0：手机  1：邮箱
 * @ account    手机或邮箱 号码
 */
- (void)getVerificationWithUsername:(NSString*)name
                             method:(BOOL)method
                            account:(NSString*)account
                            success:(void(^)())success
                            failure:(void(^)(NSString* error))failure;
/**
 * 忘记密码(重置密码)接口
 * @ username       用户名
 * @ newPassword    新密码
 * @ email          邮箱
 * @ phone          手机
 * @ verification   验证码
 */
- (void)setNewPasswordWithUserName:(NSString*)username
                       newPassword:(NSString*)newPassword
                             phone:(NSString*)phone
                             email:(NSString*)email
                      verification:(NSString*)verification
                           success:(void(^)())success
                           failure:(void(^)(NSString* error))failure;
@end
