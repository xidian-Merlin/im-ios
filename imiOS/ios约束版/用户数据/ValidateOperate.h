//
//  ValidateOperate.h
//  ios约束版
//
//  Created by tongho on 16/8/21.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateOperate : NSObject

//邮箱
+ (BOOL) validateEmail:(NSString *)email;

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;

//用户名
+ (BOOL) validateUserName:(NSString *)name;

//密码
+ (BOOL) validatePassword:(NSString *)passWord;

//昵称
+ (BOOL) validateNickname:(NSString *)nickname;

//验证码
+ (BOOL) validateVerification:(NSString *)verification;
@end
