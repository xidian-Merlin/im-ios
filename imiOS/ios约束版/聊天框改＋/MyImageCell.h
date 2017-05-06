//
//  MyImageCell.h
//  MecoreMessageDemo
//
//  Created by tongho on 16/7/12.
//  Copyright © 2016年 im. All rights reserved.
//

#import <UIKit/UIKit.h>
//枚举用户类型
#import "userType.h"


//button点击回调传出图片
typedef void (^ButtonImageBlock) (UIImage *image);

@interface MyImageCell : UITableViewCell

@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic,assign) BOOL showTime;
@property (nonatomic, strong) UIImage *myIcon;
@property (nonatomic, strong) UIImage *heIcon;

-(void)setButtonImageBlock:(ButtonImageBlock) block;

-(void)setCellValue:(UIImage *) sendImage time:(NSString*)ptime userType:(UserType)type ;//(NSString *) imageURL;

@end
