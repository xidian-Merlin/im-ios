//
//  MessageModule.h
//  ImAddition
//
//  Created by yuhui wang on 16/8/11.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMessageEntity.h"
#import "UIKit/UIKit.h"

@interface MessageModule : NSObject

+ (instancetype)instance;
/**
 *  发送文本消息
 *
 *  @param userID      接收用户ID
 *  @param sessionType 会话类型：SessionTypeSingle 代表单聊，SessionTypeGroup 代表群聊
 *  @param text        文本消息
 *  @param success     成功后操作 参数object是一个数组:object[0]消息ID,object[1]中转时间
 *  @param failure     失败后操作
 */
- (void)sendTextToUser:(int)userID
           sessionType:(SessionType)sessionType
                  text:(NSString*)text
           success:(void(^)(NSArray* object))success
           failure:(void(^)())failure;
/**
 *  发送图片消息
 *
 *  @param userID      接收用户ID
 *  @param sessionType 会话类型
 *  @param pictureName 图片名
 *  @param picture     图片
 *  @param success     参数object是一个数组:object[0]消息ID,object[1]中转时间
 *  @param failure     
 */
- (void)sendPictureToUser:(int)userID
              sessionType:(SessionType)sessionType
              pictureName:(NSString*)pictureName
                  picture:(UIImage*)picture
                  success:(void(^)(NSArray* object))success
                  failure:(void(^)())failure;
/**
 *  获取完整图片
 *
 *  @param msgID   消息ID
 *  @param success
 *  @param failure
 */
- (void)getFullPictureWithMsgID:(long)msgID
                    sessionType:(int)sessionType
                        success:(void(^)(IMMessageEntity* msg))success
                        failure:(void(^)())failure;

- (void)sendFileToUser:(int)userID
           sessionType:(SessionType)sessionType
              fileName:(NSString*)fileName
              filePath:(NSString*)filePath
               success:(void(^)(NSArray* object))success
               failure:(void(^)())failure;

- (void)getFullFileWithMsgID:(long)msgID
                 sessionType:(int)sessionType
                     success:(void(^)(IMMessageEntity* msg))success
                     failure:(void(^)())failure;

- (void)sendSoundToUser:(int)userID
           sessionType:(SessionType)sessionType
             soundPath:(NSString*)soundPath
               success:(void(^)(NSArray* object))success
               failure:(void(^)())failure;

- (void)sendVadioToUser:(int)userID
            sessionType:(SessionType)sessionType
              vadioPath:(NSString*)vadioPath
                success:(void(^)(NSArray* object))success
                failure:(void(^)())failure;

- (void)getOfflineMessageSuccess:(void(^)())success
                         failure:(void(^)())failure;
@end
