//
//  IMSundriesCenter.h
//  im
//
//  Created by yuhui wang on 16/7/17.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^IMTask)();

@interface IMSundriesCenter : NSObject

@property (nonnull,readonly)dispatch_queue_t serialQueue;
@property (nonnull,readonly)dispatch_queue_t parallelQueue;

+ (instancetype)instance;
- (void)pushTaskToSerialQueue:(IMTask)task;
- (void)pushTaskToParallelQueue:(IMTask)task;
- (void)pushTaskToSynchronizationSerialQUeue:(IMTask)task;
@end
