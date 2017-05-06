//
//  IMTaskOperation.h
//  im
//
//  Created by yuhui wang on 16/7/19.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol IMTaskProtocol;
@protocol IMTaskDelegate;

typedef void(^TaskBlock)();

@interface IMTaskOperation : NSOperation
{
@private
    id<IMTaskProtocol>      _IMTask;
    id<IMTaskDelegate>      _delegate;
    TaskBlock               _block;
}

-(id) initWithIMTask:(id<IMTaskProtocol>) task
            delegate:(id<IMTaskDelegate>)delegate;

-(id) initWithBlock:(TaskBlock)taskBlock;

@end
