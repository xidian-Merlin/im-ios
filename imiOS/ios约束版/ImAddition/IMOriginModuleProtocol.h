//
//  IMOriginModuleProtocol.h
//  im
//
//  Created by yuhui wang on 16/7/26.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^IMGetOriginsInfoCompletion)(NSArray* origins,NSError* error);

@class IMOriginEntity;
@protocol IMOriginModuleProtocol <NSObject>

@required
/**
 *  添加待维护的原始类型
 *
 *  @param originEntities 原始类型数据
 */
- (void)addMaintainOriginEntities:(NSArray*)originEntities;

/**
 *  根据OriginID获取实体类
 *
 *  @param originID originID
 *
 *  @return 实体类
 */
- (IMOriginEntity*)getOriginEntityWithOriginID:(NSString*)originID;

/**
 *  在本地没有相应信息的时候调用此接口，从后端获取
 *
 *  @param originIDs  originIDs
 *  @param completion 完成获取
 */
- (void)getOriginEntityWithOriginIDsFromRemoteCompletion:(NSArray*)originIDs
                                              completion:(IMGetOriginsInfoCompletion)completion;

/**
 *  移除Origins
 *
 *  @param originID originIDs
 */
- (void)removeOriginForIDs:(NSArray*)originIDs;

/**
 *  获取所有维护的实体
 *
 *  @return 所有维护的实体
 */
- (NSArray*)getAllOriginEntity;


@optional
/**
 *  添加屏蔽的Origin
 *
 *  @param groupID 待屏蔽的OriginIDs
 */
- (void)addShieldOrigins:(NSArray*)originIDs;

/**
 *  取消屏蔽的Origin
 *
 *  @param groupID 待取消屏蔽的Origin
 */
- (void)cancelShieldOrigins:(NSArray*)originIDs;

/**
 *  是否是被屏蔽的
 *
 *  @param originID originID
 *
 *  @return 屏蔽状态
 */
- (BOOL)shieldForOrigin:(NSString*)originID;

@end
