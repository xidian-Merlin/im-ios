//
//  UserModule.h
//  ImAddition
//
//  Created by tongho on 16/8/5.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "IMSuperAPI.h"
#import "IMUserEntity.h"

@interface ContactModule : NSObject

+ (instancetype)instance;

- (void)searchUser:(NSString*)userName
           success:(void(^)(NSArray* userArray))success
           failure:(void(^)(NSString* error))failure;

- (void)GetUserInfo:(int)userID
            success:(void(^)(IMUserEntity *user))success
            failure:(void(^)(NSString* error))failure;

- (void)addContact:(int)userID
              text:(NSString*)text
           success:(void(^)())success
           failure:(void(^)())failure;

- (void)replyRequest:(int)userID
           replyCode:(short)replyCode
                text:(NSString*)text
             success:(void(^)())success
             failure:(void(^)())failure;

- (void)getUserListsuccess:(void(^)(NSArray* userArray))success
                   failure:(void(^)(NSString* error))failure;

- (void)deleteContact:(int)userID
              success:(void(^)())success
              failure:(void(^)())failure;

- (void)changeRemark:(int)userID
              remark:(NSString*)remark
             success:(void(^)())success
             failure:(void(^)())failure;
@end
