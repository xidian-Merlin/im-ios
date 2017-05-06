//
//  VoiceCellTableViewCell.h
//  CocoaPods
//
//  Created by tongho on 16/7/9.
//  Copyright © 2016年 im. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userType.h"

@interface VoiceCellTableViewCell : UITableViewCell

-(void)setCellValue:(NSString *)dic time:(NSString*)ptime userType:(UserType)type ;

@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic,assign) BOOL showTime;
@property (nonatomic, strong) UIImage *myIcon;
@property (nonatomic, strong) UIImage *heIcon;


@end
