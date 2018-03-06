//
//  GroupModule.h
//  ImAddition
//
//  Created by tongho on 16/8/16.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMGroupEntity.h"

@interface GroupModule : NSObject

+ (instancetype)instance;
/**
 *  创建群组
 *
 *  @param name    群组名
 *  @param success
 *  @param failure
 */
- (void)creatGroupWithName:(NSString*)name
                   success:(void(^)(NSNumber* ID))success
                   failure:(void(^)(NSString* error))failure;
/**
 *  邀请入群
 *
 *  @param ID      群ID
 *  @param users   要邀请的用户数组
 *  @param success
 *  @param failure
 */
- (void)inviteContactToGroupWithGroupID:(int)ID
                               contacts:(NSArray*)users
                                success:(void(^)(NSArray* object))success
                                failure:(void(^)(NSString* error))failure;

/**
 *  退出群组
 *
 *  @param ID      群ID
 *  @param success
 *  @param failure
 */
- (void)quitGroupWithGroupID:(int)ID
                     success:(void(^)())success
                     failure:(void(^)(NSString* error))failure;

/**
 *  踢出群组
 *
 *  @param ID      用户ID
 *  @param success
 *  @param failure
 */
- (void)kickUserWithGroupID:(int)groupID
                     userID:(int)userID
                    success:(void(^)())success
                    failure:(void(^)(NSString* error))failure;
/**
 *  获取群列表
 *
 *  @param success
 *  @param failure
 */
- (void)getGroupListSuccess:(void(^)(NSArray* object))success
                    failure:(void(^)(NSString* error))failure;

/**
 *  获取群信息
 *
 *  @param ID      群ID
 *  @param success
 *  @param failure
 */
- (void)getGroupInfoWithID:(int)ID
                   success:(void(^)(IMGroupEntity* group))success
                   failure:(void(^)(NSString* error))failure;
/**
 *  获取群成员列表
 *
 *  @param ID      群ID
 *  @param success
 *  @param failure
 */
- (void)getGroupMemberListWithID:(int)ID
                         success:(void(^)(NSArray* memberList))success
                         failure:(void(^)(NSString* error))failure;
/**
 *  修改群个人备注
 *
 *  @param ID      群ID
 *  @param remark  备注
 *  @param success
 *  @param failure
 */
- (void)changeMemberRemarkWithID:(int)ID
                          remark:(NSString*)remark
                         success:(void(^)())success
                         failure:(void(^)(NSString* error))failure;
/**
 *  修改群名
 *
 *  @param groupID 群ID
 *  @param userID  用户ID
 *  @param newName 新群名
 *  @param success
 *  @param failure
 */
- (void)changeGroupNameWithGroupID:(int)groupID
                            userID:(int)userID
                           newName:(NSString*)newName
                           success:(void(^)())success
                           failure:(void(^)(NSString* error))failure;
@end
