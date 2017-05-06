//
//  FileCell.m
//  ios约束版
//
//  Created by tongho on 16/8/14.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "FileCell.h"

#import "MyImageCell.h"
#import "UIImage+Extension.h"
#import "MessageModule.h"

#import "sChatDb.h"
#import "gChatDb.h"
//#import <UIKit+AFNetworking.h>

@interface FileCell()
//@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
//@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) finderBlock finderBlock;

@property (strong, nonatomic) flagBlock flagblock;

@property (strong, nonatomic) UIImage *buttonImage;


//@property (strong, nonatomic) NSURL *imageUrl;


@property (nonatomic, weak) UIButton *imageButton;// button



@property (nonatomic, weak) UIImageView *bgImageView;//图片

@property (nonatomic ,weak) UILabel * fileNamel;     //文件名文本





/*  头像
 */
@property (nonatomic, weak) UIImageView *iconView;


@end

@implementation FileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 添加将来有可能用到的子控件
        // 1.添加时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        // 2.添加按钮
        UIButton *imageButton = [[UIButton alloc] init];
        [imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [imageButton addTarget:self action:@selector(tapImageButton:) forControlEvents:UIControlEventTouchUpInside];
        
         //往按钮上添加图片
        
        UIImage *fileImage = [UIImage imageNamed:@"aa1.png"];
        UIImageView *fileImageView = [[UIImageView alloc]init];
        fileImageView.frame = CGRectMake(20, 20, 40, 40);
        fileImageView.image = fileImage;
        self.fileImageView = fileImageView;
        [imageButton addSubview:fileImageView];
        
        
        //往按钮上添加三个重叠的按钮
        
        //1.点击打开文件夹按钮
        
        UIButton *finderButton = [[UIButton alloc] init];
        finderButton.frame = CGRectMake(170, 70, 15, 15);
        [finderButton setBackgroundImage:[UIImage imageNamed:@"ar0.png"] forState:UIControlStateNormal];
        
        [finderButton addTarget:self action:@selector(showfinder:) forControlEvents:UIControlEventTouchUpInside];
        finderButton.hidden = YES;
        self.finderButton = finderButton;
        [imageButton addSubview:finderButton];
        
        
        
        //2.下载失败，重新下载按钮
        
        
        UIButton *reLoadButton = [[UIButton alloc] init];
        reLoadButton.frame = CGRectMake(170, 70, 15, 15);
        [reLoadButton setBackgroundImage:[UIImage imageNamed:@"a1x.png"] forState:UIControlStateNormal];
        
        [reLoadButton addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];
        
        reLoadButton.hidden = YES;
        self.reloadButton  =reLoadButton;
        [imageButton addSubview:reLoadButton];
        
        //3.下载按钮
        
        UIButton *loadButton = [[UIButton alloc] init];
        loadButton.frame = CGRectMake(170, 70, 15, 15);
        [loadButton setBackgroundImage:[UIImage imageNamed:@"wa.png"] forState:UIControlStateNormal];
        
        [loadButton addTarget:self action:@selector(loadFile:) forControlEvents:UIControlEventTouchUpInside];
        
        loadButton.hidden = NO;
        self.loadButton = loadButton;
        [imageButton addSubview:loadButton];
        
        //在按钮上添加下载文本
        UILabel *loadMessage = [[UILabel alloc]init];
        loadMessage.frame = CGRectMake(20, 70, 150, 15);
        loadMessage.font = [UIFont systemFontOfSize:10];
    
        loadMessage.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [imageButton addSubview:loadMessage];
        loadMessage.text = @"点击下载";
        loadMessage.textColor = [UIColor greenColor];
        self.loadMessage = loadMessage;
        
        [self.contentView addSubview:imageButton];
        
        
         //在按钮上添加一个文本显示文件大小
        UILabel *loadSize = [[UILabel alloc]init];
        loadSize.frame = CGRectMake(80, 70, 100, 15);
        loadSize.font = [UIFont systemFontOfSize:10];
        
        loadSize.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [imageButton addSubview:loadSize];
        loadSize.text = @"";
        loadSize.textColor = [UIColor grayColor];
        self.loadSize = loadSize;

        
        [self.contentView addSubview:imageButton];

       
        
        
        
        //往按钮上添加文件名文本
        
        UILabel *fileName = [[UILabel alloc]init];
        fileName.frame = CGRectMake(65, -5, 100, 100);
        fileName.font = [UIFont systemFontOfSize:14];
        
        fileName.numberOfLines = 3;
        
        fileName.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [imageButton addSubview:fileName];
        self.fileNamel = fileName;
        
        
        [self.contentView addSubview:imageButton];
        //添加imageview
        //  UIImageView *bgImageView = [[UIImageView alloc] init];
        // [self.bgImageView addSubview:imageButton];
        self.imageButton = imageButton;
        
        //self.bgImageView = bgImageView;
        
        
        
        // 3.添加头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        // 4.清空cell的背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        // 5.设置按钮的内边距
        /*
         CGFloat top,
         CGFloat left,
         CGFloat bottom,
         CGFloat right
         */
        self.imageButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}



-(void)setCellValue:(NSString *) sendName time:(NSString*)ptime userType:(UserType)type
{
    //self.imageUrl = [NSURL URLWithString:imageURL];
    NSArray *listItems = [sendName componentsSeparatedByString:@" "];
    
    _fileNamel.text = listItems[0];
    
    long int size = [listItems[1] longLongValue];
    NSString *unit = @"";
    if (size > 1024) {
        size  = size/1024;
        unit = @"kb";
    }
    if (size > 1024*1024) {
        size  = size/1024/1024;
        unit = @"Mb";
    }
    NSString *stringInt = [NSString stringWithFormat:@"%ld",size];
     NSString *newString = [NSString stringWithFormat:@"%@%@",stringInt,unit];
    _loadSize.text = newString;
    
    
    
    CGRect timeF = CGRectMake(0, 0, 0, 0);;
    /**
     *  头像frame
     */
    CGRect iconF = CGRectMake(0, 0, 0, 0);;
    /**
     *  图片frame
     */
    CGRect viewF = CGRectMake(0, 0, 0, 0);;
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //间隙
    CGFloat padding = 10;
    
    if (YES == _showTime) { // 是否需要计算时间的frame
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeH = 30;
        CGFloat timeW = screenWidth;
        timeF = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    // 2.头像frame
    CGFloat iconH = 30;
    CGFloat iconW = 30;
    CGFloat iconY = CGRectGetMaxY(timeF) + padding;
    
    CGFloat iconX = 0;
    if (MySelf == type) {// 自己发的
        // x = 屏幕宽度 - 间隙 - 头像宽度
        iconX = screenWidth - padding - iconW;
    }else
    {
        // 别人发的
        iconX = padding;
    }
    
    iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    //第一种方案计算宽高
    
    
    
    
    
    CGFloat viewW = 200;
    CGFloat viewH = 100;
    //CGSize maxSize = CGSizeMake(200, MAXFLOAT);
    // CGSize textSize = [_message.text sizeWithFont:NJTextFont maxSize:maxSize];
    CGFloat viewY = iconY-5;
    CGFloat viewX = 0;
    if (MySelf == type) {
        // 自己发的
        // x = 头像x - 间隙 - 文本的宽度
        viewX = iconX - padding - viewW;
    }else
    {
        // 别人发的
        // x = 头像最大的X + 间隙
        viewX = CGRectGetMaxX(iconF) + padding;
    }
    viewF = CGRectMake(viewX, viewY, viewW, viewH);
    
    
    
    
    
    //接着为textcell的子控件添加实际文字内容与位置
    
    self.timeLabel.text = ptime;
    self.timeLabel.frame = timeF;
    
    
    // 2.设置头像
    if (MySelf == type) {
        
        // 自己发的
        self.iconView.image = _myIcon;
    }else
    {
        self.iconView.image = _heIcon;
    }
    self.iconView.frame = iconF;
    
    // 3.设置bgview
    
    self.imageButton.frame = viewF;
    
    // 4.设置背景图片
    UIImage *newImage =  nil;
    if (MySelf == type) {
        newImage = [UIImage resizableImageWithName:@"chat_send_nor"];
        
    }else
    {
        // 别人发的
        newImage = [UIImage resizableImageWithName:@"chat_recive_nor"];
    }
    //
    //   newImage = [newImage resizableImageWithCapInsets:(UIEdgeInsetsMake(newImage.size.height * 0.6, newImage.size.width * 0.4, newImage.size.height * 0.3, newImage.size.width * 0.4))];
    
     [self.imageButton setBackgroundImage:newImage forState:UIControlStateNormal];
    
    
    
    
    
    //self.buttonImage = sendImage;//block 回调参数
    /*    UIImage *image = [UIImage imageNamed:@"chatto_bg_normal.png"];
     image = [image resizableImageWithCapInsets:(UIEdgeInsetsMake(image.size.height * 0.6, image.size.width * 0.4, image.size.height * 0.3, image.size.width * 0.4))];*/
    
    
    // [self.bgImageView setImage:sendImage];
    
    
    //  NSLog(@"%@", imageURL);
    
    //[self.imageButton setImage:sendImage forState:UIControlStateNormal];
    
    // [self.imageButton setImageForState:UIControlStateNormal withURL:_imageUrl placeholderImage:[UIImage imageNamed:@"chat_bottom_smile_press.png"]];
}

//-(void)setButtonImageBlock:(ButtonImageBlock)block
//{
//    self.imageBlock = block;
//}

- (void)tapImageButton:(UIButton*)sender
{
   // self.imageBlock(self.buttonImage);
}


-(void)showfinder:(UIButton*)sender
{
    //点击后将会向聊天控制器回传，使得控制器跳转进入文件查看器
    self.finderBlock();

}


-(void) setflagBlock:(flagBlock)block
{
    _flagblock = block;

}

-(void) setfinderBlock:(finderBlock)block
{

    _finderBlock = block;


}

-(void)reload:(UIButton*)sender
{
    
     self.flagblock(2);  //正在下载
    //设置标签为正在下载，禁止此按钮的点击
    _reloadButton.userInteractionEnabled = NO;
    _loadMessage.text = @"正在下载";
    //此处执行向服务器发送下载包
    [[MessageModule instance] getFullFileWithMsgID:_messageId sessionType:_sessionType success:^(IMMessageEntity* msg){
        
        //若成功隐藏上面的两个按钮，显示信息，下载成功，将数据库中的标识改为已完成
        self.flagblock(1);   //下载成功
        
    }failure:^(NSString *error) {
        
        //若失败显示reload按钮,设置标签为下载失败，将数据库中的标识改为下载失败
        
        self.flagblock(3);    //下载失败
        
    }];


}


-(void)loadFile:(UIButton*)sender
{
    self.flagblock(2);  //正在下载
    //设置标签为正在下载,禁止下载按钮的点击,设置信息为正在下载，将数据库中的信息改为下载中，将信息回传给聊天框
    _loadButton.userInteractionEnabled=NO;
    _loadMessage.text = @"正在下载";
    
    //此处执行向服务器发送下载包
    [[MessageModule instance] getFullFileWithMsgID:_messageId sessionType:_sessionType success:^(IMMessageEntity* msg){
        
        //若成功隐藏上面的两个按钮，显示信息，下载成功，将数据库中的标识改为已完成
        self.flagblock(1);   //下载成功
        
    }failure:^(NSString *error) {
        
        //若失败显示reload按钮,设置标签为下载失败，将数据库中的标识改为下载失败
        
        self.flagblock(3);    //下载失败
        
    }];


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

