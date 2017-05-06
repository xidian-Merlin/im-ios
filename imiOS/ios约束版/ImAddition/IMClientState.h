//
//  IMClientState.h
//  im
//
//  Created by yuhui wang on 16/7/27.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用户状态
 */
typedef NS_ENUM(NSUInteger, IMUserState)
{
    /**
     *  用户在线
     */
    IMUserOnline,
    /**
     *  用户多端登录被挤下线
     */
    IMUserKickout,
    /**
     *  用户离线
     */
    IMUserOffLine,
    /**
     *  用户主动下线
     */
    IMUserOffLineInitiative,
    /**
     *  用户正在连接
     */
    IMUserLogining
};

/**
 *  客户端网络状态
 */
typedef NS_ENUM(NSUInteger, IMNetWorkState)
{
    /**
     *  wifi
     */
    IMNetWorkWifi,
    /**
     *  4G
     */
    IMNetWork4G,
    /**
     *  3G
     */
    IMNetWork3G,
    /**
     *  2G
     */
    IMNetWork2G,
    /**
     *  无网
     */
    IMNetWorkDisconnect
};

/**
 *  Socket 连接状态
 */
typedef NS_ENUM(NSUInteger, IMSocketState)
{
    /**
     *  Socket连接服务器
     */
    IMSocketLinkServer,
    /**
     *  Socket没有连接
     */
    IMSocketDisconnect
};

#define IM_USER_STATE_KEYPATH               @"userState"
#define IM_NETWORK_STATE_KEYPATH            @"networkState"
#define IM_SOCKET_STATE_KEYPATH             @"socketState"
#define IM_USER_ID_KEYPATH                  @"userID"

@class IMReachability;
@interface IMClientState : NSObject
{
    IMReachability* _reachability;
}
/**
 *  当前登录用户的状态
 */
@property(nonatomic,assign)IMUserState userState;

/**
 *  网络连接状态
 */
@property(nonatomic,assign)IMNetWorkState networkState;

/**
 *  Socket连接状态
 */
@property(nonatomic,assign)IMSocketState socketState;

/**
 *  当前登录用户的ID
 */
@property (nonatomic,retain)NSString* userID;

/**
 *  单例
 *
 *  @return 客户端状态机
 */
+ (instancetype)shareInstance;

- (void)setUseStateWithoutObserver:(IMUserState)userState;
@end
