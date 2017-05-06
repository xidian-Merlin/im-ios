//
//  IMNotification.h
//  im
//
//  Created by yuhui wang on 16/7/29.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMNotification : NSObject

+ (void)postNotification:(NSString*)notification
                userInfo:(NSDictionary*)userInfo
                  object:(id)object;

@end
