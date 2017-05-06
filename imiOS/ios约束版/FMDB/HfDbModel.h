//
//  HfDbModel.h
//  ios约束版
//
//  Created by tongho on 16/8/7.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HfDbModel : NSObject  //历史会话表操作模型

@property (nonatomic, copy) NSString  *tableName;



//创表
- (BOOL)createTable;

//插入
//nickname:实际存的是备注名，没改名称
//最后一条消息，头像，最后消息的时间，好友ID，
//redcount :未读消息总数，即小红点显示的数
//style 1表示单聊，2表示群聊
-(void)saveHistoryFriend:(NSString *)nickName lastMessage:(NSString *)lastMessage icon:(NSData *)headimage time:(NSDate *)timestape  userId:(int)userId redCount:(int)redCount style:(int)style;


//查找
-(NSArray *)search:(int)userId style:(int)style;


-(NSArray *) queryAll;

-(void)setRedzeroWithuserId:(int)userId style:(int)style ;//将小红点值变为零

-(void) deleteFriendWithuserId:(int)userId  style:(int)style;

-(int) countAllred ;  //计算小红点的总数

//修改备注
-(void)set:(NSString *)newName  withUserId:(int)userId style:(int)style;

//修改头像
-(void)setIcon:(NSData*)newIcon withUserId:(int)userId style:(int)style;
//修改置顶时间，，方便置顶功能
-(void)setToptime:(NSDate *)setToptime  withUserId:(int)userId style:(int)style;


@end

