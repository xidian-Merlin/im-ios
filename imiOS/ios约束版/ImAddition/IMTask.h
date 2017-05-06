//
//  IMTask.h
//  im
//
//  Created by yuhui wang on 16/7/19.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMTaskProtocol <NSObject>

@required

-(void) execute;

@end

@class IMTask;

@protocol IMTaskDelegate <NSObject>

@optional
- (BOOL) didIMTaskStarted : (IMTask*) task;
- (void) didIMTaskAsyncUICallback:(IMTask*) task;
- (void) didIMTaskCallback : (IMTask*)task;
- (void) didIMTaskFinished :(IMTask*) task;

@end

@interface IMTask : NSObject<IMTaskProtocol>

@property(nonatomic,strong) NSObject<IMTaskDelegate>* delegate;

- (void) execute;
- (void) uiNotify;

@end
