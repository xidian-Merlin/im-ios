//
//  UserModule.m
//  ImAddition
//
//  Created by yuhui wang on 16/8/5.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "UserModule.h"
#import "SearchUserAPI.h"
#import "GetUserInfoAPI.h"


@implementation UserModule

+ (instancetype)instance
{
    static UserModule *g_UserManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_UserManager = [[UserModule alloc] init];
    });
    return g_UserManager;
}

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

@end
