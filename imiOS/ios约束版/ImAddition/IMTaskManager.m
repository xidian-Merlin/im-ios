//
//  IMTaskManager.m
//  im
//
//  Created by yuhui wang on 16/7/19.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMTaskManager.h"

@implementation IMTaskManager
-(id) init
{
    if(self = [super init])
    {
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1];
    }
    
    return self;
}

-(BOOL) pushTaskWithBlock:(TaskBlock)taskBlock
{
    @synchronized(self)
    {
        IMTaskOperation* operation = [[IMTaskOperation alloc] initWithBlock:taskBlock];
        if(!operation)
            return NO;
        [_queue addOperation:operation];
        //保证FIFO
        [_lastOperation addDependency:operation];
        _lastOperation = operation;
    }
    
    return YES;
}

-(BOOL) pushTask:(id<IMTaskProtocol>)task delegate:(id<IMTaskDelegate>) delegate;
{
    @synchronized(self)
    {
        IMTaskOperation* operation = [[IMTaskOperation alloc] initWithIMTask:task delegate:delegate];
        if(!operation)
            return NO;
        [_queue addOperation:operation];
        //保证FIFO
        [_lastOperation addDependency:operation];
        _lastOperation = operation;
    }
    
    return YES;
}

-(BOOL) pushTaskWithTarget:(id)target selector:(SEL)sel
{
    @synchronized(self)
    {
        // todo 
    }
    
    return YES;
}

-(void) shutdown
{
    [_queue cancelAllOperations];
}
@end
