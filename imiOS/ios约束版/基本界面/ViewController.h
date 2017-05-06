//
//  ViewController.h
//  login
//
//  Created by 追风 on 16/6/22.
//  Copyright © 2016年 im. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
// 账号输入框
@property (weak, nonatomic) IBOutlet UITextField *accountText;
// 密码输入框
@property (weak, nonatomic) IBOutlet UITextField *passWordText;

// 点击“记住密码”
- (IBAction)rememberPasswordChange:(id)sender;
// 点击“自动登录”
- (IBAction)autoLoginChange:(id)sender;

- (IBAction)accountText_DidEndOnExit:(id)sender;
- (IBAction)passwordText_DidEndOnExit:(id)sender;
- (IBAction)View_TouchDown:(id)sender;

// 记住密码
@property (weak, nonatomic) IBOutlet UISwitch *rememberPasswordSwitch;
// 自动登录
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;
// 登录
@property (weak, nonatomic) IBOutlet UIButton *loginButton;



@end

