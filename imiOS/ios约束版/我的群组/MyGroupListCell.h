//
//  MyGroupListCell.h
//  ios约束版
//
//  Created by tongho on 16/8/18.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGroupListCell : UITableViewCell

@property (nonatomic, assign) int groupId;
@property (strong, nonatomic)  UIImage *icon;
@property (strong, nonatomic)  UIImageView *coverImage;
@property (strong, nonatomic)  UILabel *groupNameLabel;

- (UIImage *)createIconWihgroupId:(int)groupId;

@end
