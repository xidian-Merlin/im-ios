//
//  setPasswordViewController.m
//  login
//
//  Created by 追风 on 16/7/8.
//  Copyright © 2016年 im. All rights reserved.
//

#import "setPasswordViewController.h"
#import "MBProgressHUD+NJ.h"
#import "RegisterModule.h"

@interface setPasswordViewController ()

@end

@implementation setPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 判断密码是否符合格式

// 判断两次密码是否相同,若两次密码不同，则确认键不可用


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 点击确认回到根视图
- (IBAction)jumpToRootView:(id)sender {
    
    [MBProgressHUD showMessage:@"正在拼命加载ing...."];
    
    //延迟一秒执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        
        
        // 存在账号：Lenon ,helloworld   whoami，xidian
        // 注册测试
        //  NSString* userName = @"whoami";
        //   NSString* password = @"xidian";
//        [[RegisterModule instance] registerWithUsername:_firstPasswordText.text password:_secondPasswordText.text success:^(){
//            NSLog(@"main登录成功！");
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showSuccess:@"注册成功，请登录!"];
//           [self.navigationController popToRootViewControllerAnimated:YES];
//            
//            
//        } failure:^(NSString* error){
//            NSLog(@"main登录失败！");
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showError:@"注册失败!"];
//        }];
        
    });
    
    
    
    
    
    
}
@end
