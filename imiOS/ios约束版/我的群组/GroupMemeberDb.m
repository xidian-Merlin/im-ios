//
//  GroupMemeberDb.m
//  ios约束版
//
//  Created by tongho on 16/8/18.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "GroupMemeberDb.h"
#import "JKDBHelper.h"
#import "Person.h"
#import "GroupMemeberModel.h"


@interface  GroupMemeberDb()

@property (nonatomic, strong) JKDBHelper *shareInstance;
@property (nonatomic, assign) int groupId;

@end
@implementation GroupMemeberDb



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
        
        
        _tableName = [NSString stringWithFormat:@"%@%@", @"xdgml", nowUser.userName];  //西电群组成员
        
        
        
        
        
    }
    
    return self;
    
}


/**
 * 创建表
 * 如果已经创建，返回YES
 */
- (BOOL)createTableWithGroupId:(int)groupId    //我的群成员
{
    
    
    
    _groupId = groupId;
    FMDatabase *db = [FMDatabase databaseWithPath:[JKDBHelper dbPath]];
    // NSLog(@"%@",[JKDBHelper dbPath]);
    if (![db open]) {
        NSLog(@"数据库打开失败!");
        return NO;
    }
    
    
    NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _groupId];

    NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
    
    
    // NSString *tableName1  = [NSString initWithFormat:@"%@,%@", _tableName, @"HF" ];
    
    //NAME 为用户名  name1 为昵称   name2为备注
    NSString *columeAndType = @"id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, memberId INTEGER NOT NULL, icon BLOB NOT NULL ,memberName text NOT NULL , permit INTEGER not null";
    
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",tableName1,columeAndType];
    if (![db executeUpdate:sql]) {
        return NO;
    }
    
    NSLog(@"%@表创建成功或者已经存在",tableName1);
    [db close];
    return YES;
}





-(void)saveMygroupMember:(NSString *)memberName memberId:(int)memberId  Icon:(NSData *)icon permit:(int)permit


{
    if (memberName != nil) {
        NSArray *result1 = [self search:memberId];
        if (result1.count == 0) {           //如果在数据库中没有该联系人，则保存它
            
            __block BOOL res = NO;
            [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
                
                NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _groupId];
                
                NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
                NSString *keyString = @"memberName,memberId,icon,permit";
                
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (?,?,?,?);", tableName1, keyString];
                res = [db executeUpdate:sql,memberName,[NSNumber numberWithInt:memberId],icon,[NSNumber numberWithInt:permit]];
                if (!res) {
                    NSLog(@"error to insert data");
                } else {
                    NSLog(@"succ to insert data");
                }
                
            }];
        }
        
        else                                    //如果在会话数据库中该群组已经存在，则更新该联系人的信息, 暂时无权限
        {
            __block BOOL res = NO;
            [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
                
                NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _groupId];
                
                NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
                NSString *keyString = @"memberName=?,icon=?";
                
                NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE memberId = ?;", tableName1, keyString];
                res = [db executeUpdate:sql,memberName,icon,[NSNumber numberWithInt:memberId]];
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
        
        NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _groupId];
        
        NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
        
        
        
        //确定时间格式，若不写会采取默认值，从而出错
        
        /*    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
         [outputFormatter setLocale:[NSLocale currentLocale]];
         [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         [db setDateFormat:outputFormatter];
         */
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ order by id;",tableName1];
        FMResultSet *resultSet = [db executeQuery:sql];
        
        
        while ([resultSet next]) {
         
            GroupMemeberModel * model = [[GroupMemeberModel alloc]init];
            model.memberName = [resultSet stringForColumn:@"memberName"];
            model.memberId = [resultSet intForColumn:@"memberId"];
            
            model.icon = [resultSet dataForColumn:@"icon"];
            
            model.permit = [resultSet intForColumn:@"permit"];
            
            
            
            //賦值
            [users addObject:model];
            
            FMDBRelease(model);
            
        }
        
    }];
    
    return users;
}


//修改成员名
-(void)set:(NSString *)newName  withMemberId:(int)memberId {
    
    
    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _groupId];
        
        NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET memberName = ? WHERE memberId = ?;", tableName1];
        res = [db executeUpdate:sql,newName,[NSNumber numberWithInt:memberId]];
        if (!res) {
            NSLog(@"error to update data");
        } else {
            NSLog(@"succ to update data");
        }
        
    }];
    
}

//修改头像
-(void)setIcon:(NSData*)newIcon withMemberId:(int)memberId {
    
    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _groupId];
        
        NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET icon = ? WHERE memberId = ?;", tableName1];
        res = [db executeUpdate:sql,newIcon,[NSNumber numberWithInt:memberId]];
        if (!res) {
            NSLog(@"error to update data");
        } else {
            NSLog(@"succ to update data");
        }
        
    }];
    
    
}




//按照用户ID查找联系人
-(NSArray *)search:(int)memberId
{
    
    NSMutableArray *users = [NSMutableArray array];
    
    __block FMResultSet *resultSet = nil;
    
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _groupId];
        
        NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
        
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE memberId=?;",tableName1];
        
        resultSet = [db executeQuery:sql,[NSNumber numberWithInt:memberId]];
        
        
        
        while ([resultSet next]) {
            // int userId = [resultSet intForColumn:@"id"];
            GroupMemeberModel * model = [[GroupMemeberModel alloc]init];
            model.memberName = [resultSet stringForColumn:@"memberName"];
            model.memberId = [resultSet intForColumn:@"memberId"];
            
            model.icon = [resultSet dataForColumn:@"icon"];
            
             model.permit = [resultSet intForColumn:@"permit"];
            
            //賦值
            [users addObject:model];
            
            FMDBRelease(model);
            
        }
        
    }];
    
    return users;
    
}


-(void) deleteMemberWithId:(int)memberId     //根据用户id来删除对象
{
    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _groupId];
        
        NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
        NSString *criteria = @" WHERE memberId = ?";
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@;",tableName1,criteria];
        
        res = [db executeUpdate:sql, [NSNumber numberWithInt:memberId]];
        NSLog(res?@"删除成功":@"删除失败");
    }];
    //  return res;
}

//删除表
-(void) deleteTable {

    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName0 = [NSString stringWithFormat:@"%@%d", _tableName, _groupId];
        
        NSString *tableName1 = [tableName0 stringByAppendingString:@"HF"];
       NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF  EXISTS %@;",tableName1];
        
        res = [db executeUpdate:sql];
        NSLog(res?@"删除成功":@"删除失败");
    }];





}






@end
