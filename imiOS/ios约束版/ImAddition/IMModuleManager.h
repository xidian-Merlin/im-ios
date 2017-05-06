//
//  IMModuleManager.h
//  im
//
//  Created by yuhui wang on 16/7/19.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSNotification+IMLogic.h"

static NSString* const USERINFO_DEFAULT_KEY = @"defaultKey";    //NSNotification通知userinfo字典默认key

@interface IMModule : NSObject
{
    NSMutableDictionary*       _observerCaches;
}

@property(nonatomic,readonly) short       moduleId;

-(id) initModule:(short) moduleId;

-(void) onLoadModule;
-(void) onUnloadModule;

-(void)addObserver:(NSString* const)name
          observer:(id)observer
          selector:(SEL)aSelector;
-(void)uiAsyncNotify:(NSString* const)name
            userInfo:(NSMutableDictionary*)userInfo;

-(void)uiSyncNotify:(NSString* const)name
           userInfo:(NSMutableDictionary*)userInfo;

-(void)notify:(NSString* const)name
     userInfo:(NSMutableDictionary*)userInfo;

@end

@interface IMTcpModule : IMModule

-(void)onHandleTcpData:(short)cmdId
                  data:(id)data;

@end

@class IMModuleDataManager;

@interface IMModuleManager : NSObject
{
    NSMutableArray*             _moduleArray;
    IMModuleDataManager*        _moduleDataManager;
}

-(id)init;
-(BOOL) startup;
-(void) shutdown;

-(BOOL) registerModule:(IMModule*) module;
-(BOOL) unRegisterModule:(IMModule*) module;
-(IMModule*) queryModuleByID:(short) moduleId;
-(BOOL)archive;


-(void)addObserver:(short)moduleId
              name:(NSString* const)name
          observer:(id)observer
          selector:(SEL)aSelector;

-(void)uiAsyncNotify:(short)moduleId
                name:(NSString* const)name
            userInfo:(NSMutableDictionary*)userInfo;

-(void)uisyncNotify:(short)moduleId
               name:(NSString* const)name
           userInfo:(NSMutableDictionary*)userInfo;

-(void)notify:(short)moduleId
         name:(NSString* const)name
     userInfo:(NSMutableDictionary*)userInfo;
@end
