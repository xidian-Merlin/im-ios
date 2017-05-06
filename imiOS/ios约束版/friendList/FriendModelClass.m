//
//  FriendModelClass.m
//  MecoreMessageDemo
//
//  Created by tongho on 16/7/23.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "FriendModelClass.h"
#import"AppDelegate.h"

@interface FriendModelClass()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@implementation FriendModelClass
//初始化函数
- (instancetype)init
{
    self = [super init];
    if (self) {
        //获取对应的上下文
        UIApplication *application = [UIApplication sharedApplication];
        id delegate = [application delegate];
        self.managedObjectContext = [delegate managedObjectContext];
    }
    return self;
}

-(void)saveHistoryFriend:(NSString *)nickName lastMessage:(NSString *)lastMessage icon:(NSData *)headimage time:(NSDate *)timestape;
{
    //保存之前先做一个查询如果存在则更新，如果不存在则保存
    NSArray *result = [self search:nickName];
    
    HistoryFriend *myFirend;
    
    if (result.count == 0 )
    {
        //获取一个实体
        myFirend = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([HistoryFriend class]) inManagedObjectContext:self.managedObjectContext];
        myFirend.nickname = nickName;
        myFirend.lastMessage = lastMessage;
        myFirend.timestape = [NSDate date];
        myFirend.icon = headimage;
    }
    else
    {
        //更新
        myFirend = result[0];
        myFirend.timestape = [NSDate date];
        myFirend.lastMessage = lastMessage;
    }
    //存储实体
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"保存出错%@",[error localizedDescription]);
    }
}



-(NSArray *)search:(NSString *)nickName
{
    //创建查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([HistoryFriend class])];
    
    //添加查询谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nickname=%@",nickName];
    [request setPredicate:predicate];
    
    //执行查询
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    }
    return result;
}



-(NSArray *)queryAll
{
    //查询所有历史记录
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([HistoryFriend class])];
    
    //添加查询条件
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestape" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"查询出错%@",[error localizedDescription]);
    }
    
    return result;
}


-(void) deleteFriendWithNickName:(NSString *)nickName
{
    //通过nickname查询数据
    NSArray *result = [self search:nickName];
    if (result.count != 0)
    {
        HistoryFriend *friend = result[0];
        [self.managedObjectContext deleteObject:friend];
        
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        if (error) {
            NSLog(@"保存上下文%@",[error localizedDescription]);
        }
      
    }
}

@end
