//
//  DDClientStateMaintenanceManager.m
//  im
//
//  Created by tongho on 16/7/27.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "IMClientStateMaintenanceManager.h"
#import "IMClientState.h"
#import "LoginModule.h"
#import "IMNotification.h"
#import "IMConstant.h"

static NSInteger const reloginTimeinterval = 2;

@interface IMClientStateMaintenanceManager(PrivateAPI)

//注册KVO
- (void)p_registerClientStateObserver;

//断线重连
- (void)p_startRelogin;
- (void)p_onReloginTimer:(NSTimer*)timer;
- (void)p_onReserverHeartTimer:(NSTimer*)timer; 

@end

@implementation IMClientStateMaintenanceManager
{
    NSTimer* _reloginTimer;
    NSUInteger _reloginInterval;
}
+ (instancetype)shareInstance
{
    static IMClientStateMaintenanceManager* g_clientStateManintenanceManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_clientStateManintenanceManager = [[IMClientStateMaintenanceManager alloc] init];
    });
    return g_clientStateManintenanceManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self p_registerClientStateObserver];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"IMClientStateMaintenanceManager release");
    [[IMClientState shareInstance] removeObserver:self
                                       forKeyPath:IM_NETWORK_STATE_KEYPATH];
    
    [[IMClientState shareInstance] removeObserver:self
                                       forKeyPath:IM_USER_STATE_KEYPATH];
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    IMClientState* clientState = [IMClientState shareInstance];
    //网络状态变化
    if ([keyPath isEqualToString:IM_NETWORK_STATE_KEYPATH])
    {
        if ([IMClientState shareInstance].networkState != IMNetWorkDisconnect)
        {
            
            BOOL shouldRelogin = !_reloginTimer && ![_reloginTimer isValid] && clientState.userState != IMUserOnline && clientState.userState != IMUserKickout && clientState.userState != IMUserOffLineInitiative;
            
            if (shouldRelogin)
            {
                NSLog(@"进入重连");
                _reloginTimer = [NSTimer scheduledTimerWithTimeInterval:reloginTimeinterval target:self selector:@selector(p_onReloginTimer:) userInfo:nil repeats:YES];
                _reloginInterval = 0;
                [_reloginTimer fire];
            }
        }else
        {
            clientState.userState=IMUserOffLine;
            NSLog(@"连接失败");
        }
    }
    //用户状态变化
    else if ([keyPath isEqualToString:IM_USER_STATE_KEYPATH])
    {
        switch ([IMClientState shareInstance].userState)
        {
            case IMUserKickout:
                //用户多端登录被挤掉线
                break;
            case IMUserOffLine:
                // 用户掉线
                [self p_startRelogin];
                break;
            case IMUserOffLineInitiative:
                // 用户主动下线
                break;
            case IMUserOnline:
                // 用户在线
                break;
            case IMUserLogining:
                // 用户正在登陆
                break;
        }
    }
}

#pragma mark private API

//注册KVO
- (void)p_registerClientStateObserver
{
    //网络状态
    [[IMClientState shareInstance] addObserver:self
                                    forKeyPath:IM_NETWORK_STATE_KEYPATH
                                       options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                       context:nil];
    
    //用户状态
    [[IMClientState shareInstance] addObserver:self
                                    forKeyPath:IM_USER_STATE_KEYPATH
                                       options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                       context:nil];
}





//开启重连Timer
- (void)p_startRelogin
{
    if (!_reloginTimer)
    {
        
        _reloginTimer = [NSTimer scheduledTimerWithTimeInterval:reloginTimeinterval target:self selector:@selector(p_onReloginTimer:) userInfo:nil repeats:YES];
        [_reloginTimer fire];
    }
}

//运行在断线重连的Timer上
- (void)p_onReloginTimer:(NSTimer*)timer
{
    
    static NSUInteger time = 0;
    static NSUInteger powN = 0;
    time ++;
    if (time >= _reloginInterval)
    {
        
        [[LoginModule instance] reloginSuccess:^{
            [_reloginTimer invalidate];
            _reloginTimer = nil;
            time=0;
            _reloginInterval = 0;
            powN = 0;
            [IMNotification postNotification:IMNotificationUserReloginSuccess userInfo:nil object:nil];
            NSLog(@"relogin success");
        } failure:^(NSString *error) {
            NSLog(@"relogin failure:%@",error);
            if ([error isEqualToString:@"未登录"]) {
                [_reloginTimer invalidate];
                _reloginTimer = nil;
                time = 0;
                _reloginInterval = 0;
                powN = 0;
            }else{                
                powN ++;
                time = 0;
                _reloginInterval = pow(2, powN);
            }
            
        }];
        
    }
}

@end
