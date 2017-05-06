//
//  GroupMemeberDb.h
//  ios约束版
//
//  Created by tongho on 16/8/18.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupMemeberDb : NSObject

@property (nonatomic, copy) NSString  *tableName;


//创表 ：所有的表名都是根据用户名加特定字符，用来实现多用户登录
- (BOOL)createTableWithGroupId:(int)groupId;

//插入
//成员名，成员ID，成员头像，成员权限

-(void)saveMygroupMember:(NSString *)memberName memberId:(int)memberId  Icon:(NSData *)icon permit:(int)permit;


//查找
//按照群ID查找成员
-(NSArray *)search:(int)memberId;

//由id查询所有成员
-(NSArray *) queryAll;


-(void)setIcon:(NSData*)newIcon withMemberId:(int)memberId;

-(void)set:(NSString *)newName  withMemberId:(int)memberId ;

//由ID删除群成员
-(void) deleteMemberWithId:(int)memberId ;

-(void) deleteTable;




@end
