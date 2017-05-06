//
//  MyGroupListCell.m
//  ios约束版
//
//  Created by tongho on 16/8/18.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "MyGroupListCell.h"
#import "StitchingImage.h"
#import "GroupMemeberDb.h"
#import "GroupMemeberModel.h"

@interface MyGroupListCell()

@end

@implementation MyGroupListCell




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
      //群组的头像是由成员头像拼接而成
    //    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
    //    [self.contentView addSubview:headImage];
        
       // self.iconView = headImage;
        
        
        UILabel *useNameLable = [[UILabel alloc]initWithFrame:CGRectMake(65, 15, 200, 25)];
        useNameLable.backgroundColor=[UIColor clearColor];
        useNameLable.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:useNameLable];
        
        self.groupNameLabel = useNameLable;
        
        
        
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



- (UIImage *)createIconWihgroupId:(int)groupId {
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
    
    
    
    // 生成一个背景 canvasView, 用于存放拼接好的群组封面, 相当于背景.
    UIImageView *canvasView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    canvasView.layer.cornerRadius = 10;
    canvasView.layer.masksToBounds = YES;
    canvasView.backgroundColor = [UIColor colorWithWhite:0.839 alpha:1.000];
    _coverImage = [[UIImageView alloc]init];
    // 现在你可以调用以下方法, 将用户的头像画到指定的 canvasView 上
    _coverImage = [[StitchingImage alloc] stitchingOnImageView:canvasView withImageViews:imageViews];
   // coverImage.image =  [UIImage imageNamed:@"me.png"];
    
    [self.contentView addSubview:_coverImage];
  
    
   // self.iconView= coverImage;   //将群头像传给iconview;
    
   // self.iconView.image = coverImage.image;
    
    return canvasView.image;
    
}








- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
