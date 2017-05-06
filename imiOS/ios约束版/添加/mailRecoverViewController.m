//
//  mailRecoverViewController.m
//  ios约束版
//
//  Created by 文博黄 on 2016/12/14.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "mailRecoverViewController.h"
#import "MBProgressHUD+NJ.h"
#import "RegisterModule.h"
#import "recoverPasswordViewController.h"
#import "ValidateOperate.h"


@interface mailRecoverViewController ()< UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *mail;

@property (weak, nonatomic) IBOutlet UILabel *userNameErr;
@property (weak, nonatomic) IBOutlet UILabel *mailErr;



@end

@implementation mailRecoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _username.delegate = self;
    _mail.delegate = self;
    _userNameErr.hidden = YES;
    _mailErr.hidden = YES;
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
- (IBAction)getVerification:(id)sender {
    
    //对用户名做出判断   仅为数字与字母，6到20字
    _userNameErr.hidden = YES;
    if (![ValidateOperate validateUserName:_username.text]) {
        _userNameErr.hidden = NO;  //显示错误
        return;
    }
    
    _mailErr.hidden = YES;
    if (![ValidateOperate validateEmail:_mail.text]) {
        _mailErr.hidden = NO;
        return;
    }

    
    //如果上述都正确，再向服务器发送请求，
    
    [MBProgressHUD showMessage:@"正在拼命加载..."];
    
    
    [[RegisterModule instance]getVerificationWithUsername:_username.text method:1 account:_mail.text
                                                  success:^(){
                                                      NSLog(@"hwb:获取验证码成功！！！");
                                                      [MBProgressHUD hideHUD];
                                                      //若申请验证码成功，则跳转到输入验证码


                                                      NSLog(@"该跳转到验证码输入区");
                                                      
                                                      UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
                                                      recoverPasswordViewController* testobj = [MainStoryboard instantiateViewControllerWithIdentifier:@"recoverPassword"];
                                                      testobj.my_name = _username.text;
                                                      testobj.my_email = _mail.text;
                                                      
                                                      [self.navigationController pushViewController:testobj animated:YES];
                                                      
                                                      
                                                      [MBProgressHUD showSuccess:@"获取验证码成功"];
                                                  } failure:^(NSString *error){
                                                      [MBProgressHUD hideHUD];
                                                      NSLog(@"hwb:%@",error);
                                                      [MBProgressHUD showError:error];
                                                      
                                                      UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"获取验证码失败" preferredStyle:UIAlertControllerStyleAlert];
                                                      UIAlertAction* Left = [UIAlertAction actionWithTitle:@"再试一次" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                                                          return;
                                                      }];
                                                      
                                                      UIAlertAction* Right = [UIAlertAction actionWithTitle:@"放弃注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                                          [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];
                                                      }];
                                                      
                                                      [alertController addAction:Left];
                                                      [alertController addAction:Right];
                                                      
                                                      [self presentViewController:alertController animated:true completion:nil];
                                                  }];
}

@end
