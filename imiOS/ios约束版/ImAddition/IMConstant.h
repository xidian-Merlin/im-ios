//
//  IMConstant.h
//  im
//
//  Created by yuhui wang on 16/7/29.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMConstant : NSObject
// 10.170.67.201 111.204.219.246
#define _IP_ADDRESS_V4_ @"111.204.219.246"
#define _SERVER_PORT_ 16069

extern NSString* const IMNotificationTcpLinkConnectComplete;          //tcp连接建立完成
extern NSString* const IMNotificationTcpLinkConnectFailure;           //tcp连接建立失败
extern NSString* const IMNotificationTcpLinkDisconnect;               //tcp断开连接
extern NSString* const IMNotificationStartLogin;                      //用户开始登录
extern NSString* const IMNotificationUserLoginFailure;                //用户登录失败
extern NSString* const IMNotificationUserLoginSuccess;                //用户登录成功
extern NSString* const IMNotificationUserReloginSuccess;              //用户断线重连成功
extern NSString* const IMNotificationUserOffline;                     //用户离线
extern NSString* const IMNotificationUserKickouted;                   //用户被挤下线
extern NSString* const IMNotificationUserInitiativeOffline;           //用户主动离线
extern NSString* const IMNotificationLogout;                          //用户登出
extern NSString* const IMNotificationUserSignChanged;                 //用户签名修改广播
extern NSString* const IMNotificationRemoveSession;                   //移除会话成功之后的通知
extern NSString* const IMNotificationReceiveMessage;                  //收到一条消息
extern NSString* const IMNotificationReceiveFriendRequest;            //收到一条好友请求
extern NSString* const IMNotificationNewContact;                      //添加新联系人
extern NSString* const IMNotificationReloadTheRecentContacts;         //刷新最近联系人界面
extern NSString* const IMNotificationLoadLocalGroupFinish;            //本地最近联系群加载完成
extern NSString* const IMNotificationRecentContactsUpdate;            //最近联系人更新

@end
