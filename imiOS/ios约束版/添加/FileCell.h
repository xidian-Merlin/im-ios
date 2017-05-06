//
//  FileCell.h
//  ios约束版
//
//  Created by tongho on 16/8/14.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>

//枚举用户类型
#import "userType.h"


//button点击回调传出图片
typedef void(^finderBlock)(void);
typedef void(^flagBlock)(int loadState);

@interface FileCell : UITableViewCell

@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic,assign) BOOL showTime;
@property (nonatomic, strong) UIImage *myIcon;
@property (nonatomic, strong) UIImage *heIcon;


@property (nonatomic ,weak) UILabel * loadMessage;  //下载信息提示

@property (nonatomic ,weak) UILabel * loadSize;
@property (nonatomic, weak) UIButton *finderButton;

@property (nonatomic, weak) UIButton *reloadButton;

@property (nonatomic, weak) UIButton *loadButton;

@property (nonatomic, weak)  UIImageView *fileImageView;

@property (nonatomic, assign) int messageId;

@property (nonatomic, assign) int sessionType;  //群聊或单聊





//-(void)setButtonImageBlock:(ButtonImageBlock) block;

-(void) setfinderBlock:(finderBlock)block;

-(void) setflagBlock:(flagBlock)block;

-(void)setCellValue:(NSString *) sendName time:(NSString*)ptime userType:(UserType)type ;//(NSString *) imageURL;

@end
