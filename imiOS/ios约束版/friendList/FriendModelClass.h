//
//  FriendModelClass.h
//  MecoreMessageDemo
//
//  Created by tongho on 16/7/23.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryFriend.h"

@interface FriendModelClass : NSObject

//插入历史好友
-(void)saveHistoryFriend:(NSString *)nickName lastMessage:(NSString *)lastMessage icon:(NSData *)headimage time:(NSDate *)timestape;
-(NSArray *) queryAll;
-(void) deleteFriendWithNickName:(NSString *)nickName;
@end
