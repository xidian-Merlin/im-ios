//
//  TimeConvert.h
//  ios约束版
//
//  Created by tongho on 16/8/1.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeConvert : NSObject

//判断时间是周几
+ (int)getOneDay:(NSString *) weekString ;
//会话界面时间转化
- (NSString *)distanceTimeWithBeforeTime:(double)beTime  ;

//聊天界面时间转化
- (NSString *)chatDistanceTimeWithBeforeTime:(double)beTime  ;

@end
