//
//  NewFriendDb.h
//  ios约束版
//
//  Created by tongho on 16/8/4.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewFriendDb : NSObject  //好友申请记录表操作模型

@property (nonatomic, copy) NSString  *tableName;


//创表
- (BOOL)createTable;

//插入
//agreeflag:三个值：同意，未同意，待验证
//isread:判断申请是否已读

-(void)saveHistoryFriend: (NSInteger)userId  userName:(NSString *)nickName nick:(NSString *)nickName1 remarkName:(NSString *)remarkName lastMessage:(NSString *)lastMessage icon:(NSData *)headimage time:(NSDate *)timestape agree:(int) agreeFlag  tel:(NSString *)tel  email:(NSString *)email isread:(int)isread;


//由用户id查找
-(NSArray *)search:(int)userId;


//查找所有未读消息
-(NSArray *)searchIsread:(int)isread ;

-(NSArray *) queryAll;


//直接賦值语句，操作某一属性的变化
-(void)set:(int)oldFlag  tonewFlag:(int)newFlag withCerify:(NSString *)cerify;   //将某一标志改变


-(void) deleteFriendWithuserId:(int)userId;


@end

