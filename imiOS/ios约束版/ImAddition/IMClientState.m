//
//  IMClientState.m
//  im
//
//  Created by tongho on 16/7/27.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMClientState.h"
#import "AFNetworkReachabilityManager.h"
#import "LoginModule.h"


#define KscreenHeigh           [[UIScreen mainScreen] bounds].size.height
#define KscreenWidth           [[UIScreen mainScreen] bounds].size.width


@interface IMClientState(PrivateAPI)

- (void)n_receiveReachabilityChangedNotification:(NSNotification*)notification;
- (void)p_networkDisconnactShowView;

@end

@implementation IMClientState
+ (instancetype)shareInstance
{
    static IMClientState* g_clientState;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_clientState = [[IMClientState alloc] init];
    });
    return g_clientState;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _userState = IMUserOffLine; // 初始化用户状态为 IMUserOffLine
        _socketState = IMSocketDisconnect;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(n_receiveReachabilityChangedNotification:)
                                                     name:AFNetworkingReachabilityDidChangeNotification
                                                   object:nil];
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUseStateWithoutObserver:(IMUserState)userState
{
    _userState = userState;
}

#pragma mark - privateAPI
- (void)n_receiveReachabilityChangedNotification:(NSNotification*)notification
{
    AFNetworkReachabilityStatus netWorkStatus = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    switch (netWorkStatus)
    {
        case AFNetworkReachabilityStatusNotReachable:
            [self setValue:@(IMNetWorkDisconnect) forKeyPath:IM_NETWORK_STATE_KEYPATH];
            NSLog(@"无网络");
            [[IMClientState shareInstance] p_networkDisconnactShowView];
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            [self setValue:@(IMNetWorkWifi) forKeyPath:IM_NETWORK_STATE_KEYPATH];
            NSLog(@"wifi");
            // TODO...判断用户状态是否为online，是则重连
            if ([IMClientState shareInstance].userState == IMUserOnline) {

                [IMClientState shareInstance].userState = IMUserOffLine;
                [[LoginModule instance] reloginSuccess:^{
                    NSLog(@"切换至WiFi连接成功");
                } failure:^(NSString *error) {
                    NSLog(@"切换至WiFi连接失败");
                }];
            }
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            [self setValue:@(IMNetWork4G) forKeyPath:IM_NETWORK_STATE_KEYPATH];
            NSLog(@"移动数据");
            break;
        case AFNetworkReachabilityStatusUnknown:
            NSLog(@"网络状态：unknow");
            break;
    }
}

- (void)p_networkDisconnactShowView
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    NSString *msg = @"您的设备当前无网络连接";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无网提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {}];
    [alertController addAction:otherAction];
    [window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}
@end
