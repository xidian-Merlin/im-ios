//
//  SearchFriResultCell.m
//  ios约束版
//
//  Created by tongho on 16/8/6.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "SearchFriResultCell.h"







@implementation SearchFriResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        
        // 添加将来有可能用到的子控件
        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
        [self.contentView addSubview:headImage];
        
        self.headImage = headImage;
        
        UILabel *lastMessage = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, screenWidth-200, 13)];
        lastMessage.font = [UIFont systemFontOfSize:13];
        lastMessage.textColor = [UIColor grayColor];
        [self.contentView addSubview:lastMessage];
        self.lastMessage = lastMessage;
        
        
        UILabel *useNameLable = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 200, 25)];
        useNameLable.backgroundColor=[UIColor clearColor];
        useNameLable.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:useNameLable];
        
        self.userNameLabel = useNameLable;
        
        
       
        
        // 4.清空cell的背景颜色
        self.backgroundColor = [UIColor clearColor];
        
      
    }
    return self;
}







- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

