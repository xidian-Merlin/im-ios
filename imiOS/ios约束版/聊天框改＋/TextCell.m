//
//  TextCell.m
//  CocoaPods
//
//  Created by tongho on 16/7/12.
//  Copyright © 2016年 im. All rights reserved.
//

#import "TextCell.h"
#import "UIImage+Extension.h"

@interface TextCell()

#define NJTextFont [UIFont systemFontOfSize:15]
#define NJEdgeInsetsWidth 20
//@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
//@property (strong, nonatomic) IBOutlet UIImageView *chatBgImageView;
//@property (strong, nonatomic) IBOutlet UITextView *chatTextView;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatBgImageWidthConstraint;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chatTextWidthConstaint;
@property (strong, nonatomic) NSMutableAttributedString *attrString;
//* 时间


/**
 *  正文
 */
@property (nonatomic, weak) UIButton *contentBtn;
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;


@end

@implementation TextCell

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
        
        // 2.添加正文
        UIButton *contentBtn = [[UIButton alloc] init];
        contentBtn.titleLabel.font = NJTextFont;
        [contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 设置自动换行
        contentBtn.titleLabel.numberOfLines = 0;
        
        // contentBtn.backgroundColor = [UIColor redColor];
        
        // contentBtn.titleLabel.backgroundColor = [UIColor purpleColor];
        
        [self.contentView addSubview:contentBtn];
        self.contentBtn = contentBtn;
        
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
        self.contentBtn.contentEdgeInsets = UIEdgeInsetsMake(NJEdgeInsetsWidth, NJEdgeInsetsWidth, NJEdgeInsetsWidth, NJEdgeInsetsWidth);
    }
    return self;
}




-(void)setCellValue:(NSMutableAttributedString *) str time:(NSString*)ptime userType:(UserType)type
{
  //首先为他们的子控件添加frame
    
    CGRect timeF = CGRectMake(0, 0, 0, 0);;
    /**
     *  头像frame
     */
     CGRect iconF = CGRectMake(0, 0, 0, 0);;
    /**
     *  正文frame
     */
    CGRect textF = CGRectMake(0, 0, 0, 0);;
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //间隙
    CGFloat padding = 10;
    
    timeF = CGRectMake(0, 0, 0, 0);

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
    
    
    //CGSize maxSize = CGSizeMake(200, MAXFLOAT);
   // CGSize textSize = [_message.text sizeWithFont:NJTextFont maxSize:maxSize];
    
  
    
    //第一种方案计算宽高
    
    self.attrString = str;
  //  NSLog(@"%@",self.attrString);
    
    //由text计算出text的宽高
    CGRect bound = [self.attrString boundingRectWithSize:CGSizeMake(250, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
       CGFloat textW = bound.size.width + NJEdgeInsetsWidth * 2;
      CGFloat textH = bound.size.height + NJEdgeInsetsWidth * 2;
    
    
    
 //   CGFloat textW = textSize.width + NJEdgeInsetsWidth * 2;
 //   CGFloat textH = textSize.height + NJEdgeInsetsWidth * 2;
    
    CGFloat textY = iconY-5;
    CGFloat textX = 0;
    if (MySelf == type) {
        // 自己发的
        // x = 头像x - 间隙 - 文本的宽度
        textX = iconX - padding - textW;
    }else
    {
        // 别人发的
        // x = 头像最大的X + 间隙
        textX = CGRectGetMaxX(iconF) + padding;
    }
    textF = CGRectMake(textX, textY, textW, textH);
    

    
 
    
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
    
    // 3.设置正文
    [self.contentBtn setAttributedTitle:str forState:UIControlStateNormal];
    self.contentBtn.frame = textF;
    
    // 4.设置背景图片
    UIImage *newImage =  nil;
    if (MySelf == type) {
        newImage = [UIImage resizableImageWithName:@"chat_send_nor"];
        
    }else
    {
        // 别人发的
        newImage = [UIImage resizableImageWithName:@"chat_recive_nor"];
    }
    [self.contentBtn setBackgroundImage:newImage forState:UIControlStateNormal];
}

/*    //设置图片
    UIImage *image = [UIImage imageNamed:@"chatfrom_bg_normal.png"];
    image = [image resizableImageWithCapInsets:(UIEdgeInsetsMake(image.size.height * 0.6, image.size.width * 0.4, image.size.height * 0.3, image.size.width * 0.4))];
    
    //image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
    
    
    [self.chatBgImageView setImage:image];
    
    self.chatTextView.attributedText = str;
    
    */

/*

- (void)awakeFromNib
{
    // Initialization code
}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
