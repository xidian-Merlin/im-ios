//
//  RegisterModule.m
//  ImAddition
//
//  Created by tongho on 16/8/4.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "RegisterModule.h"
#import "IMTCPServer.h"
#import "IMMsgServer.h"
#import "IMConstant.h"
#import "ForgetPWDAPI.h"

@implementation RegisterModule
{
    NSString* _priorIP;
    NSInteger _port;
}

+ (instancetype)instance
{
    static RegisterModule *g_registerManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_registerManager = [[RegisterModule alloc] init];
    });
    return g_registerManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _tcpServer = [[IMTCPServer alloc] init];
        _msgServer = [[IMMsgServer alloc] init];
    }
    return self;
}

- (void)registerWithUsername:(NSString*)name
                        nick:(NSString*)nick
                    password:(NSString*)password
                      avatar:(UIImage*)avatar
                       phone:(NSString*)phone
                       email:(NSString*)email
                verification:(NSString*)verification
                     success:(void(^)())success
                     failure:(void(^)(NSString* error))failure
{
    _priorIP = _IP_ADDRESS_V4_;
    _port = _SERVER_PORT_;
    [_tcpServer loginTcpServerIP:_priorIP port:_port Success:^{
        NSLog(@"连接服务器成功！");
        [_msgServer registerUserID:name nick:nick Pwd:password avatar:avatar phone:phone email:email verification:verification success:^(id response) {
            if ([response isEqualToString:@"成功"]) {
                success();
            }else{
                failure(response);
            }
        } failure:^(NSError* object) {
            NSLog(@"RegisterModule:注册失败");
            failure(object.domain);
        }];
        
    } failure:^{
        NSLog(@"连接消息服务器失败");
        failure(@"连接消息服务器失败");
    }];
}

- (void)getVerificationWithUsername:(NSString *)name
                             method:(BOOL)method
                            account:(NSString *)account
                            success:(void (^)())success
                            failure:(void (^)(NSString *))failure
{
    _priorIP = _IP_ADDRESS_V4_;
    _port = _SERVER_PORT_;
    [_tcpServer loginTcpServerIP:_priorIP port:_port Success:^{
        NSLog(@"连接服务器成功！");
        [_msgServer getVerificationWithUsername:name method:method account:account success:^(id response) {
            if ([response isEqualToString:@"成功"]) {
                success();
            }else{
                failure(response);
            }
            
        } failure:^(id object) {
            failure(@"获取失败");
        }];
    } failure:^{
        NSLog(@"连接消息服务器失败");
        failure(@"连接消息服务器失败");
    }];
}
- (void)setNewPasswordWithUserName:(NSString *)username
                       newPassword:(NSString *)newPassword
                             phone:(NSString *)phone
                             email:(NSString *)email
                      verification:(NSString *)verification
                           success:(void (^)())success
                           failure:(void (^)(NSString *))failure
{
    NSArray* parameter = @[username,newPassword,phone,email,verification];
    ForgetPWDAPI* api = [[ForgetPWDAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断重置密码结果！");
        if (!error)
        {
            if([response isEqual: @"Success"]){
                NSLog(@"成功!");
                success();
            }else{
                NSLog(@"失败!");
                NSString *errString = @"修改异常！";
                failure(errString);
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            
            failure(@"error");
        }
    }];
}
@end
