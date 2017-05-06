//
//  IMSessionEntity.m
//  im
//
//  Created by yuhui wang on 16/7/18.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMSessionEntity.h"

@implementation IMSessionEntity

@synthesize  name;
@synthesize timeInterval;

- (void)setSessionID:(NSString *)sessionID
{
    _sessionID = [sessionID copy];
    name = nil;
    timeInterval = 0;
}

- (void)setSessionType:(SessionType)sessionType
{
    _sessionType = sessionType;
    name = nil;
    timeInterval = 0;
}

- (NSString *)name
{
    // 待续
    return name;
}

- (void)setSessionName:(NSString *)theName
{
    name = theName;
}

@end
