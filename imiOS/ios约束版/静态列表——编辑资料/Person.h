//
//  Person.h
//  静态列表——编辑资料
//
//  Created by Rannie on 13-9-4.
//  Copyright (c) 2013年 Rannie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Person : NSObject <NSCoding>

@property (assign, nonatomic) NSNumber * userId;
@property (strong, nonatomic) NSString *name;   //昵称
@property (copy, nonatomic) NSString *userName;
@property (strong, nonatomic) UIImage *headerImage;
@property (strong, nonatomic) NSString *tel;
@property (strong, nonatomic) NSString *mail;

@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *signature;

@end
