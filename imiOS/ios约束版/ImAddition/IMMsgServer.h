//
//  IMMsgServer.h
//  im
//
//  Created by tongho on 16/7/30.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IMMsgServer : NSObject
/**
 *  登录
 *
 *  @param userID  用户ID
 *  @param success 连接成功执行的block
 *  @param failure 连接失败执行的block
 */
-(void)checkUserID:(NSString*)userID
               Pwd:(NSString *)password
           success:(void(^)(NSArray* object))success
           failure:(void(^)(id object))failure;
/**
 *  注册
 *
 *  @param userID   用户ID
 *  @param password
 *  @param success
 *  @param failure  
 */
-(void)registerUserID:(NSString*)userID
                 nick:(NSString*)nick
                  Pwd:(NSString *)password
               avatar:(UIImage*)avatar
                phone:(NSString*)phone
                email:(NSString*)email
         verification:(NSString*)verification
              success:(void(^)(id object))success
              failure:(void(^)(id object))failure;

- (void)getVerificationWithUsername:(NSString*)name
                             method:(BOOL)method
                            account:(NSString*)account
                            success:(void(^)(id object))success
                            failure:(void(^)(id object))failure;
@end
