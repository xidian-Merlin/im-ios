//
//  IMPackageIDManager.m
//  im
//
//  Created by yuhui wang on 16/7/28.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMPackageIDManager.h"

@implementation IMPackageIDManager
{
    uint32_t _packageID;
}
+ (instancetype)instance
{
    static IMPackageIDManager* g_packageIDManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_packageIDManager = [[IMPackageIDManager alloc] init];
    });
    return g_packageIDManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _packageID = 0;
    }
    return self;
}

- (uint32_t)packageID
{
    _packageID ++;
    return _packageID;
}
@end
