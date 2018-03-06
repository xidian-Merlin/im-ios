//
//  LoginModule.h
//  im
//
//  Created by tongho on 16/7/18.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IMUserEntity,IMTCPServer,IMMsgServer;
@interface LoginModule : NSObject
{
    IMTCPServer* _tcpServer;
    IMMsgServer* _msgServer;
}
+ (instancetype)instance;

/**
 *  登录接口，整个登录流程
 *
 *  @param name     用户名
 *  @param password 密码
 *  @param success  执行成功后的操作
 *  @param failure  失败后的操作
 */
- (void)loginWithUsername:(NSString*)name
                 password:(NSString*)password
                  success:(void(^)(NSNumber* response))success
                  failure:(void(^)(NSString* error))failure;

- (void)logoutSuccess:(void(^)())success
              failure:(void(^)(NSString* error))failure;

/**
 *  离线
 */
- (void)offlineCompletion:(void(^)())completion;

- (void)reloginSuccess:(void(^)())success
               failure:(void(^)(NSString* error))failure;
@end
