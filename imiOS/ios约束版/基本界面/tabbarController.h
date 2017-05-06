//
//  tabbarController.h
//  login
//
//  Created by tongho on 16/7/9.
//  Copyright © 2016年 im. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RKNotificationHub;

@interface tabbarController : UITabBarController


@property(strong, nonatomic) RKNotificationHub *hub1;
@property(strong, nonatomic) RKNotificationHub *hub2;
@property(strong, nonatomic) RKNotificationHub *hub3;
@property(strong, nonatomic) UIButton *btn1;
@property(strong, nonatomic) UIButton *btn2;
@property(strong, nonatomic) UIButton *btn3;
@property(strong, nonatomic) UIButton *btn4;


@property (nonatomic, weak) UIButton *selectbtn;

@end
