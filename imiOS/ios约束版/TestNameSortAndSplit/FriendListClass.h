//
//  FriendListClass.h
//  ios约束版
//
//  Created by tongho on 16/7/23.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendList.h"

@interface FriendListClass : NSObject

//插入新增好友
-(void)saveFriend:(NSString *)nickName  icon:(NSData *)headimage ;
-(NSArray *) queryAll;
-(void) deleteFriendWithNickName:(NSString *)nickName;


@end


