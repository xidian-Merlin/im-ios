//
//  UserInfoCell.m
//  MecoreMessageDemo

//  Created by tongho on 16/7/23.
//  Copyright © 2016年 tongho. All rights reserved.
//


#import "UserInfoCell.h"
#import "StitchingImage.h"
#import "GroupMemeberDb.h"
#import "GroupMemeberModel.h"


@interface UserInfoCell()


@end


@implementation UserInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        
        // 添加将来有可能用到的子控件
        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
        [self.contentView addSubview:headImage];
        
        //当为调聊时才添加小红点到底层图片上，防止被群聊视图覆盖
        _hub = [[RKNotificationHub alloc]initWithView:headImage];
        [_hub moveCircleByX:-3 Y:3]; // moves the circle five pixels left and 5 down
        [_hub scaleCircleSizeBy:0.6];
        
        self.headImage = headImage;

        UILabel *lastMessage = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, screenWidth-200, 15)];
        lastMessage.font = [UIFont systemFontOfSize:13];
        lastMessage.textColor = [UIColor grayColor];
        [self.contentView addSubview:lastMessage];
        self.lastMessage = lastMessage;
        
        
        UILabel *useNameLable = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 200, 25)];
        useNameLable.backgroundColor=[UIColor clearColor];
        useNameLable.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:useNameLable];
        
        self.userNameLabel = useNameLable;
        
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth-60, 5, 50, 10)];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:timeLabel];
        self.timeLable = timeLabel;
        
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







-(void)setCellValue:(NSString *)username lastMessage:(NSString *)lastMessage icon:(NSData *)headimage time:(NSString *)time chatStyle:(int)chatStyle
{
   
    
      
    
        UIImage *image = [UIImage imageWithData: headimage];
        
        self.headImage.image = image;



    
    self.userNameLabel.text = username;
    self.lastMessage.text = lastMessage;
    
    self.timeLable.text = time;
    
    
    
    
    
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
