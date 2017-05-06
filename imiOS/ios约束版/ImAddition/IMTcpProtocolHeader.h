//
//  IMTcpProtocolHeader.h
//  im
//
//  Created by yuhui wang on 16/7/30.
//  Copyright © 2016年 yuhui wang. All rights reserved.
/*  H1 data format:
    protocol version    -- 1 byte   目前为“1”
    encrypt  type       -- 1 byte   1:公钥(登录前) 2:对称(登录后)
    service  type       -- 2 byte   目前用“1”
    datalength          -- 4 byte
    package  seqNo      -- 4 byte   登录前：任意值  登录后：自定义，服务器+1抗重发
 
    H2 data format:
    功能码               -- 2 byte
    功能子码             -- 2 byte
    包ID                -- 4 byte
 **********************************************************/
#import <Foundation/Foundation.h>

//SID
enum
{
    IM_ACCOUNT                 = 0x0101,
    IM_SETTING                 = 0x0102,
    IM_USER                    = 0x0103,
    IM_GROUP                   = 0x0104,
    IM_MESSAGE                 = 0x0105,
    IM_MANAGE_GROUP            = 0x0107,
    IM_GROUP_MESSAGE           = 0x0108
};

// IM_ACCOUNT
enum{
    IM_ACC_GET_VERIFICATION    = 0x0100,
    IM_ACC_REGISTER            = 0x0101,
    IM_ACC_LOG_IN              = 0x0200,
    IM_ACC_FORGET_PWD          = 0x0301,
    IM_ACC_LOG_OUT             = 0x0400
};

// IM_SETTING
enum{
    IM_SET_RESET_PASSWORD      = 0x0100,
    IM_SET_PORTRAIT            = 0x0200,
    IM_SET_NICKNAME            = 0x0300,
    IM_SET_LIMIT               = 0x0400,
    IM_SET_BIND                = 0x0500,
    IM_SET_CHANGEBIND          = 0x0501
};

// IM_USER
enum
{
    IM_USER_SEARCH            = 0x0100,
    IM_USER_ADD               = 0x0200,
    IM_USER_ADD_REQUEST       = 0x0201,
    IM_USER_ADD_RESULT        = 0x0202,
    IM_USER_ADDED_RESULT      = 0x0203,
    IM_USER_DELETE            = 0x0300,
    IM_USER_GET_LIST          = 0x0400,
    IM_USER_MODITY            = 0x0500,
    IM_USER_QUERY             = 0x0600
};

// IM_MESSAGE
enum
{
    IM_MESS_TEXT               = 0x0100,
    IM_MESS_RECEIVE_TEXT       = 0x0101,
    IM_MESS_PIC                = 0x0200,
    IM_MESS_RECEIVE_PIC        = 0x0201,
    IM_MESS_GET_FULL_PIC       = 0x0202,
    IM_MESS_FILE               = 0x0300,
    IM_MESS_RECEIVE_FILE       = 0x0301,
    IM_MESS_GET_FULL_FILE      = 0x0302,
    IM_MESS_SOUND              = 0x0400,
    IM_MESS_RECEIVE_SOUND      = 0x0401,
    IM_MESS_VADIO              = 0x0500,
    IM_MESS_RECEIVE_VADIO      = 0x0501,
    IM_MESS_GET_FULL_VADIO     = 0x0502,
    IM_MESS_VADIO_CALL         = 0x0600,
    IM_MESS_RADIO_CALL         = 0x0700,
    IM_MESS_GET_OFF_MSG        = 0x0800
};


// IM_GROUP
enum
{
    IM_GRP_CREATE              = 0x0100,
    IM_GRP_INVITE              = 0x0200,
    IM_GRP_QUIT                = 0x0300,
    IM_GRP_KICK                = 0x0400,
    IM_GRP_LIST                = 0x0500,
    IM_GRP_INFO                = 0x0600,
    IM_GRP_MEMBERS             = 0x0700,
    IM_GRP_CHANGE_MEM_REMARK   = 0x0800,
    IM_GRP_CHANGE_NAME         = 0x0900,
    IM_GRP_REC_CHANGE_NAME     = 0x0901
};

// IM_MANAGE_GROUP
enum
{
    IM_GRP_GET_GROUPS          = 0x0001,
    IM_GRP_GET_INFO            = 0x0002,
    IM_GRP_GET_MEMBERS         = 0x0003,
    IM_GRP_SET_MANAGER         = 0x0004,
    IM_GRP_APPLY_MANAGER       = 0x0005,
    IM_GRP_CHANGE_MEM_NICKNAME = 0x0006
};

// IM_GROUP_MESSAGE
enum
{
    IM_GRP_TEXT                = 0x0001,
    IM_GRP_PIC                 = 0x0002,
    IM_GRP_FILE                = 0x0003,
    IM_GRP_RADIO               = 0x0004,
    IM_GRP_VADIO               = 0x0005
};
@interface IMTcpProtocolHeader : NSObject

@property (nonatomic,assign) unsigned short commandID;
@property (nonatomic,assign) unsigned short subcommandID;
@property (nonatomic,assign) unsigned int packageID;
@end
