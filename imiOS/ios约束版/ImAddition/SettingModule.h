//
//  SettingModule.h
//  ImAddition
//
//  Created by tongho on 16/8/4.
//  Copyright © 2016年 tongho. All rights reserved.
//  设置模块：修改密码、设置头像、设置昵称、设置查看权限、更改绑定信息

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SettingModule : NSObject

+ (instancetype)instance;

- (void)resetPasswordWithUsername:(NSString*)name
                      oldPassword:(NSString*)oldPassword
                      newPassword:(NSString*)newPassword
                          success:(void(^)())success
                          failure:(void(^)(NSString* error))failure;

- (void)setAvatar:(UIImage*)avatar
          success:(void(^)())success
          failure:(void(^)(NSString* error))failure;

- (void)setNick:(NSString*)nick
        success:(void(^)())success
        failure:(void(^)())failure;

- (void)chagneBindingRequestWithMethod:(char)method
                               success:(void(^)())success
                               failure:(void(^)(NSString* error))failure;

- (void)changeBindingWithPhone:(NSString*)phone
                         email:(NSString*)email
                  verification:(NSString*)verification
                       success:(void(^)())success
                       failure:(void(^)(NSString* error))failure;
@end
