//
//  RegistController.m
//  ios约束版
//
//  Created by tongho on 16/8/21.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "RegistController.h"
#import "ValidateOperate.h"
#import "MBProgressHUD+NJ.h"
#import "Person.h"
#import "RegisterModule.h"
#import "VerificationViewController.h"
#import "PrivacyProvisionsController.h"

@interface RegistController () < UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *registbutton;

@property (weak, nonatomic) IBOutlet UIImageView *userNameError;

@property (weak, nonatomic) IBOutlet UIImageView *nickNameError;

@property (weak, nonatomic) IBOutlet UIImageView *passError;

@property (weak, nonatomic) IBOutlet UIImageView *telError;

@property (weak, nonatomic) IBOutlet UIImageView *mailError;

@property (weak, nonatomic) IBOutlet UIImageView *iconError;




@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *telNumber;

@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UITextField *mail;
@property (weak, nonatomic) IBOutlet UIButton *privacycheck;

//@property BOOL registModel;//注获取验证码方式：0:手机；1:邮箱

- (IBAction)regist:(id)sender;

@end

@implementation RegistController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置cell不可以被选中
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled =YES; //设置tableview 能滚动
    self.tableView.contentInset = UIEdgeInsetsMake(0,0,450,0);
    
    _mail.delegate = self;
    _passWord.delegate  =self;
    _passWord.secureTextEntry = YES;
    _userName.delegate = self;
    _nickName.delegate  =self;
    _telNumber.delegate = self;
    
    [self.telNumber addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    
    [_privacycheck setImage:[UIImage imageNamed:@"checkout.png"]forState:UIControlStateNormal];
    [_privacycheck setImage:[UIImage imageNamed:@"checkin.png"] forState:UIControlStateSelected];
    
    _registbutton.enabled = NO;

}

-(void)textFieldDidChange:(id)sender {
    //提取数字
    NSMutableString *result =(NSMutableString *) [[_telNumber.text componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    
    //比较数字的个数
    
    if (3 == result.length ) {
        _telNumber.text = result;
    }
    if (4 == result.length) {
        [result insertString:@"  " atIndex:3];
        _telNumber.text = result;
    }
    if (7 == result.length) {
        [result insertString:@"  " atIndex:3];
        _telNumber.text = result;
    }
    
    if (8 == result.length) {
        [result insertString:@"  " atIndex:3];
        [result insertString:@"  " atIndex:9];
        _telNumber.text = result;
    }
    
    if (11 == result.length) {
        [result insertString:@"  " atIndex:3];
        [result insertString:@"  " atIndex:9];
        _telNumber.text = result;
    }
    
    if (11 < result.length) {
        _telNumber.text = result;
    }
    
 //   NSLog(@"%@", result);



}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source








- (IBAction)setIcon {
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    const NSString *ImageIdentifier = @"UIImagePickerControllerEditedImage";
    UIImage *image = info[ImageIdentifier];
    
        [_icon setBackgroundImage:image forState:UIControlStateNormal];
        [picker dismissViewControllerAnimated:YES completion:nil];
    
}
//点击return 按钮 去掉
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


-(void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBarHidden = NO;

}
-(void)viewWillDisappear:(BOOL)animated {

   self.navigationController.navigationBarHidden = YES;
}


/*- (IBAction)chooseModel:(id)sender {
    UISegmentedControl* segmentedControl = (UISegmentedControl*)sender;
    _registModel = segmentedControl.selectedSegmentIndex;
}
 */

- (IBAction)regist:(id)sender {
    NSLog(@"我要提交");
    
    //先对输入框内容做出判断，若输入不对，直接返回，显示错误；
    
    //对头像做出判断
    NSData *imgData;
    imgData = UIImageJPEGRepresentation(_icon.currentBackgroundImage, 0.5);

         _iconError.hidden = YES;
    if (imgData.length > 1024*1024) {   //图片大于1M
        _iconError.hidden = NO;  //显示错误
        return ;
    }
    if (_icon.currentBackgroundImage == nil) {   //图片为空
        _iconError.hidden = NO;  //显示错误
        return ;
    }

    
    //对用户名做出判断   仅为数字与字母，6到20字
    _userNameError.hidden = YES;
     if (![ValidateOperate validateUserName:_userName.text]) {
        _userNameError.hidden = NO;  //显示错误
        return;
    }
    
   

    
    //对昵称做出判断
    
    _nickNameError.hidden = YES;
    if (![ValidateOperate validateNickname:_nickName.text]) {
        _nickNameError.hidden = NO;
        return;
    }
    
    
    //对密码做出判断   仅为数字与字母，6到20字
    _passError.hidden = YES;
    if(![ValidateOperate validatePassword:_passWord.text]) {
        _passError.hidden = NO;  //显示错误
        return;
    }
    //对手机号做出判断
    
    _telError.hidden = YES;
    //提取数字
    NSMutableString *result =(NSMutableString *) [[_telNumber.text componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    if (![ValidateOperate validateMobile:result]) {
        _telError.hidden = NO;
        return;
    }
    
    //对邮箱做出判断
    
    _mailError.hidden = YES;
    if (![ValidateOperate validateEmail:_mail.text]) {
        _mailError.hidden = NO;
        return;
    }

    
    //如果上述都正确，再向服务器发送请求，
    
    [MBProgressHUD showMessage:@"正在拼命加载..."];
    
    
    [[RegisterModule instance]getVerificationWithUsername:_userName.text method:1 account:_mail.text
        success:^(){
            NSLog(@"hwb:获取验证码成功！！！");
            [MBProgressHUD hideHUD];
            //若申请验证码成功，则跳转到输入验证码
            Person *user = [[Person alloc]init];
            
            user.name = _nickName.text;
            user.headerImage = _icon.currentBackgroundImage;
            user.mail = _mail.text;
            user.tel = _telNumber.text;
            
            //将数据保存
            NSString *filename = [NSString stringWithFormat:@"%@.data",_userName.text];  //用户名.data
            
            // 2.归档模型对象
            // 2.1.获得Documents的全路径
            NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            // 2.2.获得文件的全路径
            NSString *path = [doc stringByAppendingPathComponent:filename];
            // 2.3.将对象归档   //将person类型变为NSData类型,放入内存
            
            
            [NSKeyedArchiver archiveRootObject:user toFile:path];
            
            NSLog(@"该跳转到验证码输入区");
            
            UIStoryboard *StoryboardStoryboard = [UIStoryboard storyboardWithName:@"Storyboard"bundle:nil];
            VerificationViewController* testobj = [StoryboardStoryboard instantiateViewControllerWithIdentifier:@"VerificationViewController"];
            testobj.my_name = _userName.text;
            testobj.my_nick = _nickName.text;
            testobj.my_email = _mail.text;
            //testobj.my_phone = _telNumber.text;
            testobj.my_phone= [_telNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            testobj.my_avatar = _icon.currentBackgroundImage;//?
            testobj.my_password = _passWord.text;
            
            [self.navigationController pushViewController:testobj animated:YES];

            
            [MBProgressHUD showSuccess:@"获取验证码成功"];
        } failure:^(NSString *error){
            [MBProgressHUD hideHUD];
            NSLog(@"hwb:%@",error);
            [MBProgressHUD showError:@"获取验证码失败"];
            
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

- (IBAction)click:(id)sender {
    _privacycheck.selected = !_privacycheck.selected;
    if (_privacycheck.selected==YES) {
        _registbutton.enabled = YES;
    } else {
        _registbutton.enabled = NO;
    }
}
- (IBAction)privacyshow:(id)sender {
    UIStoryboard *StoryboardStoryboard = [UIStoryboard storyboardWithName:@"Storyboard"bundle:nil];
    PrivacyProvisionsController* testobj = [StoryboardStoryboard instantiateViewControllerWithIdentifier:@"PrivacyProvisions"];
    [self.navigationController pushViewController:testobj animated:YES];
}


@end
