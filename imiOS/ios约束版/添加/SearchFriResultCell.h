//
//  SearchFriResultCell.h
//  ios约束版
//
//  Created by tongho on 16/8/6.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFriResultCell : UITableViewCell
@property(assign,nonatomic) int userId;
@property (strong, nonatomic)  UIImageView *headImage;
@property (strong, nonatomic)  UILabel *userNameLabel;
@property (strong, nonatomic)  UILabel *lastMessage;



@end
