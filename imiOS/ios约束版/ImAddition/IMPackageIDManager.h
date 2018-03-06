//
//  IMPackageIDManager.h
//  im
//
//  Created by tongho on 16/7/28.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMPackageIDManager : NSObject
+ (instancetype)instance;
- (uint32_t)packageID;
@end
