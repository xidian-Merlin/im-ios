//
//  VerificationViewController.m
//  ios约束版
//
//  Created by 文博黄 on 2016/12/12.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "VerificationViewController.h"
#import "RegisterModule.h"
#import "MBProgressHUD+NJ.h"
#import "ValidateOperate.h"

@interface VerificationViewController ()< UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UITextField *verification;


- (IBAction)uploadVerification:(id)sender;

@end

@implementation VerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _verification.delegate = self;
    self.alertLabel.hidden = TRUE;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}





/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)hiddenwarning:(id)sender {
    self.alertLabel.hidden = TRUE;
}

- (IBAction)uploadVerification:(id)sender {
    NSLog(@"我要提交验证码");
    
    if (![ValidateOperate validateVerification:_verification.text]) {
        self.alertLabel.hidden = FALSE;
        return;
    }
    
    self.alertLabel.hidden = TRUE;
    
    //如果上述都正确，再向服务器发送请求
    [MBProgressHUD showMessage:@"正在拼命加载..."];
    
    [[RegisterModule instance] registerWithUsername:self.my_name nick:self.my_nick password:self.my_password avatar:self.my_avatar phone:self.my_phone email:self.my_email verification:_verification.text
                                            success:^(){
                                                NSLog(@"hwb:注册成功！");
                                                [MBProgressHUD hideHUD];
                                                [MBProgressHUD showSuccess:@"注册成功"];
                                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];
                                            }failure:^(NSString* error){
                                                NSLog(@"hwb:注册失败！");
                                                [MBProgressHUD hideHUD];
                                                NSLog(@"hwb:%@",error);
                                                
                                                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"注册失败" preferredStyle:UIAlertControllerStyleAlert];
                                                UIAlertAction* Left = [UIAlertAction actionWithTitle:@"再试一次" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                                                    return;
                                                }];
                                                
                                                UIAlertAction* Right = [UIAlertAction actionWithTitle:@"放弃注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];
                                                }];
                                                
                                                [alertController addAction:Left];
                                                [alertController addAction:Right];
                                                
                                                [self presentViewController:alertController animated:true completion:nil];
                                                
                                                
                                                [MBProgressHUD showError:@"注册失败"];
                                            }];
}
@end

