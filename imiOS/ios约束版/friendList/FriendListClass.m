//
//  FriendListClass.m
//  ios约束版
//
//  Created by tongho on 16/7/23.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "FriendListClass.h"
#import"AppDelegate.h"

@interface FriendListClass()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@implementation FriendListClass
//初始化函数
- (instancetype)init
{
    self = [super init];
    if (self) {
        //获取对应的上下文
        UIApplication *application1 = [UIApplication sharedApplication];
        id delegate = [application1 delegate];
        self.managedObjectContext = [delegate managedObjectContext];
    }
    return self;
}

-(void)saveFriend:(NSString *)nickName  icon:(NSData *)headimage;
{
    //保存之前先做一个查询如果存在则更新，如果不存在则保存
    NSArray *result = [self search:nickName];
    
    FriendList *myFirend;
    
    if (result.count == 0 )    //没有就插入
    {
        //获取一个实体
        myFirend = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([FriendList class]) inManagedObjectContext:self.managedObjectContext];
        myFirend.nickname = nickName;
        myFirend.icon = headimage;
    }
    else       //有就更新一下数据
    {
        //更新
        myFirend = result[0];
        myFirend.nickname = nickName;
        myFirend.icon = headimage;
        
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
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([FriendList class])];
    
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
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([FriendList class])];
    
    //添加查询条件
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nickname" ascending:NO];
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
        FriendList *friend = result[0];
        [self.managedObjectContext deleteObject:friend];
        
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        if (error) {
            NSLog(@"保存上下文%@",[error localizedDescription]);
        }
        
    }
}

@end
