//
//  ConvertServerFeedback.h
//  ios约束版
//
//  Created by tongho on 2017/3/9.
//  Copyright © 2017年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerFeedbackConverter : NSObject

+ (NSString*)convertServerFeedbackWithResultCode:(short)resultCode;
+ (short)converResultCodetWithServerFeedback:(NSString*)feedback;
@end
