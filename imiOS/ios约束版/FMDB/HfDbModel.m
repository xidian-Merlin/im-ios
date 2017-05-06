//
//  HfDbModel.m
//  ios约束版
//
//  Created by tongho on 16/8/7.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "HfDbModel.h"
#import "JKDBHelper.h"
#import "historyHf.h"
#import "TimeConvert.h"
#import "Person.h"

@interface HfDbModel()

@property (nonatomic, strong) JKDBHelper *shareInstance;
@property (nonatomic, strong) NSDate *detaildate;

@end


@implementation HfDbModel

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
        
        
        
        
        _tableName = [NSString stringWithFormat:@"%@%@", @"xdhh", nowUser.userName];
        
 
        
        
        
    }
    
    return self;
    
}


/**
 * 创建表
 * 如果已经创建，返回YES
 */
- (BOOL)createTable
{
    
    //手动设置一个默认的时间戳
    NSString *str=@"0";//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    _detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    
    
    FMDatabase *db = [FMDatabase databaseWithPath:[JKDBHelper dbPath]];
    NSLog(@"%@",[JKDBHelper dbPath]);
    if (![db open]) {
        NSLog(@"数据库打开失败!");
        return NO;
    }
    
    
    
    NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
    
    
    // NSString *tableName1  = [NSString initWithFormat:@"%@,%@", _tableName, @"HF" ];
    
    //NAME 为用户名  name1 为昵称   name2为备注
    NSString *columeAndType = @"id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, userId INTEGER NOT NULL, icon BLOB NOT NULL ,nickName text NOT NULL, lastMessage text NOT NULL, date timestamp NOT NULL, redCount INTEGER NOT NULL, style INTEGER NOT NULL, setTopDate timestamp NOT NULL";
    
    
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





-(void)saveHistoryFriend:(NSString *)nickName lastMessage:(NSString *)lastMessage icon:(NSData *)headimage time:(NSDate *)timestape  userId:(int)userId redCount:(int)redCount style:(int)style
{
    if (nickName != nil) {
        NSArray *result1 = [self search:userId style:style];
        if (result1.count == 0) {           //如果在数据库中没有该联系人，则保存它
            
            __block BOOL res = NO;
            [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
                
                NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
                NSString *keyString = @"userId,nickName,lastMessage,icon,date,redCount,style,setTopDate";
                
             
                
              
               
                
                
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (?,?,?,?,?,?,?,?);", tableName1, keyString];
                res = [db executeUpdate:sql,[NSNumber numberWithInt:userId],nickName, lastMessage,headimage,timestape,[NSNumber numberWithInt:redCount],[NSNumber numberWithInt:style],_detaildate];  //将会自动转化成时间戳
                if (!res) {
                    NSLog(@"error to insert data");
                } else {
                    NSLog(@"succ to insert data");
                }
                
            }];
        }
        
        else                                    //如果在会话数据库中该联系人已经存在，则更新该联系人的信息,
        {                                       //UPDATE test_tab SET name=? WHERE name=?",@"123",@"佳"
            __block BOOL res = NO;
            [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
                
                NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
                NSString *keyString = @"nickName = ?,lastMessage = ?,icon = ?,date = ?,redCount = ?";
                
                NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE userId = ? AND style = ?;", tableName1, keyString];
                res = [db executeUpdate:sql,nickName, lastMessage,  headimage, timestape,[NSNumber numberWithInt:redCount],[NSNumber numberWithInt:userId],[NSNumber numberWithInt:style]];  //将会自动转化成时间戳
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
    //置顶的成员数组
    NSMutableArray *topUsers = [NSMutableArray array];
    
    NSMutableArray *users = [NSMutableArray array];
    
    //   __block FMResultSet *resultSet = nil;
    
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        TimeConvert * timeConvert = [[TimeConvert alloc]init];
        
        //确定时间格式，若不写会采取默认值，从而出错
        
        /*    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
         [outputFormatter setLocale:[NSLocale currentLocale]];
         [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         [db setDateFormat:outputFormatter];
         */
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE setTopDate = ? order by date DESC;",tableName1]; //降序排列
        FMResultSet *resultSet = [db executeQuery:sql,_detaildate];
        
        
        while ([resultSet next]) {
            // int userId = [resultSet intForColumn:@"id"];
            historyHf * model = [[historyHf alloc]init];
            model.userId = [resultSet intForColumn:@"userId"];
            model.nickName= [resultSet stringForColumn:@"nickName"];
            model.lastMessage = [resultSet stringForColumn:@"lastMessage"];
            model.icon = [resultSet dataForColumn:@"icon"];
            model.redCount = [resultSet intForColumn:@"redCount"];
            model.style = [resultSet intForColumn:@"style"];
            model.topTime = [resultSet dateForColumn:@"setTopDate"];
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
    
  
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        TimeConvert * timeConvert = [[TimeConvert alloc]init];
        
        //确定时间格式，若不写会采取默认值，从而出错
        
   
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE setTopDate != ? order by setTopDate ;",tableName1]; //升序排列
        FMResultSet *resultSet1 = [db executeQuery:sql,_detaildate];
        
        
        while ([resultSet1 next]) {
            // int userId = [resultSet intForColumn:@"id"];
            historyHf * model1 = [[historyHf alloc]init];
            model1.userId = [resultSet1 intForColumn:@"userId"];
            model1.nickName= [resultSet1 stringForColumn:@"nickName"];
            model1.lastMessage = [resultSet1 stringForColumn:@"lastMessage"];
            model1.icon = [resultSet1 dataForColumn:@"icon"];
            model1.redCount = [resultSet1 intForColumn:@"redCount"];
            model1.style = [resultSet1 intForColumn:@"style"];
            model1.topTime = [resultSet1 dateForColumn:@"setTopDate"];
            NSDate *temTime = [resultSet1 dateForColumn:@"date"];
            
            //用于格式化NSDate对象
            //   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //将时间与当前时间比较，显示刚刚，今天，昨天，与之前日期
            double beTime1 = [temTime timeIntervalSince1970];
            NSString *convertTime1 = [timeConvert distanceTimeWithBeforeTime:beTime1];
            
            model1.time = convertTime1;
            
            //賦值
            [topUsers addObject:model1];
            
            FMDBRelease(model1);
            
        }
        
    }];

    //将置顶与非置顶拼接起来
    [topUsers addObjectsFromArray:users];
    
    return topUsers;
}


//按照用户ID查找联系人
-(NSArray *)search:(int)userId  style:(int)style
{
    
    NSMutableArray *users = [NSMutableArray array];
    
    __block FMResultSet *resultSet = nil;
    
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        TimeConvert * timeConvert = [[TimeConvert alloc]init];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userId = ? AND style = ?;",tableName1];
        resultSet = [db executeQuery:sql,[NSNumber numberWithInt:userId],[NSNumber numberWithInt:style]];
        
        
        while ([resultSet next]) {
            // int userId = [resultSet intForColumn:@"id"];
            historyHf * model = [[historyHf alloc]init];
            model.userId = [resultSet intForColumn:@"userId"];   //用户id ,用来唯一标识用户
            model.nickName= [resultSet stringForColumn:@"nickName"];
            model.lastMessage = [resultSet stringForColumn:@"lastMessage"];
            model.icon = [resultSet dataForColumn:@"icon"];
            model.redCount = [resultSet intForColumn:@"redCount"];
            model.style = [resultSet intForColumn:@"style"];
            NSDate *temTime = [resultSet dateForColumn:@"date"];
            
            //将时间与当前时间比较，显示刚刚，今天，昨天，与之前日期
            double beTime = [temTime timeIntervalSince1970];
            NSString *convertTime = [timeConvert distanceTimeWithBeforeTime:beTime];
            model.time = convertTime;
            NSLog(@"%@",temTime);
            //賦值
            [users addObject:model];
            
            FMDBRelease(model);
            
        }
        
    }];
    
    return users;
}

//修改备注
-(void)set:(NSString *)newName  withUserId:(int)userId style:(int)style {

    
    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET nickName = ? WHERE userId = ? AND style = ?;", tableName1];
        res = [db executeUpdate:sql,newName,[NSNumber numberWithInt:userId],[NSNumber numberWithInt:style]];
        if (!res) {
            NSLog(@"error to update data");
        } else {
            NSLog(@"succ to update data");
        }
        
    }];
    
}
//修改头像
-(void)setIcon:(NSData*)newIcon withUserId:(int)userId style:(int)style{

    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET icon = ? WHERE userId = ? AND style = ?;", tableName1];
        res = [db executeUpdate:sql,newIcon,[NSNumber numberWithInt:userId],[NSNumber numberWithInt:style]];
        if (!res) {
            NSLog(@"error to update data");
        } else {
            NSLog(@"succ to update data");
        }
        
    }];


}

//修改置顶时间，如果是默认时间1970，则为不置顶，如果不是1970，则为置顶时间
-(void)setToptime:(NSDate *)setToptime  withUserId:(int)userId style:(int)style {
    
    
    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET setTopDate = ? WHERE userId = ? AND style = ?;", tableName1];
        res = [db executeUpdate:sql,setToptime,[NSNumber numberWithInt:userId],[NSNumber numberWithInt:style]];
        if (!res) {
            NSLog(@"error to update data");
        } else {
            NSLog(@"succ to update data");
        }
        
    }];
    
}



    
-(void)setRedzeroWithuserId:(int)userId style:(int)style
{
    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET redCount = 0 WHERE userId = ?;", tableName1];
        res = [db executeUpdate:sql,[NSNumber numberWithInt:userId],[NSNumber numberWithInt:style]];  //将气泡数賦值为0
        if (!res) {
            NSLog(@"error to update data");
        } else {
            NSLog(@"succ to update data");
        }
        
    }];
    


}

-(int) countAllred {

   __block int totalCount =0;
    __block FMResultSet *resultSet = nil;
    
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        
              
        NSString *sql = [NSString stringWithFormat:@"SELECT sum(redCount) FROM %@ where redCount != 0;",tableName1];
        resultSet = [db executeQuery:sql];
        
        
        while ([resultSet next]) {
            
             totalCount = [resultSet intForColumnIndex:0];
                   }
        
    }];
    
    
    return totalCount;


}





-(void) deleteFriendWithuserId:(int)userId  style:(int)style    //根据用户id来删除对象
{
    __block BOOL res = NO;
    [_shareInstance.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName1 = [_tableName stringByAppendingString:@"HF"];
        NSString *criteria = @" WHERE userId = ? AND style = ?";
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@ ;",tableName1,criteria];
        
        res = [db executeUpdate:sql,[NSNumber numberWithInt:userId],[NSNumber numberWithInt:style]];
        NSLog(res?@"删除成功":@"删除失败");
    }];
    //  return res;
}






@end
