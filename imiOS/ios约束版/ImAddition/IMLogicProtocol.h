//
//  IMLogicProtocol.h
//  im
//
//  Created by yuhui wang on 16/7/19.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#ifndef IMLogicProtocol_h
#define IMLogicProtocol_h


#endif /* IMLogicProtocol_h */

#import <Foundation/Foundation.h>
#import "IMModuleManager.h"
#import "IMTask.h"
#import "IMTaskOperation.h"



#pragma -mark 模块相关
@protocol IMModuleProtocol <NSObject>

@required
//注册模块
-(BOOL) registerModule:(IMModule*) module;
//反注册模块
-(BOOL) unRegisterModule:(IMModule*) module;
//通过module id查找模块
-(IMModule*) queryModuleByID:(short) moduleId;

//监听数据相关
-(void)addObserver:(short)moduleId
              name:(NSString* const)name
          observer:(id)observer
          selector:(SEL)aSelector;
//异步通知到主线程
-(void)uiAsyncNotify:(short)moduleId
                name:(NSString* const)name
            userInfo:(NSMutableDictionary*)userInfo;
//同步通知到主线程 (注：尽量少用这个，因为主线程会把逻辑线程给阻塞住，切记)
-(void)uisyncNotify:(short)moduleId
               name:(NSString* const)name
           userInfo:(NSMutableDictionary*)userInfo;
//同步通知到当前线程
-(void)notify:(short)moduleId
         name:(NSString* const)name
     userInfo:(NSMutableDictionary*)userInfo;

@end

#pragma -mark 逻辑执行器
@protocol IMWorkerProtocol <NSObject>

@required
//将一个任务FIFO推入任务执行器
-(BOOL) pushTask:(id<IMTaskProtocol>)task
        delegate:(id<IMTaskDelegate>) delegate;

-(BOOL) pushTaskWithBlock:(TaskBlock)taskBlock;

@end


@protocol IMLogicProtocol <IMModuleProtocol,IMWorkerProtocol>

@required
-(BOOL) startup;
-(void) shutdown;

@end