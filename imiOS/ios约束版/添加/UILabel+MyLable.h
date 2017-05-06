//
//  UILabel+MyLable.h
//
//  Created by zqt on 15/12/19.
//  Copyright (c) 2015年 missummer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MyLable)
+ (UILabel *)initWithText:(NSString *)title withFontSize:(int)fontSize WithFontColor:(UIColor *)color WithMaxSize:(CGSize)maxSize;
-(CGSize)WithText:(NSString *)title withFontSize:(int)fontSize WithFontColor:(UIColor *)color WithMaxSize:(CGSize)maxSize;
-(CGSize)getSelfSizeWithMaxSize:(CGSize)maxSize;
@end
