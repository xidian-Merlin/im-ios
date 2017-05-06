//
//  NSNotification+IMLogic.h
//  im
//
//  Created by yuhui wang on 16/7/19.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const USERINFO_SID = @"notification_sid";                   //NSNotification通知userinfo字典的sessionId
static

@interface NSNotification (IMLogic)

-(void)setSessionId:(NSString*)uId;

-(NSString*)sessionId;
@end
