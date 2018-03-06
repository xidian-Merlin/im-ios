//
//  IMSessionKeyManager.h
//  TEST
//
//  Created by tongho on 2017/1/12.
//  Copyright © 2017年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMSessionKeyManager : NSObject

+ (instancetype)instance;

- (NSData*)sessionKey;

@end
