//
//  IMSuperAPI.m
//  im
//
//  Created by tongho on 16/7/28.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "IMSuperAPI.h"
#import "IMAPIScheduler.h"
#import "IMClientState.h"

static int thePackageID = 0;

@implementation IMSuperAPI
- (void)requestWithObject:(id)object Completion:(RequestCompletion)completion
{
    if ([IMClientState shareInstance].networkState == IMNetWorkDisconnect)
    {
        //断网的话直接返回失败
        NSError* error = [NSError errorWithDomain:@"网络断开" code:1004 userInfo:nil];
        if (completion)
        {
            completion(nil,error);
        }
        return;
    }
    
    //packageID
    thePackageID ++;
    _packageID = thePackageID;
    
    //注册接口
    BOOL registerAPI = [[IMAPIScheduler instance] registerApi:(id<IMAPIScheduleProtocol>)self];
    
    if (!registerAPI)
    {
        return;
    }
    
    //注册请求超时
    if ([(id<IMAPIScheduleProtocol>)self requestTimeOutTimeInterval] > 0)
    {
        [[IMAPIScheduler instance] registerTimeoutApi:(id<IMAPIScheduleProtocol>)self];
    }
    
    //保存完成块，引用block
    self.completion = completion;
    
    
    //数据打包
    Package package = [(id<IMAPIScheduleProtocol>)self packageRequestObject];
    NSMutableData* requestData = package(object,_packageID);
    
    //发送
    if (requestData)
    {
        [[IMAPIScheduler instance] sendData:requestData];
    }
}
@end
