//
//  IMTaskOperation.m
//  im
//
//  Created by yuhui wang on 16/7/19.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//
#import "IMTask.h"
#import "IMTaskOperation.h"

@implementation IMTaskOperation

-(void) main
{
    if([self isCancelled])
        return;
    if([_delegate respondsToSelector:@selector(didIMTaskStarted:)])
    {
        if(![_delegate didIMTaskStarted:_IMTask])
            return;
    }
    if(_IMTask)
        [_IMTask execute];
    else
        _block();
    if([self isCancelled])
        return;
    if([_delegate respondsToSelector:@selector(didIMTaskFinished:)])
    {
        [_delegate didIMTaskFinished:_IMTask];
    }
}

-(id) initWithBlock:(TaskBlock)taskBlock
{
    if(self = [super init])
    {
        _block = taskBlock;
    }
    return self;
}

-(id) initWithIMTask:(id<IMTaskProtocol>) task delegate : (id<IMTaskDelegate>)delegate
{
    if(self = [super init])
    {
        _IMTask = task;
        if([_IMTask isKindOfClass:[IMTask class]])
        {
            IMTask* task = (IMTask*) _IMTask;
            task.delegate = delegate;
        }
        _delegate = delegate ;
    }
    
    return self;
}

@end

@implementation IMTask

-(void) execute
{
    // 不采用这种方式执行，使用block
}

- (void)uiNotify
{
    if([_delegate respondsToSelector:@selector(didIMTaskAsyncUICallback:)])
    {
        [_delegate performSelectorOnMainThread:@selector(didIMTaskAsyncUICallback:) withObject:self waitUntilDone:NO];
    }
}
@end
