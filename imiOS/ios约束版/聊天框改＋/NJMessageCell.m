//
//  NJMessageCell.m
//  01-QQ聊天
//
//  Created by apple on 14-5-30.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "NJMessageCell.h"
#import "NJMessageFrameModel.h"
#import "NJMessageModel.h"
#import "UIImage+Extension.h"
#import <UIKit/UIKit.h>
@interface NJMessageCell ()
/**
 * 时间
 */
@property (nonatomic, weak) UILabel *timeLabel;
/**
 *  正文
 */
@property (nonatomic, weak) UIButton *contentBtn;
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;

@end

@implementation NJMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"message";
    NJMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NJMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

/*
 重写init方法是为让类一创建出来就拥有某些属性
 */
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

- (void)setMessageFrame:(NJMessageFrameModel *)messageFrame
{
    _messageFrame = messageFrame;
    /*
    // 1.设置子控件的数据
    [self settingData];
    // 2.设置子控件的frame
    [self settingFrame];
     */
    // 0. 获取数据模型
    NJMessageModel *message = _messageFrame.message;
    
    // 1.设置时间
    self.timeLabel.text = message.time;
    self.timeLabel.frame = _messageFrame.timeF;
    
    
    // 2.设置头像
    if (NJMessageModelTypeMe == message.type) {

        // 自己发的
        self.iconView.image = [UIImage imageNamed:@"me"];
    }else
    {
        self.iconView.image = [UIImage imageNamed:@"other"];
    }
    self.iconView.frame = _messageFrame.iconF;

    // 3.设置正文
    [self.contentBtn setTitle:message.text forState:UIControlStateNormal];
    self.contentBtn.frame = _messageFrame.textF;
    
    // 4.设置背景图片
    UIImage *newImage =  nil;
    if (NJMessageModelTypeMe == message.type) {
        // 自己发的
        // UIImage *norImage = [UIImage imageNamed:@"chat_send_nor"];
      /*
         该方法可以返回一张拉伸指定位置的图片
         LeftCapWidth左边多大的距离不可以拉伸(水平方向)
         topCapHeight上边有多大的距离不可以拉伸(垂直方法)
         1 = width - leftCapWidth   - right
         1 = height - topCapWidth  - bottom

         128 * 112  64 * 56
         ios5以前实现拉伸图片指定位置的方法
       */
      // UIImage *newImage =  [norImage stretchableImageWithLeftCapWidth:32 topCapHeight:28];
        /*
        ios5
        指定图片的上边,下边,左边,右边 多少距离是不可以拉伸的
         默认的拉伸方案是平铺
        
        CGFloat w = norImage.size.width;
        CGFloat h = norImage.size.height;
        
        UIImage *newImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(h * 0.5 - 1 , w * 0.5 - 1, h * 0.5 , w * 0.5)];
         */
        
        /*
         ios6
         相比IOS的方法,多了一个指定拉伸模式的参数:
         参数有两种:平铺, 拉伸
         
        CGFloat w = norImage.size.width * 0.5;
        CGFloat h = norImage.size.height * 0.5;
        
        UIImage *newImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
        [self.contentBtn setBackgroundImage:newImage forState:UIControlStateNormal];
         */
        // UIImage *newImage  = [self resizableImageWithName:@"chat_send_nor"];
        newImage = [UIImage resizableImageWithName:@"chat_send_nor"];

    }else
    {
        // 别人发的
        newImage = [UIImage resizableImageWithName:@"chat_recive_nor"];
    }
    [self.contentBtn setBackgroundImage:newImage forState:UIControlStateNormal];
}

/*
// 分类是在不改变原有类的情况下为原有类增加一些新的方法

- (UIImage *)resizableImageWithName:(NSString *)imageName
{
    
    // 加载原有图片
    UIImage *norImage = [UIImage imageNamed:imageName];
    // 获取原有图片的宽高的一半
    CGFloat w = norImage.size.width * 0.5;
    CGFloat h = norImage.size.height * 0.5;
    // 生成可以拉伸指定位置的图片
    UIImage *newImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];

    return newImage;
}
*/
@end
