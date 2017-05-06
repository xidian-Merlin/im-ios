//
//  LoginInfo.h
//  ios约束版
//
//  Created by tongho on 16/7/29.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginInfo : NSObject

@property(nonatomic, copy) NSString *loginName;
@property(nonatomic, copy) NSString *loginPassword;
@property(nonatomic, strong) NSData *loginIcon;

@end
