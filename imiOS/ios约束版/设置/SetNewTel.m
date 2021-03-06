//
//  SetNewTel.m
//  ios约束版
//
//  Created by tongho on 16/12/2.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "SetNewTel.h"

#import "ValidateOperate.h"
#import "MBProgressHUD+NJ.h"
#import "ChangeBindingRequestAPI.h"
#import "ChangeBindingAPI.h"
#import "SettingModule.h"


@interface SetNewTel ()

@property (weak, nonatomic) IBOutlet UILabel *OldTle;

@property (weak, nonatomic) IBOutlet UITextField *NewTel;
@property (weak, nonatomic) IBOutlet UIButton *GetVerifyButton;

@property (weak, nonatomic) IBOutlet UITextField *VerifyCode;
- (IBAction)GetVerifyCode:(id)sender;
- (IBAction)SendMessage:(id)sender;


////
-(void)startTime;
@end

@implementation SetNewTel

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //读取持续化数据，得到当前的邮箱号
    _OldTle.text = _nowTel;
        
    //输入新邮箱，获取验证码
    
    
    
    //输入验证码，以及绑定信息，发送
    
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)GetVerifyCode:(id)sender {
    
    
    //发送获取验证码请求，
    char method ;
    if ([_nowMail isEqualToString:@"未设置"]) {
        //发送电话绑定
         method = 0x00;
    }
    else {
    
        //发送电话与邮箱绑定
         method = 0x11;
    }
    
    
    
    // 请求修改绑定信息 填写的验证码为字符串
    [[SettingModule instance] chagneBindingRequestWithMethod:method success:^{
        NSLog(@"请求成功");
    } failure:^(NSString *error) {
        NSLog(@"请求失败");
    }];

    //开始倒计时
    [self startTime];
    
    
    
    
}

- (IBAction)SendMessage:(id)sender {
    //判定是否是新手机号
    if ([_NewTel.text isEqualToString:_OldTle.text]) {
        [MBProgressHUD showError:@"请更改手机号"];
        return;
    }
    //判定新的手机号是否合法
    if (![ValidateOperate validateMobile:_NewTel.text]) {
        //_telError.hidden = NO;
        [MBProgressHUD showError:@"输入不合法"];
        return;
    }
    
    
    // 修改绑定信息
    [[SettingModule instance] changeBindingWithPhone:_NewTel.text email:_nowMail verification:_VerifyCode.text success:^{
        NSLog(@"修改成功");
        [self.navigationController popViewControllerAnimated:YES];
         [MBProgressHUD showSuccess:@"修改成功"];
        
    } failure:^(NSString *error) {
        NSLog(@"修改失败");
        [MBProgressHUD showError:@"修改失败"];
    }];
}



-(void)startTime{
    __block int timeout= 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_GetVerifyButton setTitle:@"重新发送验证码" forState:UIControlStateNormal];
                _GetVerifyButton.userInteractionEnabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_GetVerifyButton setTitle:[NSString stringWithFormat:@"%zd秒后重新发送",timeout] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _GetVerifyButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:YES];
    
    self.navigationController.navigationBarHidden = NO;
    //   view.frame=CGRectMake(0, 480, 0, 0);
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:NO];
    
    self.navigationController.navigationBarHidden = YES;
}



@end
