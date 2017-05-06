//
//  VoiceCellTableViewCell.m
//  CocoaPods
//
//  Created by tongho on 16/7/9.
//  Copyright © 2016年 im. All rights reserved.
//

#import "VoiceCellTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Extension.h"

@interface VoiceCellTableViewCell()

#define NJTextFont [UIFont systemFontOfSize:15]
#define NJEdgeInsetsWidth 20
@property (strong, nonatomic) NSURL *playURL;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic, weak)  UIImageView *fileImageView;
//* 时间


/**正文
 */
@property (nonatomic, weak) UIButton *voiceBtn;
/**头像
 */
@property (nonatomic, weak) UIImageView *iconView;


@end

@implementation VoiceCellTableViewCell


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
        
        // 2.添加正文
        UIButton* voiceBtn = [[UIButton alloc] init];
        voiceBtn.titleLabel.font = NJTextFont;
        
        [voiceBtn addTarget:self action:@selector(tapVoiceButton:) forControlEvents:UIControlEventTouchUpInside];
        [voiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 设置自动换行
        voiceBtn.titleLabel.numberOfLines = 0;
        
        // contentBtn.backgroundColor = [UIColor redColor];
        
        // contentBtn.titleLabel.backgroundColor = [UIColor purpleColor];
        
        [self.contentView addSubview:voiceBtn];
        self.voiceBtn = voiceBtn;
        
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
        self.voiceBtn.contentEdgeInsets = UIEdgeInsetsMake(NJEdgeInsetsWidth, NJEdgeInsetsWidth, NJEdgeInsetsWidth, NJEdgeInsetsWidth);
        
        
        UIImage *fileImage = [UIImage imageNamed:@"adj.png"];
        UIImageView *fileImageView = [[UIImageView alloc]init];
        fileImageView.frame = CGRectMake(110, 14, 35, 35);
        fileImageView.image = fileImage;
        self.fileImageView = fileImageView;
        [_voiceBtn addSubview:_fileImageView];
        _fileImageView.hidden = YES;

        
        
    }
    return self;
}





-(void)setCellValue:(NSString *)dic time:(NSString*)ptime userType:(UserType)type

{
    CGRect timeF = CGRectMake(0, 0, 0, 0);;
    /**
     *  头像frame
     */
    CGRect iconF = CGRectMake(0, 0, 0, 0);;
    /**
     *  图片frame
     */
    CGRect voiceF = CGRectMake(0, 0, 0, 0);;
    
    
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
    
    
    
    //计算气泡的的宽高
    
    //由text计算出text的宽高
   
    
    
    //   CGFloat textW = textSize.width + NJEdgeInsetsWidth * 2;
    //   CGFloat textH = textSize.height + NJEdgeInsetsWidth * 2;
    
    CGFloat voiceW =  120+ NJEdgeInsetsWidth * 2;
    CGFloat voiceH =  20+ NJEdgeInsetsWidth * 2;
    
    //CGSize maxSize = CGSizeMake(200, MAXFLOAT);
    // CGSize textSize = [_message.text sizeWithFont:NJTextFont maxSize:maxSize];
    CGFloat voiceY = iconY-5;
    CGFloat voiceX = 0;
    if (MySelf == type) {
        // 自己发的
        // x = 头像x - 间隙 - 文本的宽度
        voiceX = iconX - padding - voiceW;
    }else
    {
        // 别人发的
        // x = 头像最大的X + 间隙
        voiceX = CGRectGetMaxX(iconF) + padding;
    }
    voiceF = CGRectMake(voiceX, voiceY, voiceW, voiceH);
    
    
    
    
    
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
    
    // 3.设置voiceframe与内容
   
    
    self.voiceBtn.frame = voiceF;
    
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
    
    [self.voiceBtn setBackgroundImage:newImage forState:UIControlStateNormal];
    
   //  NSString *time1  = self.messages[indexPath.row][@"body"][@"time"];
    _playURL = [NSURL fileURLWithPath:dic];
    
    self.audioPlayer= [[AVAudioPlayer alloc]initWithContentsOfURL:_playURL error:nil];
    
    //设置代理
    _audioPlayer.delegate = self;
    
    float duration = (float)self.audioPlayer.duration;
   
    NSString *str = @"语音";
    //NSString *str1 = @"“";
    NSString *stringFloat = [NSString stringWithFormat:@"%@%.0f”",str,duration];
    
    if (duration >60) {
        int min = duration/60;
        int sec = duration - 60*min;
        stringFloat = [NSString stringWithFormat:@"%@%d‘%d”",str,min,sec];
    }
    
     [self.voiceBtn setTitle:stringFloat forState:UIControlStateNormal];
    //  _playURL = [NSURL URLWithString: dic[@"content"]];
    //此处直接传字典，避免转换过程的麻烦
     }

-(void)tapVoiceButton:(UIButton *) sender
{
    
  //  NSLog(@"地址++++%@",_playURL);
       NSError *error = nil;
    /*  AVAudioPlayer *player*/
  //  self.audioPlayer= [[AVAudioPlayer alloc]initWithContentsOfURL:_playURL error:&error];
  //  float duration = (float)self.audioPlayer.duration;
  
    if (error) {
          NSLog(@"播放错误：%@",[error description]);
      }
     // self.audioPlayer = player;
    
    
    
    
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer pause];
        UIImage *fileImage1 = [UIImage imageNamed:@"avv.png"];
        _fileImageView.frame = CGRectMake(110, 14, 30, 30);
        self.fileImageView.image = fileImage1;

    }else {
        UIImage *fileImage1 = [UIImage imageNamed:@"adj.png"];
        _fileImageView.frame = CGRectMake(110, 14, 35, 35);
        self.fileImageView.image = fileImage1;
        [self.audioPlayer play];
        _fileImageView.hidden = NO;
    
    
    }  }
  
 
 /*
- (IBAction)tapVoiceButton:(id)sender {
    [self httpGetVoice];
}
*/
/*
//网络请求声音
-(void)httpGetVoice
{
    NSData *data = [NSData dataWithContentsOfURL:_playURL];
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithData:data error:&error];
    if (error) {
        NSLog(@"播放错误：%@",[error description]);
    }
    self.audioPlayer = player;
    [self.audioPlayer play];
    NSLog(@"%@", _playURL);

    
}

*/


-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //     [self.timer invalidate];直接销毁，之后不可用，慎重考虑
    _fileImageView.hidden = YES;

    //    [self.timer setFireDate:[NSDate date]]; //继续
    //    [self.timer setFireDate:[NSDate distantPast]];//开启
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
