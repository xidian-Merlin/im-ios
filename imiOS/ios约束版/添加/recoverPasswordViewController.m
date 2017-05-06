//
//  recoverPasswordViewController.m
//  ios约束版
//
//  Created by 文博黄 on 2016/12/14.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "recoverPasswordViewController.h"
#import "MBProgressHUD+NJ.h"
#import "RegisterModule.h"
#import "ValidateOperate.h"

@interface recoverPasswordViewController ()< UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *verification;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UILabel *verificationErr;
@property (weak, nonatomic) IBOutlet UILabel *passWordErr;
@property (weak, nonatomic) IBOutlet UILabel *phoneErr;

@property (strong, nonatomic) NSString* relphone;

@end

@implementation recoverPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _verification.delegate = self;
    _password.delegate = self;
    _phone.delegate = self;
    [self.phone addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    _passWordErr.hidden = YES;
    _phoneErr.hidden = YES;
    _verificationErr.hidden = YES;
    
}

-(void)textFieldDidChange:(id)sender {
    //提取数字
    NSMutableString *result =(NSMutableString *) [[_phone.text componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    
    //比较数字的个数
    
    if (3 == result.length ) {
        _phone.text = result;
    }
    if (4 == result.length) {
        [result insertString:@"  " atIndex:3];
        _phone.text = result;
    }
    if (7 == result.length) {
        [result insertString:@"  " atIndex:3];
        _phone.text = result;
    }
    
    if (8 == result.length) {
        [result insertString:@"  " atIndex:3];
        [result insertString:@"  " atIndex:9];
        _phone.text = result;
    }
    
    if (11 == result.length) {
        [result insertString:@"  " atIndex:3];
        [result insertString:@"  " atIndex:9];
        _phone.text = result;
    }
    
    if (11 < result.length) {
        _phone.text = result;
    }
    
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
- (IBAction)recoverPassword:(id)sender {
    
    //对密码做出判断   仅为数字与字母，6到20字
    _passWordErr.hidden = YES;
    if(![ValidateOperate validatePassword:_password.text]) {
        _passWordErr.hidden = NO;  //显示错误
        return;
    }
    //对手机号做出判断
    
    _phoneErr.hidden = YES;
    //提取数字
    NSMutableString *result =(NSMutableString *) [[_phone.text componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    if (![ValidateOperate validateMobile:result]) {
        _phoneErr.hidden = NO;
        return;
    }
    
    _relphone = [_phone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //验证码的判断
    _verificationErr.hidden = YES;
    if (![ValidateOperate validateVerification:_verification.text]) {
        _verificationErr.hidden = NO;
        return;
    }
    

    //如果上述都正确，再向服务器发送请求
    [MBProgressHUD showMessage:@"正在拼命加载..."];
    
    [[RegisterModule instance] setNewPasswordWithUserName:self.my_name newPassword:_password.text phone:_relphone email:self.my_email verification:_verification.text
                                            success:^(){
                                                NSLog(@"hwb:密码重置成功！");
                                                [MBProgressHUD hideHUD];
                                                [MBProgressHUD showSuccess:@"密码重置成功"];
                                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];
                                            }failure:^(NSString* error){
                                                NSLog(@"hwb:密码重置失败！");
                                                [MBProgressHUD hideHUD];
                                                NSLog(@"hwb:%@",error);
                                                
                                                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"密码重置失败" preferredStyle:UIAlertControllerStyleAlert];
                                                UIAlertAction* Left = [UIAlertAction actionWithTitle:@"再试一次" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                                                    return;
                                                }];
                                                
                                                UIAlertAction* Right = [UIAlertAction actionWithTitle:@"放弃重置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];
                                                }];
                                                
                                                [alertController addAction:Left];
                                                [alertController addAction:Right];
                                                
                                                [self presentViewController:alertController animated:true completion:nil];
                                                
                                                
                                                [MBProgressHUD showError:@"密码重置失败"];
                                            }];
}

@end
