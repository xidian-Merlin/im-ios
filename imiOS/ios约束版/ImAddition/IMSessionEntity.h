//
//  IMSessionEntity.h
//  im
//
//  Created by yuhui wang on 16/7/18.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMUserEntity;

typedef enum{
    SESSIONTYPE_SINGLE = 1,          //单个用户会话
    SESSIONTYPE_TEMP_GROUP = 2,           //群会话
    SESSIONTYPE_GROUP =3
}SessionType;

@interface IMSessionEntity : NSObject
@property (nonatomic,retain         ) NSString    * sessionID;
@property (nonatomic,assign         ) SessionType sessionType;
@property (nonatomic,readonly       ) NSString    * name;
@property (assign                   ) NSInteger   unReadMsgCount;
@property (assign                   ) NSUInteger  timeInterval;
@property (assign                   ) BOOL        isShield;
@property (assign                   ) BOOL        isFixedTop;
@property (strong                   ) NSString    *lastMsg;
@property (assign                   ) NSInteger   lastMsgID;
@property (strong                   ) NSString    *avatar;

-(NSArray*)sessionUsers;
/**
 *  创建一个session，只需赋值sessionID和Type即可
 *
 *  @param sessionID 会话ID，群组传入groupid，p2p传入对方的userid
 *  @param type      会话的类型
 *
 *  @return
 */
- (id)initWithSessionID:(NSString*)sessionID
                   type:(SessionType)type;
- (id)initWithSessionID:(NSString*)sessionID
            SessionName:(NSString *)name
                   type:(SessionType)type;
- (id)initWithSessionIDByUser:(IMUserEntity*)user;
// - (id)initWithSessionIDByGroup:(IMGroupEntity*)group;
- (void)updateUpdateTime:(NSUInteger)date;
// -(NSString *)getSessionGroupID;
-(void)setSessionName:(NSString *)theName;
// -(BOOL)isGroup;
// -(id)dicToGroup:(NSDictionary *)dic;
-(void)setSessionUser:(NSArray *)array;
@end
