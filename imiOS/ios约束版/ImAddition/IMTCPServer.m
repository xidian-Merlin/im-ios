//
//  IMTCPserver.m
//  im
//
//  Created by yuhui wang on 16/7/18.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMTCPServer.h"
#import "IMConstant.h"
#import "IMTcpClientManager.h"

static NSInteger timeoutInterval = 10;

@interface IMTCPServer(notification)

- (void)n_receiveTcpLinkConnectCompleteNotification:(NSNotification*)notification;
- (void)n_receiveTcpLinkConnectFailureNotification:(NSNotification*)notification;

@end
@implementation IMTCPServer

{
    ClientSuccess _success;
    ClientFailure _failure;
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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(n_receiveTcpLinkConnectCompleteNotification:)
                                                     name:IMNotificationTcpLinkConnectComplete
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(n_receiveTcpLinkConnectFailureNotification:)
                                                     name:IMNotificationTcpLinkConnectFailure
                                                   object:nil];
        
    }
    return self;
}

- (void)loginTcpServerIP:(NSString*)ip
                    port:(NSInteger)point
                 Success:(void(^)())success
                 failure:(void(^)())failure
{
    if (!_connecting)
    {
        _connectTimes ++;
        _connecting = YES;
        _success = [success copy];
        _failure = [failure copy];
        [[IMTcpClientManager instance] disconnect];
        [[IMTcpClientManager instance] connect:ip port:point status:1];
        //超时处理
        NSUInteger nowTimes = _connectTimes;
        double delayInSeconds = timeoutInterval;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (_connecting && nowTimes == _connectTimes)
            {
                _connecting = NO;
                _failure(nil);
            }
        });
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMNotificationTcpLinkConnectComplete object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMNotificationTcpLinkConnectFailure object:nil];
}

#pragma mark - notification
- (void)n_receiveTcpLinkConnectCompleteNotification:(NSNotification*)notification
{
    if(_connecting)
    {
        _connecting = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            _success();
        });
    }
    
}

- (void)n_receiveTcpLinkConnectFailureNotification:(NSNotification*)notification
{
    if (_connecting)
    {
        _connecting = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            _failure(nil);
        });
    }
}
@end
