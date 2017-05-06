//
//  ImdbModel.h
//  ios约束版
//
//  Created by tongho on 16/7/30.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImdbModel : NSObject //我的好友数据表操作模型


@property (nonatomic, copy) NSString  *tableName;


//创表 ：所有的表名都是根据用户名加特定字符，用来实现多用户登录
- (BOOL)createTable;

//插入
//用户名，用户ID，昵称，备注名，
//lastmessage :原本是用来显示个性签名，但服务器并为提供，先保留
//用户头像，
//邮箱，电话，保留字段
-(void)saveHistoryFriend:(NSString *)userName userId:(int)userId nickName:(NSString *)nickName remakeName:(NSString *)remarkName  lastMessage:(NSString *)lastMessage icon:(NSData *)headimage tel:(NSString *)tel email:(NSString *)email;


//查找
//按照用户ID查找联系人
-(NSArray *)search:(int)userId;

//由id查询所有联系人
-(NSArray *) queryAll;


//修改备注
-(void)set:(NSString *)newName  withUserId:(int)userId;

//修改头像
-(void)setIcon:(NSData*)newIcon withUserId:(int)userId;

//由ID删除好友
-(void) deleteFriendWithuserId:(int)userId;


@end
