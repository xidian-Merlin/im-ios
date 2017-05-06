//
//  GroupInfoCell.m
//  BM
//
//  Created by hackxhj on 15/8/30.
//  Copyright (c) 2015年 hackxhj. All rights reserved.
//

#import "GroupInfoCell.h"

@implementation GroupInfoCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellviewbackground"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
