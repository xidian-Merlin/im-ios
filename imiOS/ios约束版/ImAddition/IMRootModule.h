//
//  IMRootModule.h
//  im
//
//  Created by yuhui wang on 16/7/26.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMRootModule : NSObject
@property (nonatomic,assign,readonly)BOOL observerClientState;
@property (nonatomic,assign,readonly)BOOL observerNetWorkState;
@property (nonatomic,assign,readonly)BOOL observerDataSate;
@property (nonatomic,assign,readonly)BOOL observerUserOnlineState;
/**
 *  注册观察用户登录状态
 */
- (void)registObserveClientState;

/**
 *  注册观察网络状态
 */
- (void)registObserveNetWorkState;

/**
 * 注册观察用户在线状态
 */
- (void)registObserveUserOnlineState;
@end
