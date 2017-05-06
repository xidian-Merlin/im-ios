//
//  IMConstant.m
//  im
//
//  Created by yuhui wang on 16/7/16.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMServiceID.h"

@implementation IMServiceID
// 登录类
short const NIM_ACCOUNT                 = 0x0101;

short const NIM_ACC_REGISTER            = 0x0001;
short const NIM_ACC_LOG_IN              = 0x0002;
short const NIM_ACC_FORGET_PWD          = 0x0003;
short const NIM_ACC_LOG_OUT             = 0x0004;
short const NIM_ACC_EXIT                = 0x0005;

// 设置类
short const NIM_SETTING                 = 0x0102;

short const NIM_SET_RESET_PASSWORD      = 0x0001;
short const NIM_SET_PORTRAIT            = 0x0002;
short const NIM_SET_NICKNAME            = 0x0003;
short const NIM_SET_LIMIT               = 0x0004;
short const NIM_SET_BIND                = 0x0005;

// 查、添、删好友
short const NIM_FUSER                   = 0x0103;

short const NIM_FUSER_SEARCH            = 0x0001;
short const NIM_FUSER_ADD               = 0x0002;
short const NIM_FUSER_DELETE            = 0x0003;

// 好友操作
short const NIM_IUSER                   = 0x0104;

short const NIM_IUSER_FETCH             = 0x0001;
short const NIM_IUSER_MODITY            = 0x0002;
short const NIM_IUSER_QUERY             = 0x0003;

// 单聊操作
short const NIM_MESSAGE                 = 0x0105;

short const NIM_MESS_TEXT               = 0x0001;
short const NIM_MESS_PIC                = 0x0002;
short const NIM_MESS_FILE               = 0x0003;
short const NIM_MESS_RADIO              = 0x0004;
short const NIM_MESS_VADIO              = 0x0005;
short const NIM_MESS_VADIO_CALL         = 0x0006;
short const NIM_MESS_RADIO_CALL         = 0x0007;

// 群组操作
short const NIM_GROUP                   = 0x0106;

short const NIM_GRP_CREATE              = 0x0001;
short const NIM_GRP_INVITE              = 0x0002;
short const NIM_GRP_APPLY               = 0x0003;
short const NIM_GRP_EXIT                = 0x0004;
short const NIM_GRP_KICK                = 0x0005;

// 群成员操作
short const NIM_MANAGE_GROUP            = 0x0107;

short const NIM_GRP_GET_GROUPS          = 0x0001;
short const NIM_GRP_GET_INFO            = 0x0002;
short const NIM_GRP_GET_MEMBERS         = 0x0003;
short const NIM_GRP_SET_MANAGER         = 0x0004;
short const NIM_GRP_APPLY_MANAGER       = 0x0005;
short const NIM_GRP_CHANGE_MEM_NICKNAME = 0x0006;
short const NIM_GRP_CHANGE_NAME         = 0x0007;

// 群消息操作
short const NIM_GROUP_MESSAGE           = 0x0108;

short const NIM_GRP_TEXT                = 0x0001;
short const NIM_GRP_PIC                 = 0x0002;
short const NIM_GRP_FILE                = 0x0003;
short const NIM_GRP_RADIO               = 0x0004;
short const NIM_GRP_VADIO               = 0x0005;
@end
