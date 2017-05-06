//
//  ImageViewController.m
//  MecoreMessageDemo
//
//  Created by tongho on 16-11-25.
//  Copyright (c) 2016年 tongho. All rights reserved.
//

#import "ImageViewController.h"
#import "sChatDb.h"
#import "gChatDb.h"
#import "MessageModule.h"
#import "GetFolder.h"   //获取当前目录
#import "MBProgressHUD+NJ.h"



@interface ImageViewController ()


@property (strong, nonatomic)  UIImageView *myImageView;
@property (copy,nonatomic) NSString * strUrl;

@property (copy,nonatomic) NSString * msgContent;




@end

@implementation ImageViewController

- (void)viewDidLoad
{
    
    //_fullPicblock(11);
    
    

    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    NSLog(@"ggggggggg%d",_messageId);
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, screenWidth-20, 450)];
    
    _myImageView.contentMode = UIViewContentModeScaleAspectFit; //展现的形式
    
    // 给view添加捏合手势
    UIPinchGestureRecognizer *PinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(PinchGesture:)];
    // 允许用户交互
    self.myImageView.userInteractionEnabled = YES;
    self.myImageView.multipleTouchEnabled = YES;
    [self.myImageView addGestureRecognizer:PinchGesture];
    [self.view addSubview:_myImageView];
    
        //self.view.contentMode = UIViewContentModeCenter;
    
    // 设置imageView初始显示的图片
    GetFolder *getfolder = [[GetFolder alloc]init];
    _strUrl = [getfolder getFolder];
    
    
  //  self.imageView.image = srcImage;
    //如果不是缩略图，则直接显示
    if (YES == _isFinished) {
    
    [self.myImageView setImage:self.image];
    }
    
    
   
    

    
  //如果，isfinished 为0，缩略图，将在此处请求网络
    
    
    if (NO == _isFinished) {
        //请求网络，将myimage重新賦值,成功后将数据库中的原消息的isfinished值1
        /**
         *  获取完整图片
         *
         *  @param msgID   消息ID
         *  @param success
         *  @param failure
         */
        // 添加蒙版禁止用户操作, 并且提示用户正在加载
        

        /////__weak __block ImageViewController *copy_self = self;
        [MBProgressHUD showMessage:@"正在拼命加载ing...."];
        
                                                                                                       //判断是群聊还是单聊，建立不同的数据表，将它们的content 与flag 辅以新值
                                                     if (NO == _isGruopChat) {
                                                         [[MessageModule instance]getFullPictureWithMsgID:_messageId
                                                                                              sessionType:1
                                                                                                  success:^(IMMessageEntity* msg){
                                                                                                      //显示完整图片
                                                                                                     
                                                                                                    self.NextViewControllerBlock(msg.msgContent);
                                                                                                         
                                                                                                                                                                                               //获取文件地址
                                                                                                      NSString *testPath = [_strUrl stringByAppendingPathComponent:msg.msgContent];
                                                                                                      
                                                                                                      // 此处将图片的地址转化为图片
                                                                                                      
                                                                                                      UIImage * fullImage  = [UIImage imageWithContentsOfFile:testPath];
                                                                                                      [self.myImageView setImage:fullImage];
                                                                                                      //_fullPicblock((int)msg.msgContent);

                                                                                                      
                                                                                                   
                                                                                                      
                                                                                                      //关闭模版
                                                                                                      [MBProgressHUD hideHUD];
                                                                                                      sChatDb * schat = [[sChatDb alloc]init];
                                                                                                      [schat createTableWithContacterId:_chatId];
                                                                                                      [schat updatewihtId:_messageId newContent:msg.msgContent newFinishFlag:YES];
                                                                                                  }failure:^(NSString *error) {
                                                                                                      NSLog(@"修改失败");
                                                                                                      [MBProgressHUD hideHUD];

                                                                                                  //    [MBProgressHUD showError:@"加载失败"];
                                                                                                      [MBProgressHUD hideHUD];
                                                                                                      
                                                                                                      
                                                                                                  }];
                                                         
                                                        
                                                       
                                                     } else {
                                                         [[MessageModule instance]getFullPictureWithMsgID:_messageId
                                                                                              sessionType:2
                                                                                                  success:^(IMMessageEntity* msg){
                                                                                                      //显示完整图片
                                                                                                      self.NextViewControllerBlock(msg.msgContent);
                                                                                                     
                                                                                                      
                                                                                                      NSString *testPath = [_strUrl stringByAppendingPathComponent:msg.msgContent];
                                                                                                      
                                                                                                      // 此处将图片的地址转化为图片
                                                                                                      
                                                                                                      UIImage * fullImage  = [UIImage imageWithContentsOfFile:testPath];
                                                                                                      [self.myImageView setImage:fullImage];
                                                                                                     // _fullPicblock((int)msg.msgContent);
                                                                                                      
                                                                                                      //关闭模版
                                                                                                      [MBProgressHUD hideHUD];
                                                                                                      gChatDb * gchat  = [[gChatDb alloc]init];
                                                                                                      [gchat createTableWithGroupId:_chatId];
                                                                                                      [gchat updatewihtId:_messageId newContent:msg.msgContent newFinishFlag:YES];

                                                                                                  }failure:^(NSString *error) {
                                                                                                      NSLog(@"修改失败");
                                                                                                   //   [MBProgressHUD hideHUD];

                                                                                                      [MBProgressHUD showError:@"加载失败"];
                                                                                                      [MBProgressHUD hideHUD];
                                                                                                      
                                                                                                      
                                                                                                  }];
                                                         
                                                         
                                                                                                              }
                                                 
                                                 

        
        }
        


    
    
    
    
  
    
  //  [self.myImageView setImageWithURL:self.imageURL];
   
}
- (void)PinchGesture:(id)sender
{
    UIPinchGestureRecognizer *gesture = sender;
    NSLog(@"fdsfsfsdfsfdsfdsfd");
    //手势改变时
    if (gesture.state == UIGestureRecognizerStateChanged)
    {  // CGFloat currentScale = self.myImageView.image.size.width / _image.size.width;
        //捏合手势中scale属性记录的缩放比例
        self.myImageView.transform = CGAffineTransformMakeScale(gesture.scale, gesture.scale);
    }
    
    
//    //结束后恢复
    if(gesture.state==UIGestureRecognizerStateEnded)
    {
       [UIView animateWithDuration:0.5 animations:^{
           self.myImageView.transform = CGAffineTransformIdentity;//取消一切形变
        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated{
    
    // self.hidesBottomBarWhenPushed=YES;
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:YES];
    //   view.frame=CGRectMake(0, 480, 0, 0);
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:NO];
}



-(void) setfullPicBlock:(fullPicBlock)block
{
    _fullPicblock = block;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
