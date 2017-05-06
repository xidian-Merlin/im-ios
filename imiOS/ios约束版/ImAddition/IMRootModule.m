//
//  IMRootModule.m
//  im
//
//  Created by yuhui wang on 16/7/26.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMRootModule.h"
#import "IMClientState.h"
#import "IMClientStateMaintenanceManager.h"

@implementation IMRootModule
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _observerClientState = NO;
        _observerUserOnlineState = NO;
    }
    return self;
}

- (void)registObserveClientState
{
    _observerClientState = YES;
    [[IMClientState shareInstance] addObserver:self
                                    forKeyPath:IM_USER_STATE_KEYPATH
                                       options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                       context:nil];
}

- (void)registObserveNetWorkState
{
    _observerNetWorkState = YES;
    [[IMClientState shareInstance] addObserver:self
                                    forKeyPath:IM_NETWORK_STATE_KEYPATH
                                       options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                       context:nil];
}

-(void)registObserveUserOnlineState{
    _observerUserOnlineState=YES;
/*    [[StateMaintenanceManager instance] addObserver:self
                                         forKeyPath:IM_USER_ONLINE_STATE_KEYPATH
                                            options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];*/
}

- (void)dealloc
{
    if (_observerClientState)
    {
        [[IMClientState shareInstance] removeObserver:self
                                           forKeyPath:IM_USER_STATE_KEYPATH];
    }
    if (_observerNetWorkState)
    {
        [[IMClientState shareInstance] removeObserver:self
                                           forKeyPath:IM_NETWORK_STATE_KEYPATH];
    }
    
    if (_observerUserOnlineState) {
/*        [[StateMaintenanceManager instance] removeObserver:self
                                                forKeyPath:IM_USER_ONLINE_STATE_KEYPATH];*/
    }
}

#pragma mark -
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSAssert(NO, @"子类注册了KVO却没有实现KVO，class:%@",NSStringFromClass([self class]));
}

@end
