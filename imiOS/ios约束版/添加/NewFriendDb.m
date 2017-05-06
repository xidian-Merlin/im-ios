//
//  NewFriendDb.m
//  ios约束版
//
//  Created by tongho on 16/8/4.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "NewFriendDb.h"
#import "JKDBHelper.h"
#import "historyHf.h"
#import "TimeConvert.h"
#import "Person.h"



@interface NewFriendDb()

@property (nonatomic, strong) JKDBHelper *shareInstance;

@end


@implementation NewFriendDb

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
        
        _tableName = [NSString stringWithFormat:@"%@%@", @"xdnf", nowUser.userName];
        
        
    }
    return self;
}


/**
 * 创建表
 * 如果已经创建，返回YES
 */
- (BOOL)createTable
{
    
    
    
    FMDatabase *db = [FMDatabase databaseWithPath:[JKDBHelper dbPath]];
    NSLog(@"%@",[JKDBHelper dbPath]);
    if (![db open]) {
        NSLog(@"数据库打开失败!");
        return NO;
    }

    
    NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
    
    
    // NSString *tableName1  = [NSString initWithFormat:@"%@,%@", _tableName, @"HF" ];
    
    NSString *columeAndType = @"id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, userId INTEGER NOT NULL, icon BLOB NOT NULL ,nickName text NOT NULL,nickName1 text NOT NULL,remarkName text NOT NULL, lastMessage text NOT NULL, date timestamp NOT NULL ,agreeFlag INTEGER NOT NULL ,isread INTEGER NOT NULL, tel text NOT NULL,email text NOT NULL";
    
    //可能会增加昵称，用nickname1 表示，此处nickname 就是表示用户名的意思
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",tableName1,columeAndType];
    if (![db executeUpdate:sql]) {
        return NO;
    }
    NSLog(@"%@表创建成功或者已经存在",tableName1);
    [db close];
    return YES;
}






-(void)saveHistoryFriend: (NSInteger)userId  userName:(NSString *)nickName nick:(NSString *)nickName1 remarkName:(NSString *)remarkName lastMessage:(NSString *)lastMessage icon:(NSData *)headimage time:(NSDate *)timestape agree:(int) agreeFlag  tel:(NSString *)tel  email:(NSString *)email isread:(int)isread;
{
    if (nickName != nil) {
        NSArray *result1 = [self search:(int)userId];
        if (result1.count == 0) {           //如果在数据库中没有该联系人，则保存它
            
            __block BOOL res = NO;
            [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
                
                NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
                NSString *keyString = @"userId, nickName, nickName1,remarkName,lastMessage,icon,date,agreeFlag,isread,tel,email";
                
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (?,?,?,?,?,?,?,?,?,?,?);", tableName1, keyString];
                res = [db executeUpdate:sql,[NSNumber numberWithInt:(int)userId], nickName, nickName1,remarkName, lastMessage,  headimage, timestape,[NSNumber numberWithInt:agreeFlag],[NSNumber numberWithInt:isread],tel,email];    //将会自动转化成时间戳
                if (!res) {
                    NSLog(@"error to insert data");
                } else {
                    NSLog(@"succ to insert data");
                }
                
            }];
        }
        
        else                                    //如果在会话数据库中该联系人已经存在，则更新该联系人的信息
        {                                       //UPDATE test_tab SET name=? WHERE name=?",@"123",@"佳"
            __block BOOL res = NO;
            [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
                
                NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
                NSString *keyString = @"nickName1 = ?,remarkName = ?,lastMessage = ?,icon = ?,date = ?,agreeFlag = ?,isread = ?, tel = ?,email= ?";
                
                NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE nickName = ?;", tableName1, keyString];
                res = [db executeUpdate:sql,nickName1,remarkName, lastMessage, headimage,timestape,[NSNumber numberWithInt:agreeFlag],[NSNumber numberWithInt:isread],tel,email,nickName];  //将会自动转化成时间戳
                if (!res) {
                    NSLog(@"error to insert data");
                } else {
                    NSLog(@"succ to insert data");
                }
                
            }];
        }
    }
    
}

//改变标知

-(void)set:(int)oldFlag  tonewFlag:(int)newFlag withCerify:(NSString *)cerify
{

    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ %@;", tableName1, cerify];
        res = [db executeUpdate:sql,[NSNumber numberWithInt:newFlag],[NSNumber numberWithInt:oldFlag]];  //将会自动转化成时间戳
        if (!res) {
            NSLog(@"error to update data");
        } else {
            NSLog(@"succ to update data");
        }
        
    }];


//SET %@ = ?WHERE %@ = ?

}





//下述三个查询可以合并成为一个
-(NSArray *) queryAll
{
    
    NSMutableArray *users = [NSMutableArray array];
    
    //   __block FMResultSet *resultSet = nil;
    
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        TimeConvert * timeConvert = [[TimeConvert alloc]init];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ order by date DESC;",tableName1]; //降序排列
        FMResultSet *resultSet = [db executeQuery:sql];
        
        
        while ([resultSet next]) {
            // int userId = [resultSet intForColumn:@"id"];
            historyHf * model = [[historyHf alloc]init];
            model.userId = [resultSet intForColumn:@"userId"];
            model.nickName= [resultSet stringForColumn:@"nickName"];
            model.nickName1= [resultSet stringForColumn:@"nickName1"];
            model.nickName2 = [resultSet stringForColumn:@"remarkName"];
            model.lastMessage = [resultSet stringForColumn:@"lastMessage"];
            model.icon = [resultSet dataForColumn:@"icon"];
            model.tel = [resultSet stringForColumn:@"tel"];
            model.email = [resultSet stringForColumn:@"email"];
            
            model.agreeFlag = [resultSet intForColumn:@"agreeFlag"];   //该申请是否已被同意
            
            model.isread = [resultSet intForColumn:@"isread"];
            NSDate *temTime = [resultSet dateForColumn:@"date"];
            //用于格式化NSDate对象
          
            //将时间与当前时间比较，显示刚刚，今天，昨天，与之前日期
            double beTime = [temTime timeIntervalSince1970];
            NSString *convertTime = [timeConvert distanceTimeWithBeforeTime:beTime];
            
            model.time = convertTime;
            
         
            
                    //賦值
            [users addObject:model];
            
            FMDBRelease(model);
            
        }
        
    }];
    
    return users;
}


//按照用户名查找联系人
-(NSArray *)search:(int)userId ;   //设置查找关键
{
    
    NSMutableArray *users = [NSMutableArray array];
    
    __block FMResultSet *resultSet = nil;
    
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        TimeConvert * timeConvert = [[TimeConvert alloc]init];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userId = ?;",tableName1];
        resultSet = [db executeQuery:sql,[NSNumber numberWithInt:userId]];
        
        
        while ([resultSet next]) {
            // int userId = [resultSet intForColumn:@"id"];
            historyHf * model = [[historyHf alloc]init];
            model.userId = [resultSet intForColumn:@"userId"];
            model.nickName= [resultSet stringForColumn:@"nickName"];
            model.nickName1= [resultSet stringForColumn:@"nickName1"];
            model.nickName2 = [resultSet stringForColumn:@"remarkName"];
            model.lastMessage = [resultSet stringForColumn:@"lastMessage"];
            model.icon = [resultSet dataForColumn:@"icon"];
            model.tel = [resultSet stringForColumn:@"tel"];
            model.email = [resultSet stringForColumn:@"email"];
            
            model.agreeFlag = [resultSet intForColumn:@"agreeFlag"];   //该申请是否已被同意
             model.isread = [resultSet intForColumn:@"isread"];
            NSDate *temTime = [resultSet dateForColumn:@"date"];
            //用于格式化NSDate对象
         //   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //将时间与当前时间比较，显示刚刚，今天，昨天，与之前日期
            double beTime = [temTime timeIntervalSince1970];
            NSString *convertTime = [timeConvert distanceTimeWithBeforeTime:beTime];
            
            model.time = convertTime;
            //賦值
            [users addObject:model];
            
            FMDBRelease(model);
            
        }
        
    }];
    
    return users;
    
    
}

//按照是否读取查找

-(NSArray *)searchIsread:(int)isread    //设置查找关键
{
    
    NSMutableArray *users = [NSMutableArray array];
    
    __block FMResultSet *resultSet = nil;
    
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        TimeConvert * timeConvert = [[TimeConvert alloc]init];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE isread = ? order by date DESC;",tableName1];
        resultSet = [db executeQuery:sql,[NSNumber numberWithInt:isread]];
        
        
        while ([resultSet next]) {
            // int userId = [resultSet intForColumn:@"id"];
            historyHf * model = [[historyHf alloc]init];
            model.userId = [resultSet intForColumn:@"userId"];
            model.nickName= [resultSet stringForColumn:@"nickName"];
            model.nickName1= [resultSet stringForColumn:@"nickName1"];
            model.nickName2 = [resultSet stringForColumn:@"remarkName"];
            model.lastMessage = [resultSet stringForColumn:@"lastMessage"];
            model.icon = [resultSet dataForColumn:@"icon"];
            model.tel = [resultSet stringForColumn:@"tel"];
            model.email = [resultSet stringForColumn:@"email"];
            
            model.agreeFlag = [resultSet intForColumn:@"agreeFlag"];   //该申请是否已被同意
            model.isread = [resultSet intForColumn:@"isread"];
            NSDate *temTime = [resultSet dateForColumn:@"date"];
            //用于格式化NSDate对象
            //   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //将时间与当前时间比较，显示刚刚，今天，昨天，与之前日期
            double beTime = [temTime timeIntervalSince1970];
            NSString *convertTime = [timeConvert distanceTimeWithBeforeTime:beTime];
            
            model.time = convertTime;
            //賦值
            [users addObject:model];
            
            FMDBRelease(model);
            
        }
        
    }];
    
    return users;
    
    
}









-(void) deleteFriendWithuserId:(int)userId      //根据用户id来删除对象
{
    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        NSString *criteria = @" WHERE userId = ?";
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@;",tableName1,criteria];
        
        res = [db executeUpdate:sql,[NSNumber numberWithInt:userId]];
        NSLog(res?@"删除成功":@"删除失败");
    }];
    //  return res;
}






@end

