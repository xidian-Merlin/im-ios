//
//  QRCodeFactory.h
//  QRCodeDemo
//
//  Created by yuhui wang on 2016/10/20.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCodeFactory : NSObject
@property (nonatomic, assign) int userId;

+ (UIImage *)qrImageForIntNumber:(int)intNumber imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize;

@end
