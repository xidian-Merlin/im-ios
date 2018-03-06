//
//  QRCodeFactory.h
//  QRCodeDemo
//
//  Created by tongho on 2016/10/20.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCodeFactory : NSObject
@property (nonatomic, assign) int userId;

+ (UIImage *)qrImageForIntNumber:(int)intNumber imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize;

@end
