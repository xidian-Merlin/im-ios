//
//  IMNotification.m
//  im
//
//  Created by yuhui wang on 16/7/29.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMNotification.h"

@implementation IMNotification

+ (void)postNotification:(NSString*)notification userInfo:(NSDictionary*)userInfo object:(id)object
{   // 主线程通知
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notification object:object userInfo:userInfo];
    });
}

@end
