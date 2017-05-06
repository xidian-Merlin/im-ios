//
//  FriendListCell.h
//  ios约束版
//
//  Created by tongho on 16/7/23.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  RKNotificationHub;

@interface FriendListCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *headImage;
@property (copy, nonatomic) NSString *userName;
@property (strong, nonatomic)  UILabel *userNameLabel;    //此处显示的应该是备注名
@property (copy ,nonatomic) NSString *nickName;   //昵称
@property (assign, nonatomic)  int userId;
@property(strong,nonatomic) RKNotificationHub *hub;

-(void)setCellValue:(NSString *)username  icon:(NSData *)headimage;

@end
