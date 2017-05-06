//
//  UserInfoCell.h
//  MecoreMessageDemo
//
//  Created by tongho on 16/7/23.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKNotificationHub.h"

@interface UserInfoCell : UITableViewCell


@property(strong,nonatomic) RKNotificationHub *hub;
@property(assign, nonatomic) int userId;
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel *userNameLabel;
@property (strong, nonatomic)  UILabel *lastMessage;
@property (strong, nonatomic)  UILabel *timeLable;
@property(assign, nonatomic) int style;  //1表示单聊，2表示群聊


-(void)setCellValue:(NSString *)username lastMessage:(NSString *)lastMessage icon:(NSData *)headimage time:(NSString *)time chatStyle:(int)chatStyle;



@end
