//
//  FriendListCell.m
//  ios约束版
//
//  Created by tongho on 16/7/23.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "FriendListCell.h"
#import "RKNotificationHub.h"
@interface FriendListCell()



@end


@implementation FriendListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
     //   CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        _hub = [[RKNotificationHub alloc]initWithView:self];
        [_hub moveCircleByX:4 Y:25]; // moves the circle five pixels left and 5 down
        [_hub scaleCircleSizeBy:0.8];
      //  [_hub increment];
        
        // 添加将来有可能用到的子控件
        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
        [self.contentView addSubview:headImage];
        
        self.headImage = headImage;
        
        
        UILabel *useNameLable = [[UILabel alloc]initWithFrame:CGRectMake(65, 15, 200, 25)];
        useNameLable.backgroundColor=[UIColor clearColor];
        useNameLable.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:useNameLable];
        
        self.userNameLabel = useNameLable;
        
        
        
        /*       // 2.添加按钮到背景图片
         UIButton *imageButton = [[UIButton alloc] init];
         [imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         
         [imageButton addTarget:self action:@selector(tapImageButton:) forControlEvents:UIControlEventTouchUpInside];
         [self.contentView addSubview:imageButton];
         //添加imageview
         //  UIImageView *bgImageView = [[UIImageView alloc] init];
         // [self.bgImageView addSubview:imageButton];
         self.imageButton = imageButton;
         
         //self.bgImageView = bgImageView;
         
         */
        
        
        // 4.清空cell的背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        // 5.设置按钮的内边距
        /*
         CGFloat top,
         CGFloat left,
         CGFloat bottom,
         CGFloat right
         */
        // self.imageButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}







-(void)setCellValue:(NSString *)username  icon:(NSData *)headimage
{
    
    
    self.userNameLabel.text = username;
    
    UIImage *image = [UIImage imageWithData: headimage];
    
    self.headImage.image = image;
    
    
    
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
