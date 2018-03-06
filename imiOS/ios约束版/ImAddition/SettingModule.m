//
//  SettingModule.m
//  ImAddition
//
//  Created by yuhui wang on 16/8/4.
//  Copyright © 2016年 tongho. All rights reserved.
//  设置模块：修改密码、设置头像、设置昵称、设置查看权限、更改绑定信息

#import "SettingModule.h"
#import "ResetPasswordAPI.h"
#import "SetAvatarAPI.h"
#import "SetNickAPI.h"
#import "ChangeBindingRequestAPI.h"
#import "ChangeBindingAPI.h"

@implementation SettingModule
+ (instancetype)instance
{
    static SettingModule *g_SettingManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_SettingManager = [[SettingModule alloc] init];
    });
    return g_SettingManager;
}

- (id)init
{
    self = [super init];
    return self;
}

- (void)resetPasswordWithUsername:(NSString *)name
                      oldPassword:(NSString *)oldPassword
                      newPassword:(NSString *)newPassword
                          success:(void (^)())success
                          failure:(void (^)(NSString *))failure
{
    NSLog(@"设置密码!");
    NSArray* parameter = @[name,oldPassword,newPassword];
    NSLog(@"将用户名密码传入数组做参数！");
    ResetPasswordAPI* api = [[ResetPasswordAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断设置密码结果");
        if (!error)
        {
            if([response isEqual: @"ResetSuccess"]){
                NSLog(@"修改成功!");
                success(response);
            }else{
                NSLog(@"修改失败!");
                failure(@"修改失败!");
            }
                
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"修改失败!");
        }
    }];
}

- (void)setAvatar:(UIImage*)avatar
          success:(void(^)())success
          failure:(void(^)(NSString* error))failure
{
    NSLog(@"设置头像!");
    UIImage *parameter = avatar;
    SetAvatarAPI* api = [[SetAvatarAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断设置昵称结果！");
        if (!error)
        {
            if([response isEqual: @"SetSuccess"]){
                NSLog(@"设置成功!");
                success(response);
            }else{
                NSLog(@"设置失败!");
                failure(@"修改失败!");
            }
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"修改头像失败!");
        }
    }];
}

- (void)setNick:(NSString*)nick
        success:(void(^)())success
        failure:(void(^)())failure
{
    NSLog(@"设置昵称!");
    NSString *parameter = nick;
    SetNickAPI* api = [[SetNickAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断设置昵称结果！");
        if (!error)
        {
            if([response isEqual: @"SetSuccess"]){
                NSLog(@"设置成功!");
                success();
            }else{
                NSLog(@"设置失败!");
                failure(@"设置失败");
            }
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"设置昵称失败!");
        }
    }];
}

- (void)chagneBindingRequestWithMethod:(char)method success:(void (^)())success failure:(void (^)(NSString *))failure
{
    NSLog(@"修改绑定请求!");
    NSNumber *parameter = [NSNumber numberWithChar:method];
    ChangeBindingRequestAPI* api = [[ChangeBindingRequestAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断请求修改绑定结果！");
        if (!error)
        {
            if([response isEqual: @"Success"]){
                NSLog(@"请求成功!");
                success();
            }else{
                NSLog(@"请求失败!");
                failure(@"请求失败");
            }
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"请求修改绑定失败!");
        }
    }];
}

- (void)changeBindingWithPhone:(NSString *)phone email:(NSString *)email verification:(NSString*)verification success:(void (^)())success failure:(void (^)(NSString *))failure
{
    NSLog(@"修改绑定!");
    NSArray *parameter = @[phone,email,verification];
    ChangeBindingAPI* api = [[ChangeBindingAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断修改绑定结果！");
        if (!error)
        {
            if([response isEqual: @"Success"]){
                NSLog(@"修改成功!");
                success();
            }else{
                NSLog(@"修改失败!");
                failure(@"修改失败");
            }
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"修改绑定失败!");
        }
    }];
}
@end
