//
//  UserModule.h
//  ImAddition
//
//  Created by yuhui wang on 16/8/5.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMSuperAPI.h"
#import "IMUserEntity.h"

@interface UserModule : NSObject

+ (instancetype)instance;

- (void)searchUser:(NSString*)userName
           success:(void(^)(NSArray* userArray))success
           failure:(void(^)(NSString* error))failure;

- (void)GetUserInfo:(NSInteger)userID
            success:(void(^)(IMUserEntity *user))success
            failure:(void(^)(NSString* error))failure;

@end
