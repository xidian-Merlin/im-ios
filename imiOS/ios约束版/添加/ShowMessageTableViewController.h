//
//  ShowMessageTableViewController.h
//  ios约束版
//
//  Created by tongho on 16/8/5.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShowMessageTableViewController : UITableViewController

@property(assign, nonatomic) int userId;
@property(copy, nonatomic) NSString * userName;
@property(copy, nonatomic) NSString * nickName;   //1备注
@property(copy, nonatomic) NSString * nickkName2;//昵称
@property(strong, nonatomic) UIImage *icon;
@end
