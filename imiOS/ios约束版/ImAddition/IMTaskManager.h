//
//  IMTaskManager.h
//  im
//
//  Created by yuhui wang on 16/7/19.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMTaskOperation.h"

@interface IMTaskManager : NSObject
{
@private
    NSOperationQueue* _queue;
    NSOperation* _lastOperation;
}

-(BOOL) pushTask:(id<IMTaskProtocol>)task delegate:(id<IMTaskDelegate>) delegate;
//todo task with block、target action
-(BOOL) pushTaskWithBlock:(TaskBlock)taskBlock;
-(BOOL) pushTaskWithTarget:(id)target selector:(SEL)sel;
-(void) shutdown;
@end
