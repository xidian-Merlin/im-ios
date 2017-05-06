//
//  UILabel+MyLable.m
//
//  Created by zqt on 15/12/19.
//  Copyright (c) 2015年 missummer. All rights reserved.
//

#import "UILabel+MyLable.h"

@implementation UILabel (MyLable)
+ (UILabel *)initWithText:(NSString *)title withFontSize:(int)fontSize WithFontColor:(UIColor *)color WithMaxSize:(CGSize)maxSize
{
    UILabel *lab = [[UILabel alloc] init];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = title;
    lab.textColor = color;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:fontSize];
    CGSize size = [lab sizeThatFits:maxSize];
    lab.frame = CGRectMake(0, 0, size.width, size.height);
    return lab;
}
-(CGSize)WithText:(NSString *)title withFontSize:(int)fontSize WithFontColor:(UIColor *)color WithMaxSize:(CGSize)maxSize
{
    self.text = title;
    self.textColor = color;
    self.textAlignment = NSTextAlignmentCenter;
    self.numberOfLines = 0;
    self.font = [UIFont systemFontOfSize:fontSize];
    CGSize size = [self sizeThatFits:maxSize];
    return size;
}
- (CGSize)getSelfSizeWithMaxSize:(CGSize)maxSize
{
    CGSize size = [self sizeThatFits:maxSize];
    return size;
}

@end
