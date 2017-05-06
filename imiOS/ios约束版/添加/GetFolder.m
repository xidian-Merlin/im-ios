//
//  GetFolder.m
//  ios约束版
//
//  Created by tongho on 16/8/12.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "GetFolder.h"
#import "Person.h"

@implementation GetFolder



-(NSString *)getFolder {

    // 1.获得Documents的全路径
    NSString *nowDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *nowPath = [nowDoc stringByAppendingPathComponent:@"nowUser.data"]; //扩展名可以自己定义
    
    // 3.从文件中读取MJStudent对象，将nsdata转成对象
    Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];        //读取当前用户的用户名
    //获取cache
    NSString *nowCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *testPath = [nowCache stringByAppendingPathComponent:nowUser.userName];


    return testPath;


}

@end
