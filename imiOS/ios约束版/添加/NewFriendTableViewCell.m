//
//  NewFriendTableViewCell.m
//  ios约束版
//
//  Created by tongho on 16/8/3.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "NewFriendTableViewCell.h"

#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface NewFriendTableViewCell()


@end

@implementation NewFriendTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        
        // 添加将来有可能用到的子控件
        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
        [self.contentView addSubview:headImage];
        
        self.headImage = headImage;
        
        UILabel *lastMessage = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, screenWidth-200, 10)];
        lastMessage.font = [UIFont systemFontOfSize:13];
        lastMessage.textColor = [UIColor grayColor];
        [self.contentView addSubview:lastMessage];
        self.lastMessage = lastMessage;
        
        
        UILabel *useNameLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 200, 25)];
        useNameLable.backgroundColor=[UIColor clearColor];
        useNameLable.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:useNameLable];
        
        self.userNameLabel = useNameLable;
        
     /*
        self.sendTextButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.sendTextButton setBackgroundImage:[UIImage imageNamed:@"chat_botton_textfield.png"] forState:UIControlStateNormal];
        // [self.sendTextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // [self.sendTextButton setTitleColor:[UIColor blackColor] forSTate:UIControlStateNormal];
        [self.sendTextButton setTitle:@"发送" forState:UIControlStateNormal];
        [self.sendTextButton addTarget:self action:@selector(tapsendTextButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.sendTextButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        self.sendTextButton.hidden = YES;
        [self addSubview:self.sendTextButton];
     */
        
        
        _bSelectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _bSelectBtn.frame = CGRectMake(WIDTH - 60, 15, 50, 20);
       // _bSelectBtn.backgroundColor = [UIColor clearColor];
        
       // [self.bSelectBtn setBackgroundImage:[UIImage imageNamed:@"a4l.png"] forState:UIControlStateNormal];
        [self.bSelectBtn setTitle:@"已添加" forState:UIControlStateNormal];
        [_bSelectBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        self.bSelectBtn.hidden = YES;
        [self.contentView addSubview:_bSelectBtn];
        
        
        
        
        
        
        //选中按钮
        self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 60, 15, 50, 20)];
       // self.selectBtn.frame = CGRectMake(WIDTH - 50, 15, 40, 20);
        //self.selectBtn.selected = self.isSelected;
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"vx.9.png"] forState:UIControlStateNormal];
       // [self.selectBtn setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
        [self.selectBtn setTitle:@"添加" forState:UIControlStateNormal];
       [self.selectBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
          [_selectBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
       
        [self.contentView addSubview:self.selectBtn];
        
        
        
    /*
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth-60, 5, 50, 10)];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:timeLabel];
        self.timeLable = timeLabel;
        */
       
        
        
        // 4.清空cell的背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        // 5.设置按钮的内边距
        /*
         CGFloat top,
         CGFloat left,
         CGFloat bottom,
         CGFloat right
         */
        // self.imageButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}







-(void)setCellValue:(NSString *)username lastMessage:(NSString *)lastMessage icon:(NSData *)headimage
{
    
    
    self.userNameLabel.text = username;
    self.lastMessage.text = lastMessage;
    
    UIImage *image = [UIImage imageWithData: headimage];
    
    self.headImage.image = image;
    
    
    
}

- (void)awakeFromNib
{
    // Initialization code
}

//选中按钮点击事件
-(void)tapButton:(UIButton*)button
{   NSLog(@"fdsfdf");
    self.selectBtn.selected = !self.selectBtn.selected;
    if (self.selectBlock) {
        self.selectBlock(self.selectBtn.selected);
    }
    
    self.selectBtn.selected = !self.selectBtn.selected;    //从点击状态返回，以防添加失败，还可以再次点击
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end