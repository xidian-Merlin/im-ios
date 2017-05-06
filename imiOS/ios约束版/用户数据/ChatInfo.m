//
//  ChatInfo.m
//  ios约束版
//
//  Created by tongho on 16/7/24.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "ChatInfo.h"
#import "FMDB.h"
#import"AppDelegate.h"

@interface ChatInfo ()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation ChatInfo



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //获取数据库文件
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *filename = [doc stringByAppendingString:@"chatInfo.sqlite"];
        
        //获取数据库
        FMDatabase *db = [FMDatabase databaseWithPath:filename];
        
        if ([db open]) {
            BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_chatInfo (id integer PRIMARY,sendID integer NOT NULL,receiverID integer NOT NULL, chatting text NOT NULL, date text NOT NULL, style integer NOT NULL, is_finished int DEFAULT -1, is_read int NOT NULL)"];
            
        if (result) {
            NSLog(@"创表成功");
          
                    }   else {
                                 NSLog(@"创表失败");
                             }
            }


    
    
            self.db = db;
      }
 
    return self;
 }


- (void)insert
{
    //[self.db executeUpdate:@"INSERT INTO t_chatInfo ()

}
- (void)deleteOne
{   // [self.db executeUpdate:@"DROP TABLE IF EXISTS" ]
}

- (void)queryAll
{
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_chatInfo"];
    
    while([resultSet next]) {
    
        int ID = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet stringForColumn:@"name"];
        NSLog(@"%d %@", ID, name);
    }
}

@end
