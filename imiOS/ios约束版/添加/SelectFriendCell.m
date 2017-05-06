//
//  SelectFriendCell.m
//  ios约束版
//
//  Created by tongho on 16/8/3.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "SelectFriendCell.h"
#import "UILabel+MyLable.h"
//RGB的颜色转换
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)



@interface SelectFriendCell ()

//选中按钮
@property (nonatomic,retain) UIButton *selectBtn;

@end



@implementation SelectFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        self.backgroundColor = kUIColorFromRGB(0xffffff);
        [self createView];
        
    }
    return self;
}

- (void)createView {
    
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
    [self.contentView addSubview:self.headImage];
    
    self.nameLabel = [UILabel initWithText:@"壹休" withFontSize:16 WithFontColor:kUIColorFromRGB(0x666666) WithMaxSize:CGSizeMake(WIDTH - 50, 14)];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.frame = CGRectMake(60, 15, WIDTH - 90, 25);
    [self.contentView addSubview:self.nameLabel];
    
    
    //选中按钮
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(WIDTH - 35, 15, 20, 20);
    self.selectBtn.selected = self.isSelected;
    [self.selectBtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
    
    [self.contentView addSubview:self.selectBtn];
    
    
    
    //该按钮覆盖在整个cell上
    _bigSelectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _bigSelectBtn.frame = CGRectMake(0, 0, WIDTH , 50);
    _bigSelectBtn.backgroundColor = [UIColor clearColor];
    [_bigSelectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_bigSelectBtn];
    //这样可以自定义cell线？
    _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 59.5, WIDTH, 0.5)];
    _lineLabel.backgroundColor = kUIColorFromRGB(0xf0f0f0);
    [self.contentView addSubview:_lineLabel];
    
}
//setcell 方法
-(void)reloadDataWith:(historyHf *)model {
    self.nameLabel.text = model.nickName2;
    
    //
    
    self.selectBtn.selected = self.isSelected;
    
    UIImage *image = [UIImage imageWithData:model.icon];
    self.headImage.image = image;

}

//选中按钮点击事件    点击大按钮，将改变小按钮的状态
-(void)selectBtnClick:(UIButton*)button
{
    NSLog(@"FDS");
    self.selectBtn.selected = !self.selectBtn.selected;
    if (self.cartBlock) {
        self.cartBlock(self.selectBtn.selected);
    }
    
}



@end
