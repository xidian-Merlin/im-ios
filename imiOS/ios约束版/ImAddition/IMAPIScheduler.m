//
//  IMAPIScheduler.m
//  im
//
//  Created by yuhui wang on 16/7/28.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMAPIScheduler.h"
#import "IMAPIScheduleProtocol.h"
#import "IMAPIUnrequestScheduleProtocol.h"
#import "IMSuperAPI.h"
#import "IMUnrequestSuperAPI.h"
#import "IMTcpClientManager.h"
#import "IMSundriesCenter.h"

#define MAP_REQUEST_KEY(api)                                [NSString stringWithFormat:@"%i-%i-%i",[api requestCommandID],[api requestSubcommandID],[(IMSuperAPI*)api packageID]]

#define MAP_RESPONSE_KEY(api)                               [NSString stringWithFormat:@"response_%i-%i-%i",[api responseCommandID],[api responseSubcommandID],[(IMSuperAPI*)api packageID]]

#define MAP_DATA_RESPONSE_KEY(serverData)                   [NSString stringWithFormat:@"response_%i-%i-%i",serverData.commandID,serverData.subcommandID,serverData.packageID]

#define MAP_UNREQUEST_KEY(api)                              [NSString stringWithFormat:@"%i-%i",[api responseCommandID],[api responseSubcommandID]]

#define MAP_DATA_UNREQUEST_KEY(serverData)                  [NSString stringWithFormat:@"%i-%i",serverData.commandID,serverData.subcommandID]

typedef NS_ENUM(NSInteger, APIErrorCode){
    Timeout = 1001,
    Result = 1002
};

static NSInteger const timeInterval = 1;

@interface IMAPIScheduler(PrivateAPI)

- (void)p_requestCompletion:(id<IMAPIScheduleProtocol>)api;
- (void)p_timeoutOnTimer:(id)timer;

@end

@implementation IMAPIScheduler
{
    NSMutableDictionary* _apiRequestMap;
    NSMutableDictionary* _apiResponseMap;
    
    NSMutableDictionary* _unrequestMap;
    NSMutableDictionary* _timeoutMap;
    
    NSTimer* _timeOutTimer;
}
+ (instancetype)instance
{
    static IMAPIScheduler* g_apiSchedule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_apiSchedule = [[IMAPIScheduler alloc] init];
    });
    return g_apiSchedule;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _apiRequestMap = [[NSMutableDictionary alloc] init];
        _apiResponseMap = [[NSMutableDictionary alloc] init];
        _unrequestMap = [[NSMutableDictionary alloc] init];
        _timeoutMap = [[NSMutableDictionary alloc] init];
        _apiSchedulerQueue = dispatch_queue_create("com.im.apiSchedule", NULL);
        NSLog(@"创建API线程！");
        //        _timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(p_timeoutOnTimer:) userInfo:nil repeats:YES];
    }
    return self;
}

#pragma mark public
- (BOOL)registerApi:(id<IMAPIScheduleProtocol>)api
{
    __block BOOL registSuccess = NO;
    dispatch_sync(self.apiSchedulerQueue, ^{
        if (![api analysisReturnData])
        {
            registSuccess = YES;
        }
        if (![[_apiRequestMap allKeys] containsObject:MAP_REQUEST_KEY(api)])
        {
            [_apiRequestMap setObject:api forKey:MAP_REQUEST_KEY(api)];
            registSuccess = YES;
        }
        else
        {
            registSuccess = NO;
        }
        
        //注册返回数据处理
        if (![[_apiResponseMap allKeys] containsObject:MAP_RESPONSE_KEY(api)])
        {
            [_apiResponseMap setObject:api forKey:MAP_RESPONSE_KEY(api)];
        }
    });
    return registSuccess;
}

- (void)registerTimeoutApi:(id<IMAPIScheduleProtocol>)api
{
    double delayInSeconds = [api requestTimeOutTimeInterval];
    if (delayInSeconds == 0)
    {
        return;
    }
    
    //    [_timeoutMap setObject:api forKey:[NSDate date]];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([[_apiRequestMap allKeys] containsObject:MAP_REQUEST_KEY(api)])
        {
            [[IMSundriesCenter instance] pushTaskToSerialQueue:^{
                RequestCompletion completion = [(IMSuperAPI*)api completion];
                NSError* error = [NSError errorWithDomain:@"请求超时" code:Timeout userInfo:nil];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil,error);
                    }
                });
                [self p_requestCompletion:api];
            }];
        }
    });
}


- (void)receiveServerData:(NSData*)data forDataType:(ServerDataType)dataType
{
    dispatch_async(self.apiSchedulerQueue, ^{
        NSString* key = MAP_DATA_RESPONSE_KEY(dataType);
        //根据key去调用注册api的completion
        id<IMAPIScheduleProtocol> api = _apiResponseMap[key];
        if (api)
        {
            RequestCompletion completion = [(IMSuperAPI*)api completion];
            Analysis analysis = [api analysisReturnData];
            id response = analysis(data);
            [self p_requestCompletion:api];
            dispatch_async(dispatch_get_main_queue(), ^{
                @try {
                    completion(response,nil);
                }
                @catch (NSException *exception) {
                    NSLog(@"completion,response is nil");
                }
            });
        }
        else
        {
            NSString* unrequestKey = MAP_DATA_UNREQUEST_KEY(dataType);
            id<IMAPIUnrequestScheduleProtocol> unrequestAPI = _unrequestMap[unrequestKey];
            if (unrequestAPI)
            {
                UnrequestAPIAnalysis unrequestAnalysis = [unrequestAPI unrequestAnalysis];
                id object = unrequestAnalysis(data);
                ReceiveData received = [(IMUnrequestSuperAPI*)unrequestAPI receivedData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    received(object,nil);
                    
                });
            }
        }
    });
    
}

- (BOOL)registerUnrequestAPI:(id<IMAPIUnrequestScheduleProtocol>)api
{
    __block BOOL registerSuccess = NO;
    dispatch_sync(self.apiSchedulerQueue, ^{
        NSString* key = MAP_UNREQUEST_KEY(api);
        if ([[_unrequestMap allKeys] containsObject:key])
        {
            registerSuccess = NO;
        }
        else
        {
            [_unrequestMap setObject:api forKey:key];
            registerSuccess = YES;
        }
    });
    return registerSuccess;
}

- (void)sendData:(NSMutableData*)data
{
    dispatch_async(self.apiSchedulerQueue, ^{
        [[IMTcpClientManager instance] writeToSocket:data];
    });
}

#pragma mark - privateAPI
// 请求完成后将接口从字典中移除
- (void)p_requestCompletion:(id<IMAPIScheduleProtocol>)api
{
    [_apiRequestMap removeObjectForKey:MAP_REQUEST_KEY(api)];
    
    [_apiResponseMap removeObjectForKey:MAP_RESPONSE_KEY(api)];
}

- (void)p_timeoutOnTimer:(id)timer
{
    NSDate* date = [NSDate date];
    NSInteger count = [_timeoutMap count];
    if (count == 0)
    {
        return;
    }
    NSArray* allKeys = [_timeoutMap allKeys];
    for (int index = 0; index < count; index ++)
    {
        NSDate* key = allKeys[index];
        id<IMAPIScheduleProtocol> api = (id<IMAPIScheduleProtocol>)[_timeoutMap objectForKey:key];
        NSDate* beginDate = (NSDate*)key;
        NSInteger gap = [date timeIntervalSinceDate:beginDate];
        
        NSInteger apitimeval = [api requestTimeOutTimeInterval];
        if (gap > apitimeval)
        {
            if ([[_apiRequestMap allKeys] containsObject:MAP_REQUEST_KEY(api)])
            {
                RequestCompletion completion = [(IMSuperAPI*)api completion];
                NSError* error = [NSError errorWithDomain:@"请求超时" code:Timeout userInfo:nil];
                completion(nil,error);
                //                [self p_requestCompletion:obj];
            }
            
        }
    }
    [_timeoutMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
    }];
}

@end
