//
//  chatOperateClass.m
//  ios约束版
//
//  Created by tongho on 16/7/30.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "sChatDb.h"
#import "JKDBHelper.h"
#import "chatInfoModel.h"
#import "Person.h"

@interface sChatDb()   //为每一个用户建一堆消息表，每个表对应一个会话消息

@property (nonatomic, strong) JKDBHelper *shareInstance;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, assign)  int contacterId;


@end

@implementation sChatDb


//初始化对象
-(instancetype) init
{
    self = [super init];
    if (self) {
        //获取数据库单例对象
        
        _shareInstance = [JKDBHelper shareInstance];
        
        // 1.获得Documents的全路径
        NSString *nowDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        // 2.获得文件的全路径
        NSString *nowPath = [nowDoc stringByAppendingPathComponent:@"nowUser.data"]; //扩展名可以自己定义
        
        // 3.从文件中读取MJStudent对象，将nsdata转成对象
        Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];        //读取当前用户的用户名
        
        _tableName = [NSString stringWithFormat:@"%@%@", @"xdsc", nowUser.userName];
        
        
    
    }
    
    return self;
    
}


/**
 * 创建表
 * 如果已经创建，返回YES
 */
- (BOOL)createTableWithContacterId:(int)contactId
{
    
    _contacterId = contactId;
    FMDatabase *db = [FMDatabase databaseWithPath:[JKDBHelper dbPath]];
   // NSLog(@"%@",[JKDBHelper dbPath]);
    if (![db open]) {
        NSLog(@"数据库打开失败!");
        return NO;
    }
    
    //消息记录表名：xdsc+当前登录用户名＋聊天对象id＋HF;
    
    NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, contactId];
    
    NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
    
    // NSString *tableName1  = [NSString initWithFormat:@"%@,%@", _tableName, @"HF" ];
    
    NSString *columeAndType = @"id integer PRIMARY KEY AUTOINCREMENT,sendId integer NOT NULL,receiverId integer NOT NULL, content text NOT NULL, date TIMESTAMP NOT NULL, style integer NOT NULL,messageStyle integer NOT NULL, isFinished integer NOT NULL ,serverMessageId integer NOT NULL";
    //自己发送  sendID 可以賦值为零     , is_finished integer DEFAULT -1  , isread integer NOT NULL DEFAULT 0
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",tableName1,columeAndType];
    if (![db executeUpdate:sql]) {
        return NO;
    }
    NSLog(@"%@表创建成功或者已经存在",tableName1);
    [db close];
    return YES;
}





//

-(void)saveHistoryFriend:(int)sendId receiverId:(int)receiverId content:(NSString *)content style:(int)style date:(NSDate *)date
            messageStyle:(int)messageStyle isFinished:(int)isFinished serverMessageId:(int)serverMessageId
{
    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _contacterId];
        
        NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];

        NSString *keyString = @"sendId,receiverId,content,style,date,messageStyle,isFinished,serverMessageId";
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (?,?,?,?,?,?,?,?);", tableName1, keyString];
        res = [db executeUpdate:sql,[NSNumber numberWithInt:sendId], [NSNumber numberWithInt:receiverId],content, [NSNumber numberWithInt:style], date,[NSNumber numberWithInt:messageStyle],[NSNumber numberWithInt:isFinished],[NSNumber numberWithInt:serverMessageId]];
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"succ to insert data");
        }
        
    }];
  
}


//按照serverMessageId 修改content 与 isfinished

-(void) updatewihtId:(int) messageId newContent:(NSString *)content newFinishFlag:(BOOL)flag
{
    
    
    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _contacterId];
        
        NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
        
        NSString *keyString = @"content = ?,isFinished = ?";
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE serverMessageId = ?;", tableName1, keyString];
        res = [db executeUpdate:sql,content,[NSNumber numberWithBool:flag],[NSNumber numberWithInt:messageId]];  //将会自动转化成时间戳
        if (!res) {
            NSLog(@"error to update data");
        } else {
            NSLog(@"succ to update data");
        }
        
    }];



}


//按照Id  isfinished

-(void) updatewihtId:(int) messageId  newFinishFlag:(int)flag
{
    
    
    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _contacterId];
        
        NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
        
        NSString *keyString = @"isFinished = ?";
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE serverMessageId = ?;", tableName1, keyString];
        res = [db executeUpdate:sql,[NSNumber numberWithInt:flag],[NSNumber numberWithInt:messageId]];  //将会自动转化成时间戳
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"succ to insert data");
        }
        
    }];
    
    
    
}




-(NSArray *) queryPartWith:(int)nowId                //按照时间顺序来查找    此处设置分页查询每次读18条消息；
{
    
    NSMutableArray *users = [NSMutableArray array];
    
    //   __block FMResultSet *resultSet = nil;
    
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
   
      
        NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _contacterId];
        
        NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
  
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@  WHERE id > ? limit 18;",tableName1];
        FMResultSet *resultSet = [db executeQuery:sql,[NSNumber numberWithInt:(nowId -18)]];
        
        
        while ([resultSet next]) {
            // int userId = [resultSet intForColumn:@"id"];
            chatInfoModel * model = [[chatInfoModel alloc]init];
            
            model.date = [resultSet dateForColumn:@"date"];
            model.content = [resultSet stringForColumn:@"content"];
            model.messageStyle = [resultSet intForColumn:@"messageStyle"];
            model.style = [resultSet intForColumn:@"style"];
            model.sendId = [resultSet intForColumn:@"sendId"];
            model.receiverId = [resultSet intForColumn:@"receiverId"];
            model.isFinished = [resultSet intForColumn:@"isFinished"];
            model.messageId = [resultSet intForColumn:@"id"];
            model.serverMessageId = [resultSet intForColumn:@"serverMessageId"];
            
            
            //賦值
            [users addObject:model];
            FMDBRelease(model);
            
        }
        
    }];
 
    return users;
}

-(int)maxId{
     __block int maxId = -1;  //数据库中没有值的情况
    
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        //获取最后一条的
        
        NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _contacterId];
        
        NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT max(id) FROM %@ ;",tableName1];
        FMResultSet *resultSet = [db executeQuery:sql];
        
        
        while ([resultSet next]) {
            
             maxId = [resultSet intForColumnIndex:0];
            
        }
        
    }];
    
    return  maxId;      //返回最大的ID值



}

-(NSArray *) querryLast {


    
    NSMutableArray *users = [NSMutableArray array];
    
    //   __block FMResultSet *resultSet = nil;
    
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        
        NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _contacterId];
        
        NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ order by id DESC LIMIT 1;",tableName1];
        FMResultSet *resultSet = [db executeQuery:sql];
        
        
        while ([resultSet next]) {
            // int userId = [resultSet intForColumn:@"id"];
            chatInfoModel * model = [[chatInfoModel alloc]init];
            
            model.date = [resultSet dateForColumn:@"date"];
            model.content = [resultSet stringForColumn:@"content"];
            model.messageStyle = [resultSet intForColumn:@"messageStyle"];
            model.style = [resultSet intForColumn:@"style"];
            model.sendId = [resultSet intForColumn:@"sendId"];
            model.receiverId = [resultSet intForColumn:@"receiverId"];
            model.isFinished = [resultSet intForColumn:@"isFinished"];
            model.messageId = [resultSet intForColumn:@"id"];
            model.serverMessageId = [resultSet intForColumn:@"serverMessageId"];
            //賦值
            [users addObject:model];
            FMDBRelease(model);
            
        }
        
    }];
    
    return users;






}






-(void) deleteFriendWithNickName:(NSString *)nickName    //此处应为消息ID
{
    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _contacterId];
        
        NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@  WHERE nickName = ?;",tableName1];
        
        res = [db executeUpdate:sql,nickName];
        NSLog(res?@"删除成功":@"删除失败");
    }];
    //  return res;
}


@end
