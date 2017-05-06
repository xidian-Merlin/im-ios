//
//  IMDBHelper.h
//  ios约束版
//
//  Created by tongho on 16/7/29.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface JKDBHelper : NSObject
{
    NSInteger *VERSION ;  //数据库版本号

}

@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;



+ (JKDBHelper *)shareInstance;

+ (NSString *)dbPath;

@end
