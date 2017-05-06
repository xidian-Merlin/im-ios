//
//  MyImageCell.m
//  MecoreMessageDemo
//
//  Created by tongho on 16/7/12.
//  Copyright © 2016年 im. All rights reserved.
//

#import "MyImageCell.h"
#import "UIImage+Extension.h"
//#import <UIKit+AFNetworking.h>

@interface MyImageCell()
//@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
//@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) ButtonImageBlock imageBlock;

@property (strong, nonatomic) UIImage *buttonImage;
//@property (strong, nonatomic) NSURL *imageUrl;


@property (nonatomic, weak) UIButton *imageButton;// button

@property (nonatomic, weak) UIImageView *bgImageView;//图片


/*  头像
 */
@property (nonatomic, weak) UIImageView *iconView;


@end

@implementation MyImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 添加将来有可能用到的子控件
        // 1.添加时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        // 2.添加按钮到背景图片
        UIButton *imageButton = [[UIButton alloc] init];
        [imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [imageButton addTarget:self action:@selector(tapImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:imageButton];
        //添加imageview
      //  UIImageView *bgImageView = [[UIImageView alloc] init];
       // [self.bgImageView addSubview:imageButton];
        self.imageButton = imageButton;
        
        //self.bgImageView = bgImageView;
        
        
        
        // 3.添加头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        // 4.清空cell的背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        // 5.设置按钮的内边距
        /*
         CGFloat top,
         CGFloat left,
         CGFloat bottom,
         CGFloat right
         */
        self.imageButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}



-(void)setCellValue:(UIImage *) sendImage time:(NSString*)ptime userType:(UserType)type
{
    //self.imageUrl = [NSURL URLWithString:imageURL];
    
    
    CGRect timeF = CGRectMake(0, 0, 0, 0);;
    /**
     *  头像frame
     */
    CGRect iconF = CGRectMake(0, 0, 0, 0);;
    /**
     *  图片frame
     */
    CGRect viewF = CGRectMake(0, 0, 0, 0);;
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //间隙
    CGFloat padding = 10;
    
    if (YES == _showTime) { // 是否需要计算时间的frame
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeH = 30;
        CGFloat timeW = screenWidth;
        timeF = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    // 2.头像frame
    CGFloat iconH = 30;
    CGFloat iconW = 30;
    CGFloat iconY = CGRectGetMaxY(timeF) + padding;
    
    CGFloat iconX = 0;
    if (MySelf == type) {// 自己发的
        // x = 屏幕宽度 - 间隙 - 头像宽度
        iconX = screenWidth - padding - iconW;
    }else
    {
        // 别人发的
        iconX = padding;
    }
    
    iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    //第一种方案计算宽高
    
  
    
    //由text计算出text的宽高
    
    CGFloat viewW = 100;
    CGFloat viewH = 100;
     //CGSize maxSize = CGSizeMake(200, MAXFLOAT);
    // CGSize textSize = [_message.text sizeWithFont:NJTextFont maxSize:maxSize];
    CGFloat viewY = iconY-5;
    CGFloat viewX = 0;
    if (MySelf == type) {
        // 自己发的
        // x = 头像x - 间隙 - 文本的宽度
        viewX = iconX - padding - viewW;
    }else
    {
        // 别人发的
        // x = 头像最大的X + 间隙
        viewX = CGRectGetMaxX(iconF) + padding;
    }
    viewF = CGRectMake(viewX, viewY, viewW, viewH);
    
    
    
    
    
    //接着为textcell的子控件添加实际文字内容与位置
    
    self.timeLabel.text = ptime;
    self.timeLabel.frame = timeF;
    
    
    // 2.设置头像
    if (MySelf == type) {
        
        // 自己发的
        self.iconView.image = _myIcon;
    }else
    {
        self.iconView.image = _heIcon;
    }
    self.iconView.frame = iconF;
    
    // 3.设置bgview
   
    self.imageButton.frame = viewF;
    
    // 4.设置背景图片
    UIImage *newImage =  nil;
    if (MySelf == type) {
        newImage = [UIImage resizableImageWithName:@"chat_send_nor"];
        
    }else
    {
        // 别人发的
        newImage = [UIImage resizableImageWithName:@"chat_recive_nor"];
    }
  //
  //   newImage = [newImage resizableImageWithCapInsets:(UIEdgeInsetsMake(newImage.size.height * 0.6, newImage.size.width * 0.4, newImage.size.height * 0.3, newImage.size.width * 0.4))];
    
   // [self.imageButton setImage:newImage];


    
    
    
    self.buttonImage = sendImage;//block 回调参数
/*    UIImage *image = [UIImage imageNamed:@"chatto_bg_normal.png"];
    image = [image resizableImageWithCapInsets:(UIEdgeInsetsMake(image.size.height * 0.6, image.size.width * 0.4, image.size.height * 0.3, image.size.width * 0.4))];*/
    
    
   // [self.bgImageView setImage:sendImage];
    
    
  //  NSLog(@"%@", imageURL);
    
    [self.imageButton setImage:sendImage forState:UIControlStateNormal];
    
   // [self.imageButton setImageForState:UIControlStateNormal withURL:_imageUrl placeholderImage:[UIImage imageNamed:@"chat_bottom_smile_press.png"]];
}

-(void)setButtonImageBlock:(ButtonImageBlock)block
{
    self.imageBlock = block;
}

- (void)tapImageButton:(UIButton*)sender
{
    self.imageBlock(self.buttonImage);
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
