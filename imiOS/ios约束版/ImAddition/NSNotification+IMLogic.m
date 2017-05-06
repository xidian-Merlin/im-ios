//
//  NSNotification+IMLogic.m
//  im
//
//  Created by yuhui wang on 16/7/19.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "NSNotification+IMLogic.h"

@implementation NSNotification (IMLogic)

-(void)setSessionId:(NSString*)uId
{
    [self.userInfo setValue:uId forKey:USERINFO_SID];
}

-(NSString*)sessionId
{
    return [self.userInfo valueForKey:USERINFO_SID];
}
@end
