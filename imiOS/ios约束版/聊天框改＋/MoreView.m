//
//  MoreView.m
//  MyKeyBoard
//


#import "MoreView.h"

@interface MoreView()

@property (nonatomic, strong) MoreBlock block;

@end

//主要是将moreview中的button的标签传入给上层
@implementation MoreView

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, 320, 216);
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [button1 setBackgroundImage:[UIImage imageNamed:@"Fav_Filter_Img_HL"] forState:UIControlStateNormal];
       // [button1 setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fav_Filter_Img_HL@2x@2x" ofType:@"png"]] forState:UIControlStateNormal];
        button1.tag = 1;
        [button1 addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button1];
        
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 40, 80)];
        lable1.text = @"图片";
        lable1.textColor = [UIColor blueColor];
        lable1.font = [UIFont systemFontOfSize:13];
        lable1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lable1];
        
        
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(90, 7, 60, 60)];
        [button2 setBackgroundImage:[UIImage imageNamed:@"AlbumListCamera_ios7"] forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button2.tag = 2;
        [button2 addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button2];
        
        UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(110, 35, 40, 80)];
        lable2.text = @"拍照";
        lable2.font = [UIFont systemFontOfSize:13];
         lable2.textColor = [UIColor blueColor];
        
        [self addSubview:lable2];
        
        //此处将小视频的位置替换为文件的位置
        UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(170, 10, 60, 60)];
        [button3 setBackgroundImage:[UIImage imageNamed:@"a_o.png"] forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button3.tag =5;
        [button3 addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button3];
        
        UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(180, 35, 40, 80)];
        lable3.text = @"文件";
         lable3.textColor = [UIColor blueColor];
        lable3.font = [UIFont systemFontOfSize:13];
        [self addSubview:lable3];
        
        
        /*
        
        UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(250, 7, 60, 60)];
        [button4 setBackgroundImage:[UIImage imageNamed:@"af8.png"] forState:UIControlStateNormal];
        [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button4.tag = 4;
        [button4 addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button4];
        
        UILabel *lable4 = [[UILabel alloc] initWithFrame:CGRectMake(265, 35, 40, 80)];
        lable4.text = @"拍摄";
         lable4.textColor = [UIColor blueColor];
        lable4.font = [UIFont systemFontOfSize:13];
        [self addSubview:lable4];
        
        
        UIButton *button5 = [[UIButton alloc] initWithFrame:CGRectMake(10, 120, 60, 60)];
        [button5 setBackgroundImage:[UIImage imageNamed:@"a_o.png"] forState:UIControlStateNormal];
        // [button1 setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Fav_Filter_Img_HL@2x@2x" ofType:@"png"]] forState:UIControlStateNormal];
        button5.tag = 5;
        [button5 addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button5];
        
        UILabel *lable5 = [[UILabel alloc] initWithFrame:CGRectMake(20, 155, 40, 80)];
        lable5.text = @"文件";
        lable5.textColor = [UIColor blueColor];
        lable5.font = [UIFont systemFontOfSize:13];
        lable5.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lable5];
        */
  
    }
    return self;
}

-(void) setMoreBlock:(MoreBlock)block
{
    self.block = block;
}

-(void) tapButton:(UIButton *)sender
{
    self.block(sender.tag);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
