//
//  IMSundriesCenter.m
//  im
//
//  Created by tongho on 16/7/17.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "IMSundriesCenter.h"

@implementation IMSundriesCenter

+ (instancetype)instance
{
    static IMSundriesCenter* g_IMSundriesCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_IMSundriesCenter = [[IMSundriesCenter alloc] init];
    });
    return g_IMSundriesCenter;
}

- (id)init
{
    self = [super init];
    if (self) {
        _serialQueue = dispatch_queue_create("com.im.SundriesSerial", NULL);
        _parallelQueue = dispatch_queue_create("com.im.SundriesParallel", NULL);
    }
    return self;
}

- (void)pushTaskToSerialQueue:(IMTask)task
{
    dispatch_async(self.serialQueue, ^{
        task();
    });
}

- (void)pushTaskToParallelQueue:(IMTask)task
{
    dispatch_async(self.parallelQueue, ^{
        task();
    });
}

- (void)pushTaskToSynchronizationSerialQUeue:(IMTask)task
{
    dispatch_sync(self.serialQueue, ^{
        task();
    });
}
@end
