//
//  IMUnrequestSuperAPI.h
//  im
//
//  Created by tongho on 16/7/31.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReceiveData)(id object,NSError* error);

@interface IMUnrequestSuperAPI : NSObject

@property (nonatomic,copy)ReceiveData receivedData;

- (BOOL)registerAPIInAPIScheduleReceiveData:(ReceiveData)received;
@end
