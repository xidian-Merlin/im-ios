//
//  IMUnrequestSuperAPI.h
//  im
//
//  Created by yuhui wang on 16/7/31.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReceiveData)(id object,NSError* error);

@interface IMUnrequestSuperAPI : NSObject

@property (nonatomic,copy)ReceiveData receivedData;

- (BOOL)registerAPIInAPIScheduleReceiveData:(ReceiveData)received;
@end
