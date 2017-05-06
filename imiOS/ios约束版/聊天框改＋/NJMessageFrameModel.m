//
//  NJMessageFrameModel.m
//  01-QQ聊天
//
//  Created by apple on 14-5-30.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "NJMessageFrameModel.h"
#import "NJMessageModel.h"
#import "NSString+Extension.h"



@implementation NJMessageFrameModel


-(void)setMessage:(NJMessageModel *)message
{
    _message = message;
    
    
    // 屏幕宽度
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //间隙
    CGFloat padding = 10;
    
    
    // 1.时间
    if (NO == message.hiddenTime) { // 是否需要计算时间的frame
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeH = 30;
        CGFloat timeW = screenWidth;
        _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    // 2.头像
    CGFloat iconH = 30;
    CGFloat iconW = 30;
    CGFloat iconY = CGRectGetMaxY(_timeF) + padding;
    
    CGFloat iconX = 0;
    if (NJMessageModelTypeMe == _message.type) {// 自己发的
        // x = 屏幕宽度 - 间隙 - 头像宽度
        iconX = screenWidth - padding - iconW;
    }else
    {
        // 别人发的
        iconX = padding;
    }
    
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 3.正文
    /*
    NSDictionary *dict = @{NSFontAttributeName: NJTextFont};
    CGSize maxSize = CGSizeMake(200, MAXFLOAT);
    CGSize textSize = [_message.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
     */
    /*
    CGSize maxSize = CGSizeMake(200, MAXFLOAT);
    CGSize textSize = [self sizeWithString:_message.text font:NJTextFont maxSize:maxSize];
     */
    CGSize maxSize = CGSizeMake(200, MAXFLOAT);
    CGSize textSize = [_message.text sizeWithFont:NJTextFont maxSize:maxSize];
    
    CGFloat textW = textSize.width + NJEdgeInsetsWidth * 2;
    CGFloat textH = textSize.height + NJEdgeInsetsWidth * 2;
    
    CGFloat textY = iconY;
    CGFloat textX = 0;
    if (NJMessageModelTypeMe == _message.type) {
        // 自己发的
        // x = 头像x - 间隙 - 文本的宽度
        textX = iconX - padding - textW;
    }else
    {
        // 别人发的
        // x = 头像最大的X + 间隙
        textX = CGRectGetMaxX(_iconF) + padding;
    }
    _textF = CGRectMake(textX, textY, textW, textH);
    
    // 4.行高
    CGFloat maxIconY = CGRectGetMaxY(_iconF);
    CGFloat maxTextY = CGRectGetMaxY(_textF);
    
    // _cellHeight = (maxIconY > maxTextY?  (maxIconY + padding) :  (maxIconY + padding));
    _cellHeight = MAX(maxIconY, maxTextY) + padding;
}

/*
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}
 */
@end
