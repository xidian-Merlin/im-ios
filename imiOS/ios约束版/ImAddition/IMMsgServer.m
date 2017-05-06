//
//  IMMsgServer.m
//  im
//
//  Created by yuhui wang on 16/7/30.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMMsgServer.h"
#import "LoginAPI.h"
#import "RegisterAPI.h"
#import "GetVerificationAPI.h"

typedef void(^CheckSuccess)(id object);
typedef void(^CheckFailure)(NSError* error);

@interface IMMsgServer(PrivateAPI)

- (void)n_receiveLoginMsgServerNotification:(NSNotification*)notification;
- (void)n_receiveLoginLoginServerNotification:(NSNotification*)notification;

@end

@implementation IMMsgServer
{
    CheckSuccess _success;
    CheckFailure _failure;
    
    BOOL _connecting;
    NSUInteger _connectTimes;
}
- (id)init
{
    self = [super init];
    if (self)
    {
        _connecting = NO;
        _connectTimes = 0;
    }
    return self;
}

//
-(void)checkUserID:(NSString*)userID
               Pwd:(NSString *)password
           success:(void(^)(NSArray* object))success
           failure:(void(^)(id object))failure
{
    NSLog(@"进入checkUserID!");
    if (!_connecting)
    {
        NSArray* parameter = @[userID,password];
        NSLog(@"将用户名密码传入数组做参数！");
        LoginAPI* api = [[LoginAPI alloc] init];
        [api requestWithObject:parameter Completion:^(NSArray* response, NSError *error) {
            
            
            if (!error)
            {
                if([response[0] isKindOfClass:[NSString class]]){
                    
                    success(response);
                }else{
                    NSString *errString = @"登录异常！";
                    NSError *error1 = [NSError errorWithDomain:errString code:(NSInteger)response userInfo:nil];
                    failure(error1);
                }
 
            }
            else
            {
                NSLog(@"error:%@",[error domain]);
                
                failure(error);
            }
        }];
    }
}

-(void)registerUserID:(NSString*)userID
                 nick:(NSString*)nick
                  Pwd:(NSString *)password
               avatar:(UIImage*)avatar
                phone:(NSString*)phone
                email:(NSString*)email
         verification:(NSString*)verification
              success:(void(^)(id object))success
              failure:(void(^)(id object))failure
{
    if (!_connecting)
    {
        NSArray* parameter = @[userID,password,nick,avatar,phone,email,verification];
        RegisterAPI* api = [[RegisterAPI alloc] init];
        [api requestWithObject:parameter Completion:^(id response, NSError *error) {
            NSLog(@"判断注册结果！");
            if (!error)
            {
                if ([response isKindOfClass:[NSString class]]) {
                    NSLog(@"%@",response);
                    success(response);
                }else{
                    NSLog(@"注册失败!");
                    NSString *errString = @"注册异常！";
                    NSError *error1 = [NSError errorWithDomain:errString code:(NSInteger)response userInfo:nil];
                    failure(error1);
                }
                
            }
            else
            {
                NSLog(@"error:%@",[error domain]);
                failure(error);
            }
        }];
    }
}

- (void)getVerificationWithUsername:(NSString *)name
                             method:(BOOL)method
                            account:(NSString *)account
                            success:(void (^)(id))success
                            failure:(void (^)(id))failure
{
    if (!_connecting) {
        NSNumber* flag = [NSNumber numberWithBool:method];
        NSArray* parameter = @[name,flag,account];
        GetVerificationAPI* api = [[GetVerificationAPI alloc]init];
        [api requestWithObject:parameter Completion:^(id response, NSError *error) {
            NSLog(@"判断获取验证码结果");
            if (!error) {
                if ([response isKindOfClass:[NSString class]]) {
                    //NSLog(@"获取验证码成功！");
                    success(response);
                } else {
                    NSLog(@"获取验证码失败！");
                    NSString *errString = @"获取验证码失败！";
                    NSError *error1 = [NSError errorWithDomain:errString code:(NSInteger)response userInfo:nil];
                    failure(error1);
                }
            } else {
                NSLog(@"error:%@",[error domain]);
                failure(error);
            }
        }];
    }
}
@end
