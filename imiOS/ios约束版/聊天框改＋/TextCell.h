//
//  TextCell.h
//  CocoaPods
//
//  Created by tongho on 16/7/12.
//  Copyright © 2016年 im. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userType.h"


@interface TextCell : UITableViewCell

@property (nonatomic, weak) UILabel *timeLabel;
//@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic,assign) BOOL showTime;
@property (nonatomic, strong) UIImage *myIcon;
@property (nonatomic, strong) UIImage *heIcon;

-(void)setCellValue:(NSMutableAttributedString *) str time:(NSString*)ptime userType:(UserType)type ;

@end
