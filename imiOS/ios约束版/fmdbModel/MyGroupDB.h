//
//  MyGroupDB.h
//  ios约束版
//
//  Created by tongho on 16/8/18.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyGroupDB : NSObject

@property (nonatomic, copy) NSString  *tableName;


//创表 ：所有的表名都是根据用户名加特定字符，用来实现多用户登录
- (BOOL)createTable;

//插入
//群组名，群组id,群人数，

-(void)saveMygroup:(NSString *)groupName groupId:(int)groupId;


//查找
//按照群ID查找群
-(NSArray *)search:(int)groupId;

//由id查询所有群组
-(NSArray *) queryAll;


//修改群组名称
-(void)set:(NSString *)newName  withGroupId:(int)groupId;


//由ID删除群组
-(void) deleteGroupWithId:(int)groupId;
//删除数据表
-(void) deleteTable;


@end
