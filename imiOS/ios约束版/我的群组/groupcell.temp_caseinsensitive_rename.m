//
//  groupInfoCell.m
//  ios约束版
//
//  Created by tongho on 16/9/7.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "groupcell.h"
#import "StitchingImage.h"
#import "GroupMemeberDb.h"
#import "GroupMemeberModel.h"


@implementation groupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        
        // 添加将来有可能用到的子控件
        
        UILabel *lastMessage = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, screenWidth-200, 10)];
        lastMessage.font = [UIFont systemFontOfSize:13];
        lastMessage.textColor = [UIColor grayColor];
        [self.contentView addSubview:lastMessage];
        self.lastMessage = lastMessage;
        
        
        UILabel *useNameLable = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 200, 25)];
        useNameLable.backgroundColor=[UIColor clearColor];
        useNameLable.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:useNameLable];
        
        self.userNameLabel = useNameLable;
        
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth-60, 5, 50, 10)];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:timeLabel];
        self.timeLable = timeLabel;
        
        /*       // 2.添加按钮到背景图片
         UIButton *imageButton = [[UIButton alloc] init];
         [imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         
         [imageButton addTarget:self action:@selector(tapImageButton:) forControlEvents:UIControlEventTouchUpInside];
         [self.contentView addSubview:imageButton];
         //添加imageview
         //  UIImageView *bgImageView = [[UIImageView alloc] init];
         // [self.bgImageView addSubview:imageButton];
         self.imageButton = imageButton;
         
         //self.bgImageView = bgImageView;
         
         */
        
        
        // 4.清空cell的背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
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







-(void)setCellValue:(NSString *)username lastMessage:(NSString *)lastMessage icon:(NSData *)headimage time:(NSString *)time chatStyle:(int)chatStyle
{
    
    
    
    
    if (1 == chatStyle) {
        
        
        for (UIView *subviews in [self.contentView subviews]) {
            if (subviews.tag==1) {
                [subviews removeFromSuperview];
            }
        }
        
        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
        [self.contentView addSubview:headImage];
        
        //当为调聊时才添加小红点到底层图片上，防止被群聊视图覆盖
        _hub = [[RKNotificationHub alloc]initWithView:headImage];
        [_hub moveCircleByX:-3 Y:3]; // moves the circle five pixels left and 5 down
        [_hub scaleCircleSizeBy:0.6];
        headImage.tag = 22;
        self.headImage = headImage;
        UIImage *image = [UIImage imageWithData: headimage];
        
        self.headImage.image = image;
    }
    
    
    
    
    self.userNameLabel.text = username;
    self.lastMessage.text = lastMessage;
    
    self.timeLable.text = time;
    
    
    
    
    
}



- (void)createIconWihgroupId:(int)groupId {
    //查询数据库，找到该群组成员头像，如果成员数目大于9，那么就取前9个成员的头像进行平接
    
    NSArray *members = [NSArray array];
    GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
    
    BOOL creat =   [gmdb createTableWithGroupId:groupId];
    
    if (creat) {
        members =  [gmdb queryAll];
    }
    
    if (members.count >9) {
        members = [members subarrayWithRange:NSMakeRange(0, 8)]; //截取前9个元素
    }
    
    
    // 将你要拼接的头像文件放入到一个 NSMutableArray 中
    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    
    for (GroupMemeberModel *model in members) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        
        imageView.image = [UIImage imageWithData:model.icon];
        
        // imageView.image = [UIImage imageNamed:@"me.png"];
        [imageViews addObject:imageView];     // 将前九个的头像传进去
    }
    
    
    for (UIView *subviews in [self.contentView subviews]) {
        if (subviews.tag==22) {
            [subviews removeFromSuperview];
        }
    }
    
    // 生成一个背景 canvasView, 用于存放拼接好的群组封面, 相当于背景.
    UIImageView *canvasView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    canvasView.layer.cornerRadius = 10;
    canvasView.layer.masksToBounds = YES;
    canvasView.backgroundColor = [UIColor colorWithWhite:0.839 alpha:1.000];
    
    // 现在你可以调用以下方法, 将用户的头像画到指定的 canvasView 上
    UIImageView *coverImage = [[StitchingImage alloc] stitchingOnImageView:canvasView withImageViews:imageViews];
    // coverImage.image =  [UIImage imageNamed:@"me.png"];
    _hub = [[RKNotificationHub alloc]initWithView:canvasView];
    [_hub moveCircleByX:-3 Y:3]; // moves the circle five pixels left and 5 down
    [_hub scaleCircleSizeBy:0.6];
    coverImage.tag =1;
    
    [self.contentView addSubview:coverImage];
    self.headImage = coverImage;
    //   self.headImage.image = nil;
    //   self.headImage= coverImage;   //将群头像的画布传给iconview;
    
    
    
}




- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

