//
//  IMUnrequestSuperAPI.m
//  im
//
//  Created by tongho on 16/7/31.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "IMUnrequestSuperAPI.h"
#import "IMAPIUnrequestScheduleProtocol.h"
#import "IMAPIScheduler.h"

@implementation IMUnrequestSuperAPI
- (BOOL)registerAPIInAPIScheduleReceiveData:(ReceiveData)received
{
    BOOL registerSuccess = [[IMAPIScheduler instance] registerUnrequestAPI:(id<IMAPIUnrequestScheduleProtocol>)self];
    if (registerSuccess)
    {
        self.receivedData = received;
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
