//
//  IMModuleManager.m
//  im
//
//  Created by yuhui wang on 16/7/19.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMModuleManager.h"
#import "IMModuleDataManager.h"

@implementation IMTcpModule

-(void)onHandleTcpData:(short)cmdId data:(id)data
{
    // TODO...网络部分 数据处理
}

@end

@interface IMModule()

-(void)cacheObserver:(NSString*)name observer:(id)observer;

@end

@implementation IMModule

-(id) initModule:(short) moduleId
{
    if(self = [super init])
    {
        _moduleId = moduleId;
        _observerCaches = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) onLoadModule
{
    // TODO...
}

-(void) onUnloadModule
{
    for(NSString* name in _observerCaches)
    {
        NSArray* sameNameObservers = [_observerCaches objectForKey:name];
        for (id observer in sameNameObservers)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:nil];
        }
    }
}

-(void)cacheObserver:(NSString*)name observer:(id)observer
{
    NSMutableArray* sameNameObservers = [_observerCaches objectForKey:name];
    if(!sameNameObservers)
    {
        sameNameObservers = [[NSMutableArray alloc] init];
    }
    if(![sameNameObservers containsObject:observer])
    {
        [sameNameObservers addObject:observer];
    }
    [_observerCaches setValue:sameNameObservers forKey:name];
}

-(void)addObserver:(NSString* const)name observer:(id)observer selector:(SEL)aSelector
{
    //trick 为了在多次add同一个observer的时候，不多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:name object:nil];
    [self cacheObserver:name observer:observer];
}

-(void)uiAsyncNotify:(NSString* const)name userInfo:(NSMutableDictionary*)userInfo
{
    NSNotification* notification = [NSNotification notificationWithName:name object:self userInfo:userInfo];
    NSString* uid = [userInfo objectForKey:USERINFO_SID];
    if(uid)
    {
        [notification setSessionId:uid];
    }
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:)withObject:notification waitUntilDone:NO];
}

-(void)uiSyncNotify:(NSString* const)name userInfo:(NSMutableDictionary*)userInfo
{
    NSNotification* notification = [NSNotification notificationWithName:name object:self userInfo:userInfo];
    NSString* uid = [userInfo objectForKey:USERINFO_SID];
    if(uid)
    {
        [notification setSessionId:uid];
    }
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:)withObject:notification waitUntilDone:YES];
}

-(void)notify:(NSString* const)name userInfo:(NSMutableDictionary*)userInfo
{
    //    [userInfo setObject:@"aaa" forKey:USERINFO_SID];
    NSNotification* notification = [NSNotification notificationWithName:name object:self userInfo:userInfo];
    NSString* uid = [userInfo objectForKey:USERINFO_SID];
    if(uid)
    {
        [notification setSessionId:uid];
    }
    [[NSNotificationCenter defaultCenter] performSelector:@selector(postNotification:) withObject:notification withObject:notification];
}

@end

@interface IMModuleManager()
-(void)unRegisterAllModules;
@end

@implementation IMModuleManager

-(id)init
{
    if(self = [super init])
    {
        _moduleArray = [NSMutableArray array];
        _moduleDataManager = [[IMModuleDataManager alloc] initModuleData:_moduleArray];
    }
    return self;
}

-(BOOL) registerModule:(IMModule*) module
{
    //todo... 去重
    [_moduleArray addObject:module];
    
    [module onLoadModule];
    
    return YES;
}
-(BOOL) unRegisterModule:(IMModule*) module
{
    [module onUnloadModule];
    
    [_moduleArray removeObject:module];
    
    return YES;
}

-(void)addObserver:(short)moduleId name:(NSString* const)name observer:(id)observer selector:(SEL)aSelector
{
    IMModule* module = [self queryModuleByID:moduleId];
    [module addObserver:name observer:observer selector:aSelector];
}

-(void)uiAsyncNotify:(short)moduleId name:(NSString* const)name userInfo:(NSMutableDictionary*)userInfo
{
    IMModule* module = [self queryModuleByID:moduleId];
    [module uiAsyncNotify:name userInfo:userInfo];
}

-(void)uisyncNotify:(short)moduleId name:(NSString* const)name userInfo:(NSMutableDictionary*)userInfo
{
    IMModule* module = [self queryModuleByID:moduleId];
    [module uiAsyncNotify:name userInfo:userInfo];
}

-(void)notify:(short)moduleId name:(NSString* const)name userInfo:(NSMutableDictionary*)userInfo
{
    IMModule* module = [self queryModuleByID:moduleId];
    [module notify:name userInfo:userInfo];
}

-(IMModule*) queryModuleByID:(short) moduleId
{
    for(IMModule* module in _moduleArray)
    {
        if(module.moduleId == moduleId)
            return module;
    }
    
    return nil;
}

-(BOOL)archive
{
    return [_moduleDataManager archive];
}

-(BOOL) startup
{
    return [_moduleDataManager unArchive];
}

-(void) shutdown
{
    [_moduleDataManager archive];
    
    [self unRegisterAllModules];
}

-(void)unRegisterAllModules
{
    for(IMModule* module in _moduleArray)
    {
        [module onUnloadModule];
    }
}
@end
