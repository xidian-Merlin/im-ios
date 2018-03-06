//
//  IMNotification.h
//  im
//
//  Created by tongho on 16/7/29.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMNotification : NSObject

+ (void)postNotification:(NSString*)notification
                userInfo:(NSDictionary*)userInfo
                  object:(id)object;

@end
