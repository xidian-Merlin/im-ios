//
//  LoginModule.m
//  im
//
//  Created by yuhui wang on 16/7/18.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "LoginModule.h"
#import "IMUserEntity.h"
#import "IMClientState.h"
#import "IMTCPserver.h"
#import "IMMsgServer.h"
#import "IMNotification.h"
#import "IMConstant.h"
#import "LogoutAPI.h"
#import "IMClientStateMaintenanceManager.h"

@interface LoginModule(privateAPI)

- (void)reloginAllFlowSuccess:(void(^)())success
                      failure:(void(^)())failure;

@end

@implementation LoginModule
{
    NSString* _lastLoginUser;       //最后登录的用户ID
    NSString* _lastLoginPassword;
    NSString* _lastLoginUserName;
    NSString* _priorIP;
    NSInteger _port;
    BOOL _relogining;
}
+ (instancetype)instance
{
    static LoginModule *g_LoginManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_LoginManager = [[LoginModule alloc] init];
    });
    return g_LoginManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _tcpServer = [[IMTCPServer alloc] init];
        _msgServer = [[IMMsgServer alloc] init];
        _relogining = NO;
    }
    return self;
}


#pragma mark Public API
// IMUserEntity* loginedUser
- (void)loginWithUsername:(NSString*)name
                 password:(NSString*)password
                  success:(void(^)(NSNumber* response))success
                  failure:(void(^)(NSString* error))failure
{
    _priorIP = _IP_ADDRESS_V4_;
    _port = _SERVER_PORT_;
    [_tcpServer loginTcpServerIP:_priorIP port:_port Success:^{
        NSLog(@"连接服务器成功！");
        [_msgServer checkUserID:name Pwd:password success:^(NSArray* object) {
            //
            //NSLog(@"登录成功、储存用户信息、数据库、如何如何……");
            //打开客户端状态管理、记录当前用户信息，更新客户端状态
            [IMClientStateMaintenanceManager shareInstance];
            
            _lastLoginUserName = name;
            _lastLoginPassword = password;
            IMClientState *clientState = [IMClientState shareInstance];
            clientState.userState = IMUserOnline;
            _relogining = YES;
            
            if (object.count > 1) {
                success(object[1]);
            }else{
                failure(object[0]);
            }
            
        }failure:^(NSError *object) {
            NSLog(@"login#登录验证失败");
            failure(object.domain);
        }];
        
    } failure:^{
        NSLog(@"连接服务器失败");
        failure(@"连接服务器失败");
    }];
}

- (void)logoutSuccess:(void (^)())success failure:(void (^)(NSString *))failure
{
    NSLog(@"退出登录!");
    NSString *parameter = @"";
    LogoutAPI* api = [[LogoutAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断退出结果！");
        if (!error)
        {
            if([response isEqual: @"成功"]){
                IMClientState *clientState = [IMClientState shareInstance];
                clientState.userState = IMUserOffLineInitiative;
                
                success();
            }else{
                NSLog(@"退出失败!");
                failure(response);
            }
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"退出失败!");
        }
    }];
}

- (void)reloginSuccess:(void(^)())success failure:(void(^)(NSString* error))failure
{
    NSLog(@"relogin fun,%lu",(unsigned long)[IMClientState shareInstance].userState);
    
    if ([IMClientState shareInstance].userState == IMUserOffLine && _lastLoginPassword && _lastLoginUserName) {
        
        [self loginWithUsername:_lastLoginUserName password:_lastLoginPassword success:^(NSNumber* response) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloginSuccess" object:nil];
            success();
        } failure:^(NSString *error) {
            failure(@"重新登陆失败");
        }];
    }
}

- (void)offlineCompletion:(void(^)())completion
{
    completion();
}

@end
