//
//  NewFriendTableViewCell.h
//  ios约束版
//
//  Created by tongho on 16/8/3.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(BOOL select);
@interface NewFriendTableViewCell : UITableViewCell
@property (copy,nonatomic) SelectBlock  selectBlock;
@property (strong, nonatomic)  UIImageView *headImage;

@property (strong, nonatomic)  UILabel *userNameLabel;
@property (strong, nonatomic)  UILabel *lastMessage;
@property (strong, nonatomic)  UILabel *timeLable;
@property (strong, nonatomic)  UIButton *selectBtn;
@property (strong, nonatomic)  UIButton *bSelectBtn;   //点击后背景
@property (assign, nonatomic)  int  agreeFlag;       //从数据库中读取，如果已经同意，则显示按钮为灰
@property (assign, nonatomic)  int userId;
@property (copy, nonatomic)  NSString *userName;
@property (copy, nonatomic) NSString *remarkName;  //备注名默认显示为昵称；
@property (strong,nonatomic) NSData *icon;

-(void)setCellValue:(NSString *)username lastMessage:(NSString *)lastMessage icon:(NSData *)headimage ;

@end
