//
//  GroupModule.m
//  ImAddition
//
//  Created by yuhui wang on 16/8/16.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "GroupModule.h"
#import "CreatGroupAPI.h"
#import "InviteToGroupAPI.h"
#import "QuitGroupAPI.h"
#import "KickFromGroupAPI.h"
#import "GetGroupListAPI.h"
#import "GetGroupInfoAPI.h"
#import "GetGroupMemberAPI.h"
#import "ChangeMemberRemarkAPI.h"
#import "ChangeGroupNameAPI.h"
#import "ReceiveGroupNameChangeAPI.h"

@implementation GroupModule

+ (instancetype)instance
{
    static GroupModule *g_GroupManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_GroupManager = [[GroupModule alloc] init];
    });
    return g_GroupManager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self registerAPI];
    }
    return self;
}

- (void)creatGroupWithName:(NSString*)name
                   success:(void(^)(NSNumber* ID))success
                   failure:(void(^)(NSString* error))failure
{
    NSLog(@"创建群组!");
    NSString* parameter = name;
    CreatGroupAPI* api = [[CreatGroupAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断创建群组结果！");
        if (!error)
        {
            if(response != nil){
                NSLog(@"创建成功，群ID：%d!",[response intValue]);
                success(response);
            }else{
                NSLog(@"创建失败!");
                failure(@"创建失败!");
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"创建失败!");
        }
    }];
}

- (void)inviteContactToGroupWithGroupID:(int)ID
                               contacts:(NSArray*)users
                                success:(void(^)(NSArray* object))success
                                failure:(void(^)(NSString* error))failure
{
    NSLog(@"邀请入群!");
    NSMutableArray* para = [NSMutableArray arrayWithObject:[NSNumber numberWithInt:ID]];
    [para addObject:[NSNumber numberWithUnsignedInteger:users.count]];
    [para addObjectsFromArray:users];
    NSArray* parameter = para;
    
    InviteToGroupAPI* api = [[InviteToGroupAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断邀请结果！");
        if (!error)
        {
            if(response != nil){
                NSLog(@"邀请成功，人数：%d!",[response[0] intValue]);
                success(response);
            }else{
                NSLog(@"邀请失败!");
                failure(@"邀请失败!");
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"邀请失败!");
        }
    }];
}

- (void)quitGroupWithGroupID:(int)ID
                     success:(void(^)())success
                     failure:(void(^)(NSString* error))failure
{
    NSLog(@"退出群组!");
    NSNumber* parameter = [NSNumber numberWithInt:ID];
    QuitGroupAPI* api = [[QuitGroupAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断退出群组结果！");
        if (!error)
        {
            if(response == 0){
                NSLog(@"退出成功!");
                success();
            }else{
                NSLog(@"退出失败!");
                failure(@"退出失败!");
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"退出失败!");
        }
    }];
}

- (void)kickUserWithGroupID:(int)groupID
                     userID:(int)userID
                    success:(void(^)())success
                    failure:(void(^)(NSString* error))failure
{
    NSLog(@"踢出群组!");
    NSNumber* grpID = [NSNumber numberWithInt:groupID];
    NSNumber* user = [NSNumber numberWithInt:userID];
    NSArray* parameter = @[grpID,user];
    KickFromGroupAPI* api = [[KickFromGroupAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断踢出群组结果！");
        if (!error)
        {
            if(response == 0){
                NSLog(@"踢出成功!");
                success();
            }else{
                NSLog(@"踢出失败!");
                failure(@"踢出失败!");
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"踢出失败!");
        }
    }];
}

- (void)getGroupListSuccess:(void(^)(NSArray* object))success
                    failure:(void(^)(NSString* error))failure
{
    NSLog(@"获取群组列表!");
    NSString* parameter = @"";
    GetGroupListAPI* api = [[GetGroupListAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断获取群组列表结果！");
        if (!error)
        {
            if(response != nil){
                NSLog(@"获取成功!");
                success(response);
            }else{
                NSLog(@"获取失败!");
                failure(@"获取失败!");
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"获取失败!");
        }
    }];
}

- (void)getGroupInfoWithID:(int)ID
                   success:(void(^)(IMGroupEntity* group))success
                   failure:(void(^)(NSString* error))failure
{
    NSLog(@"获取群信息!");
    NSNumber* parameter = [NSNumber numberWithInt:ID];
    GetGroupInfoAPI* api = [[GetGroupInfoAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断获取群信息结果！");
        if (!error)
        {
            if(response != nil){
                NSLog(@"获取成功!");
                success(response);
            }else{
                NSLog(@"获取失败!");
                failure(@"获取失败!");
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"获取失败!");
        }
    }];
}

- (void)getGroupMemberListWithID:(int)ID
                         success:(void(^)(NSArray* memberList))success
                         failure:(void(^)(NSString* error))failure
{
    NSLog(@"获取群成员列表!");
    NSNumber* parameter = [NSNumber numberWithInt:ID];
    GetGroupMemberAPI* api = [[GetGroupMemberAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断获取群成员列表结果！");
        if (!error)
        {
            if(response != nil){
                NSLog(@"获取成功!");
                success(response);
            }else{
                NSLog(@"获取失败!");
                failure(@"获取失败!");
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"获取失败!");
        }
    }];
}

- (void)changeMemberRemarkWithID:(int)ID
                          remark:(NSString*)remark
                         success:(void(^)())success
                         failure:(void(^)(NSString* error))failure
{
    NSLog(@"修改群个人备注!");
    NSNumber* grpID = [NSNumber numberWithInt:ID];
    NSArray* parameter = @[grpID,remark];
    ChangeMemberRemarkAPI* api = [[ChangeMemberRemarkAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断修改结果！");
        if (!error)
        {
            if(response == 0){
                NSLog(@"修改成功!");
                success();
            }else{
                NSLog(@"修改失败!");
                failure(@"修改失败!");
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"修改失败!");
        }
    }];
}

- (void)changeGroupNameWithGroupID:(int)groupID
                            userID:(int)userID
                           newName:(NSString*)newName
                           success:(void(^)())success
                           failure:(void(^)(NSString* error))failure
{
    NSLog(@"修改群名!");
    NSNumber* grpID = [NSNumber numberWithInt:groupID];
    NSNumber* uID = [NSNumber numberWithInt:userID];
    NSArray* parameter = @[grpID,uID,newName];
    
    ChangeGroupNameAPI* api = [[ChangeGroupNameAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断修改结果！");
        if (!error)
        {
            if(response == 0){
                NSLog(@"修改成功!");
                success();
            }else{
                NSLog(@"修改失败!");
                failure(@"修改失败!");
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"修改失败!");
        }
    }];
}

- (void)registerAPI
{
    ReceiveGroupNameChangeAPI* receiveGroupNameChangeAPI = [[ReceiveGroupNameChangeAPI alloc] init];
    [receiveGroupNameChangeAPI registerAPIInAPIScheduleReceiveData:^(id object, NSError *error) {
        if (!error)
        {
            NSLog(@"处理接收群名修改！");
            int groupID = [object[0] intValue];
            int userID = [object[1] intValue];
            NSString* newName = object[2];
            // 存入数据库 TODO...存入数据库、发出通知
            NSLog(@"存入数据库！");
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:nil];
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
        }
    }];
}
@end
