//
//  UserModule.m
//  ImAddition
//
//  Created by tongho on 16/8/5.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "ContactModule.h"
#import "SearchUserAPI.h"
#import "GetUserInfoAPI.h"
#import "AddContactAPI.h"
#import "FriendRequestAPI.h"
#import "AddUserResultAPI.h"
#import "ReplyRequestAPI.h"
#import "DeleteContactAPI.h"
#import "ChangeRemarkAPI.h"
#import "GetContactListAPI.h"
#import "IMNotification.h"
#import "IMConstant.h"
#import "IMUserEntity.h"
#import "ImdbModel.h"
#import "NewFriendDb.h"
#import "HfDbModel.h"


@implementation ContactModule

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerAPI];
    }
    return self;
}

+ (instancetype)instance
{
    static ContactModule *g_ContactManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_ContactManager = [[ContactModule alloc] init];
    });
    return g_ContactManager;
}
/**
 *  查找用户
 *
 *  @param userName 用户名（或部分用户名）
 *
 */
- (void)searchUser:(NSString*)userName
           success:(void(^)(NSArray* userArray))success
           failure:(void(^)(NSString* error))failure
{
    NSLog(@"查找好友!");
    NSString* parameter = userName;
    NSLog(@"将用户名传入做参数！");
    SearchUserAPI* api = [[SearchUserAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断搜索好友结果！");
        if (!error)
        {
            if(response != nil && ![response isKindOfClass:[NSNull class]] && ((NSArray*)response).count !=0){
                NSLog(@"搜索成功!");
                success(response);
            }else{
                NSLog(@"搜索失败!");
                failure(@"搜索失败!");
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure(@"搜索失败!");
        }
    }];
    
}
/**
 *  获取用户详细信息
 *
 *  @param userID  用户ID
 *
 */
- (void)GetUserInfo:(int)userID
            success:(void(^)(IMUserEntity *user))success
            failure:(void(^)(NSString* error))failure
{
    NSLog(@"获取用户信息!");
    NSNumber *parameter = [NSNumber numberWithInt:userID];
    NSLog(@"将用户ID:%@传入做参数！",parameter);
    GetUserInfoAPI *api = [[GetUserInfoAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断获取用户信息结果！");
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
/**
 *  添加好友申请
 *
 *  @param userID  用户ID
 *  @param text    验证文本信息
 *
 */
- (void)addContact:(int)userID
              text:(NSString*)text
           success:(void(^)())success
           failure:(void(^)())failure
{
    NSLog(@"添加好友!");
    NSNumber *ID = [NSNumber numberWithInt:userID];
    NSArray *parameter =@[ID,text];
    NSLog(@"将用户ID、文本消息传入做参数！");
    AddContactAPI *api = [[AddContactAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断好友请求发送结果！");
        if (!error)
        {
            if([response  isEqual: @"SendSuccess"]){
                NSLog(@"发送成功!");
                success();
            }else{
                NSLog(@"发送失败!");
                failure();
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure();
        }
    }];
}
/**
 *  回应好友申请
 *
 *  @param userID    用户ID
 *  @param replyCode 添加结果
 *  @param text      文本消息
 *
 */
- (void)replyRequest:(int)userID
           replyCode:(short)replyCode
                text:(NSString*)text
             success:(void(^)())success
             failure:(void(^)())failure
{
    NSLog(@"回应好友申请!");
    NSNumber *ID = [NSNumber numberWithInt:userID];
    NSNumber *result = [NSNumber numberWithShort:replyCode];
    NSArray *parameter =@[ID,result,text];
    NSLog(@"将用户ID、文本消息传入做参数！");
    ReplyRequestAPI *api = [[ReplyRequestAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断回应好友请求发送结果！");
        if (!error)
        {
            if([response  isEqual: @"ReplySuccess"]){
                NSLog(@"发送成功!");
                success();
            }else{
                NSLog(@"发送失败!");
                failure();
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure();
        }
    }];
}

- (void)getUserListsuccess:(void(^)(NSArray* userArray))success
                   failure:(void(^)(NSString* error))failure
{
    NSString* parameter = @"";
    GetContactListAPI* api = [[GetContactListAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断获取好友列表结果！");
        if (!error)
        {
            if(response != nil && ![response isKindOfClass:[NSNull class]] && ((NSArray*)response).count !=0){
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
- (void)deleteContact:(int)userID
              success:(void(^)())success
              failure:(void(^)())failure
{
    NSLog(@"删除好友!");
    NSNumber* parameter = [NSNumber numberWithInt:userID];
    NSLog(@"将用户名传入做参数！");
    DeleteContactAPI* api = [[DeleteContactAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断删除好友结果！");
        if (!error)
        {
            if([response isEqual: @"DeleteSuccess"]){
                NSLog(@"删除成功!");
                success();
            }else{
                NSLog(@"删除失败!");
                failure();
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure();
        }
    }];
}

- (void)changeRemark:(int)userID
              remark:(NSString*)remark
             success:(void(^)())success
             failure:(void(^)())failure
{
    NSLog(@"修改好友备注!");
    NSNumber *ID = [NSNumber numberWithInt:userID];
    NSArray* parameter = @[ID,remark];
    NSLog(@"将用户ID、备注传入做参数！");
    ChangeRemarkAPI* api = [[ChangeRemarkAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断修改备注结果！");
        if (!error)
        {
            if([response isEqual: @"ChangeSuccess"]){
                NSLog(@"修改成功!");
                success();
            }else{
                NSLog(@"修改失败!");
                failure();
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure();
        }
    }];
}

/**
 *  注册服务器推送消息接口
 *  1.好友申请，被添加
 *  2.好友申请结果，添加他人
 */
- (void)registerAPI
{
    // 1.好友申请，被添加
    FriendRequestAPI* friendRequestAPI = [[FriendRequestAPI alloc] init];
    [friendRequestAPI registerAPIInAPIScheduleReceiveData:^(id object, NSError *error) {
        if (!error)
        {
            NSLog(@"处理好友请求！");
            IMUserEntity* user = (IMUserEntity*)object[0];
            NSString* name = user.name;
            int userID = (int)user.ID;
            NSString* nick = user.nick;
            UIImage* avatar = user.avatar;
            if (nil == user.avatar) {
                avatar = [UIImage imageNamed:@"tn.9.png"];
            }
            NSData* avatarData;
            if (UIImagePNGRepresentation(avatar)) {
                avatarData = UIImagePNGRepresentation(avatar);
            }else {
                avatarData = UIImageJPEGRepresentation(avatar, 1.0);
            }
            NSString* text = object[1];
            NSDate* time = [NSDate date];
            // 存入数据库
            NSLog(@"存入数据库！");
            NewFriendDb* newFriendDb = [[NewFriendDb alloc]init];
            BOOL create = [newFriendDb createTable];
            if (create) {
                [newFriendDb saveHistoryFriend: (NSInteger)userID  userName:(NSString *)name nick:(NSString *)nick remarkName:(NSString *)nick lastMessage:(NSString *)text icon:(NSData *)avatarData time:(NSDate *)time agree:(int) 0  tel:(NSString *)@"未知"  email:(NSString *)@"未知" isread:0];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveFriendRequest object:nil];
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
        }
    }];
   
    // 2.好友申请结果，添加他人
    AddUserResultAPI* addUserResultAPI = [[AddUserResultAPI alloc] init];
    [addUserResultAPI registerAPIInAPIScheduleReceiveData:^(id object, NSError *error) {
        if (!error)
        {
            short result = [object[0] shortValue];
            NSLog(@"收到添加好友结果为：%d！",result);
            IMUserEntity* user = (IMUserEntity*)object[1];
            NSString* name = user.name;
            int userID = (int)user.ID;
            NSString* nick = user.nick;
            UIImage* avatar = user.avatar;
            NSData* avatarData;
            if (UIImagePNGRepresentation(avatar)) {
                avatarData = UIImagePNGRepresentation(avatar);
            }else {
                avatarData = UIImageJPEGRepresentation(avatar, 1.0);
            }
            NSDate* time = [NSDate date];
            NSString* text = object[2];
            // 存入数据库
            if (result == 0) {
                // 添加成功，存入联系人
                NSLog(@"添加成功，存入联系人!");
                ImdbModel* imdbModel = [[ImdbModel alloc] init];
                BOOL create = [imdbModel createTable];
                if (create) {
                    [imdbModel saveHistoryFriend:(NSString *)name userId:(int)userID nickName:(NSString *)nick remakeName:(NSString *)nick  lastMessage:(NSString *)text icon:(NSData *)avatarData tel:(NSString *)@"未知" email:(NSString *)@"未知"];
                }
                NSLog(@"添加成功，存入联系人!");
                [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationNewContact object:nil];
                // 存入历史会话
                NSLog(@"添加成功，存入历史会话!");
                HfDbModel* hfDbModel = [[HfDbModel alloc] init];
                BOOL create1 = [hfDbModel createTable];
                if (create1) {
                    [hfDbModel saveHistoryFriend:(NSString *)nick lastMessage:(NSString *)text icon:(NSData *)avatarData time:(NSDate *)time  userId:(int)userID redCount:(int)1 style:1];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:nil];
            } else {
                // 存入新的好友
                // 存入新的好友
                NSLog(@"拒绝添加，存入新的好友！");
                NewFriendDb* _imdbModel = [[NewFriendDb alloc]init];
                BOOL create2 = [_imdbModel createTable];
                if (create2) {
                    [_imdbModel saveHistoryFriend: (NSInteger)userID  userName:(NSString *)name nick:(NSString *)nick remarkName:(NSString *)nick lastMessage:(NSString *)text icon:(NSData *)avatarData time:(NSDate *)time agree:(int) 2  tel:(NSString *)@"未知"  email:(NSString *)@"未知" isread:0];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveFriendRequest object:nil];
            }
            
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
        }
    }];
}
@end
