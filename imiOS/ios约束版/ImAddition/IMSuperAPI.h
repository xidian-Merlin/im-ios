//
//  IMSuperAPI.h
//  im
//
//  Created by tongho on 16/7/28.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMAPIScheduleProtocol.h"

typedef void(^RequestCompletion)(id response,NSError* error);


static uint32_t strLen(NSString *aString)
{
    return (uint32_t)[[aString dataUsingEncoding:NSUTF8StringEncoding] length];
}

/**
 *  这是一个超级类，不能被直接使用
 */
@interface IMSuperAPI : NSObject

@property (nonatomic,copy)RequestCompletion completion;

@property (nonatomic,readonly)int packageID;

- (void)requestWithObject:(id)object Completion:(RequestCompletion)completion;
@end
