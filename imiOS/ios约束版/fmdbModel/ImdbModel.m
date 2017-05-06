//
//  ImdbModel.m
//  ios约束版
//
//  Created by tongho on 16/7/30.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "ImdbModel.h"
#import "JKDBHelper.h"
#import "historyHf.h"
#import "TimeConvert.h"
#import "Person.h"


@interface ImdbModel()

@property (nonatomic, strong) JKDBHelper *shareInstance;

@end


@implementation ImdbModel

//初始化对象
-(instancetype) init
{
    self = [super init];
    if (self) {
        //获取数据库单例对象
        
        _shareInstance = [JKDBHelper shareInstance];
        
       // [self createTable];
        
        
        
      //  db = [instance loadDB:DATABASE_NAME];
        //结果集
      //  FMResultSet *rs = nil;
        
        // 1.获得Documents的全路径
        NSString *nowDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        // 2.获得文件的全路径
        NSString *nowPath = [nowDoc stringByAppendingPathComponent:@"nowUser.data"]; //扩展名可以自己定义
        
        // 3.从文件中读取MJStudent对象，将nsdata转成对象
        Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];        //读取当前用户的用户名
        
        
        _tableName = [NSString stringWithFormat:@"%@%@", @"xdfl", nowUser.userName];  //西电朋友列表
        
        
        
        
        
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
   // NSLog(@"%@",[JKDBHelper dbPath]);
    if (![db open]) {
        NSLog(@"数据库打开失败!");
        return NO;
    }
    
    
    
    NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
    
    
   // NSString *tableName1  = [NSString initWithFormat:@"%@,%@", _tableName, @"HF" ];
    
    //NAME 为用户名  name1 为昵称   name2为备注
    NSString *columeAndType = @"id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, userId INTEGER NOT NULL, icon BLOB NOT NULL ,nickName text NOT NULL,nickName1 text NOT NULL,nickName2 text NOT NULL, lastMessage text NOT NULL,tel text NOT NULL,email text NOT NULL";
    
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",tableName1,columeAndType];
    if (![db executeUpdate:sql]) {
        return NO;
    }
    
    NSLog(@"%@表创建成功或者已经存在",tableName1);
        [db close];
    return YES;
}

/*   -(void)save:(NSData *)image ImageText:(NSString *)imageText
 {
 if (image != nil) {
 NSArray *result = [self search:imageText];
 
 HistoryImage *myImage;
 
 if (result.count == 0)
 {
 myImage = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([HistoryImage class]) inManagedObjectContext:self.manager];
 myImage.imageText = imageText;
 myImage.headerImage = image;
 myImage.time = [NSDate date];
 }
 else
 {
 myImage = result[0];
 myImage.time = [NSDate date];
 }
 
 //存储实体
 NSError *error = nil;
 if (![self.manager save:&error]) {
 NSLog(@"保存出错%@", [error localizedDescription]);
 }
 
 }
 
 }
 */





-(void)saveHistoryFriend:(NSString *)userName userId:(int)userId nickName:(NSString *)nickName remakeName:(NSString *)remarkName  lastMessage:(NSString *)lastMessage icon:(NSData *)headimage tel:(NSString *)tel email:(NSString *)email


{
    if (userName != nil) {
        NSArray *result1 = [self search:userId];
        if (result1.count == 0) {           //如果在数据库中没有该联系人，则保存它
    
      __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
          NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        NSString *keyString = @"nickName,userId,nickName1,nickName2,lastMessage,icon,tel,email";
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (?,?,?,?,?,?,?,?);", tableName1, keyString];
         res = [db executeUpdate:sql,userName,[NSNumber numberWithInt:userId], nickName,remarkName, lastMessage, headimage,tel,email];
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
              NSString *keyString = @"nickName=?,userId=?,nickName1=?,nickName2=?,lastMessage=?,icon=?,tel=?,email=?";
              
              NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE nickName = ?;", tableName1, keyString];
    res = [db executeUpdate:sql,userName,[NSNumber numberWithInt:userId], nickName,remarkName, lastMessage, headimage,tel,email,userName];  //将会自动转化成时间戳
              if (!res) {
                  NSLog(@"error to insert data");
              } else {
                  NSLog(@"succ to insert data");
              }
              
          }];
      }
    }

}

-(NSArray *) queryAll
{

    NSMutableArray *users = [NSMutableArray array];
    
   //   __block FMResultSet *resultSet = nil;
    
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
     NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        
        
        //确定时间格式，若不写会采取默认值，从而出错
        
    /*    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setLocale:[NSLocale currentLocale]];
        [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [db setDateFormat:outputFormatter];
        */
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ order by id;",tableName1]; 
        FMResultSet *resultSet = [db executeQuery:sql];
        
        
        while ([resultSet next]) {
           // int userId = [resultSet intForColumn:@"id"];
              historyHf * model = [[historyHf alloc]init];
           model.nickName= [resultSet stringForColumn:@"nickName"];
            model.userId = [resultSet intForColumn:@"userId"];
            model.nickName1= [resultSet stringForColumn:@"nickName1"];
            model.nickName2= [resultSet stringForColumn:@"nickName2"];
            model.lastMessage = [resultSet stringForColumn:@"lastMessage"];
            model.icon = [resultSet dataForColumn:@"icon"];
            model.tel = [resultSet stringForColumn:@"tel"];
            model.email = [resultSet stringForColumn:@"email"];
         
            
            
            
            //賦值
            [users addObject:model];
            
            FMDBRelease(model);
            
        }
        
    }];
    
    return users;
}


//修改备注
-(void)set:(NSString *)newName  withUserId:(int)userId {
    
    
    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET nickName2 = ? WHERE userId = ?;", tableName1];
        res = [db executeUpdate:sql,newName,[NSNumber numberWithInt:userId]];
        if (!res) {
            NSLog(@"error to update data");
        } else {
            NSLog(@"succ to update data");
        }
        
    }];
    
}

//修改头像
-(void)setIcon:(NSData*)newIcon withUserId:(int)userId {
    
    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET icon = ? WHERE userId = ?;", tableName1];
        res = [db executeUpdate:sql,newIcon,[NSNumber numberWithInt:userId]];
        if (!res) {
            NSLog(@"error to update data");
        } else {
            NSLog(@"succ to update data");
        }
        
    }];
    
    
}




//按照用户ID查找联系人
-(NSArray *)search:(int)userId
{
    
    NSMutableArray *users = [NSMutableArray array];
    
       __block FMResultSet *resultSet = nil;
    
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userId=?;",tableName1];
        
         resultSet = [db executeQuery:sql,[NSNumber numberWithInt:userId]];
        
        
        
        while ([resultSet next]) {
            // int userId = [resultSet intForColumn:@"id"];
            historyHf * model = [[historyHf alloc]init];
            model.nickName= [resultSet stringForColumn:@"nickName"];
            model.userId = [resultSet intForColumn:@"userId"];
            model.nickName1= [resultSet stringForColumn:@"nickName1"];
            model.nickName2= [resultSet stringForColumn:@"nickName2"];
            model.lastMessage = [resultSet stringForColumn:@"lastMessage"];
            model.icon = [resultSet dataForColumn:@"icon"];
            model.tel = [resultSet stringForColumn:@"tel"];
            model.email = [resultSet stringForColumn:@"email"];
            
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
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@ ;",tableName1,criteria];
        
        res = [db executeUpdate:sql, [NSNumber numberWithInt:userId]];
        NSLog(res?@"删除成功":@"删除失败");
    }];
    //  return res;
}

     
     
     
     


@end
