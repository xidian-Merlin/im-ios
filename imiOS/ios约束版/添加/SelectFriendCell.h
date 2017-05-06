//
//  SelectFriendCell.h
//  ios约束版
//
//  Created by tongho on 16/8/3.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "historyHf.h"
typedef void(^ZQTCartBlock)(BOOL select);


@interface SelectFriendCell : UITableViewCell

@property (nonatomic,retain) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong)UIButton *bigSelectBtn;

@property (nonatomic, strong)UILabel *lineLabel;

@property (nonatomic,assign)BOOL isSelected;


@property (nonatomic,copy)ZQTCartBlock cartBlock;

-(void)reloadDataWith:(historyHf *)model;




@end
