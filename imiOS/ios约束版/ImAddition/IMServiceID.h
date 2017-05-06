//
//  IMConstant.h
//  im
//
//  Created by yuhui wang on 16/7/16.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMServiceID : NSObject

// 登录类
extern short const NIM_ACCOUNT;

extern short const NIM_ACC_REGISTER;
extern short const NIM_ACC_LOG_IN;
extern short const NIM_ACC_FORGET_PWD;
extern short const NIM_ACC_LOG_OUT;
extern short const NIM_ACC_EXIT;

// 设置类
extern short const NIM_SETTING;

extern short const NIM_SET_RESET_PASSWORD;
extern short const NIM_SET_PORTRAIT;
extern short const NIM_SET_NICKNAME;
extern short const NIM_SET_LIMIT;
extern short const NIM_SET_BIND;

// 查、添、删好友
extern short const NIM_FUSER;

extern short const NIM_FUSER_SEARCH;
extern short const NIM_FUSER_ADD;
extern short const NIM_FUSER_DELETE;

// 好友操作
extern short const NIM_IUSER;

extern short const NIM_IUSER_FETCH;
extern short const NIM_IUSER_MODITY;
extern short const NIM_IUSER_QUERY;

// 单聊操作
extern short const NIM_MESSAGE;

extern short const NIM_MESS_TEXT;
extern short const NIM_MESS_PIC;
extern short const NIM_MESS_FILE;
extern short const NIM_MESS_RADIO;
extern short const NIM_MESS_VADIO;
extern short const NIM_MESS_VADIO_CALL;
extern short const NIM_MESS_RADIO_CALL;

// 群组操作
extern short const NIM_GROUP;

extern short const NIM_GRP_CREATE;
extern short const NIM_GRP_INVITE;
extern short const NIM_GRP_APPLY;
extern short const NIM_GRP_EXIT;
extern short const NIM_GRP_KICK;

// 群成员操作
extern short const NIM_MANAGE_GROUP;

extern short const NIM_GRP_GET_GROUPS;
extern short const NIM_GRP_GET_INFO;
extern short const NIM_GRP_GET_MEMBERS;
extern short const NIM_GRP_SET_MANAGER;
extern short const NIM_GRP_APPLY_MANAGER;
extern short const NIM_GRP_CHANGE_MEM_NICKNAME;
extern short const NIM_GRP_CHANGE_NAME;

// 群消息操作
extern short const NIM_GROUP_MESSAGE;

extern short const NIM_GRP_TEXT;
extern short const NIM_GRP_PIC;
extern short const NIM_GRP_FILE;
extern short const NIM_GRP_RADIO;
extern short const NIM_GRP_VADIO;
@end
