//
//  ViewController.m
//  login
//
//  Created by 追风 on 16/6/22.
//  Copyright © 2016年 im. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+NJ.h"
#import "LoginModule.h"
#import "Person.h"
#import "MessageModule.h"
#import "GetUserInfoAPI.h"
#import "ContactModule.h"
#import "NewFriendDb.h"
#import "HfDbModel.h"
#import "ImdbModel.h"


@interface ViewController ()<UITextFieldDelegate>
- (IBAction)login:(id)sender;
- (void)createFolderWithname:(NSString *)userName;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 在输入框左侧加入提示图片
    UIImageView *accountLeftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"账号.png"]];
    self.accountText.leftView = accountLeftImage;
    self.accountText.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *passwordLeftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"密码.png"]];
    self.passWordText.leftView = passwordLeftImage;
    self.passWordText.leftViewMode = UITextFieldViewModeAlways;
    
    //  监听 accountText 和 passWordText 输入框
    self.accountText.delegate = self;
    self.passWordText.delegate = self;
    // 注册 UITextFieldTextDidChangeNotification 通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged0) name:UITextFieldTextDidChangeNotification object:self.accountText];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:self.passWordText];
    
    
    //导入视频到相册
  
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Miniature" ofType:@"mp4"];
    if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path))
    {
        UISaveVideoAtPathToSavedPhotosAlbum(path,nil,nil,nil);
    }
    
   
}
#define MAX_ACCOUNT_LENGTH 20  // 用户名最大长度
#define MIN_ACCOUNT_LENGTH 4   // 用户名最小长度
#define MAX_PASSWORD_LENGTH 16 // 密码最大长度
#define MIN_PASSWORD_LENGTH 6  // 密码最小长度


- (void)textChanged0
{
    self.loginButton.enabled = (self.accountText.text.length >= MIN_ACCOUNT_LENGTH && self.passWordText.text.length >= MIN_PASSWORD_LENGTH);
    
    // 1.获得Documents的全路径    //根据上述的用户名，读取用户名.data中的数据
    NSString *filename = [NSString stringWithFormat:@"%@.data",_accountText.text];  //用户名.data
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:filename]; //扩展名可以自己定义
    
    // 3.从文件中读取MJStudent对象，将nsdata转成对象
    Person *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (nil == user.headerImage) {
        _icon.image = [UIImage imageNamed:@"tn.9.png"];
    } else {
        _icon.image = user.headerImage;
    }

    
    
}



- (void)textChanged
{
    self.loginButton.enabled = (self.accountText.text.length >= MIN_ACCOUNT_LENGTH && self.passWordText.text.length >= MIN_PASSWORD_LENGTH);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    // 判断输入框字符长度，决定“登录”按钮是否可用
    // 问题：达到最小长度后“登录”按钮可用，但是删掉1~2个字符 仍然可用
    // self.loginButton.enabled = (self.accountText.text.length > (MIN_ACCOUNT_LENGTH) && self.passWordText.text.length > (MIN_PASSWORD_LENGTH));
    // 防止溢出
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSInteger newLength = [textField.text length] + [string length] - range.length;
    // tag == 20 对应用户名输入框
    // tag == 16 对应密码输入框
    // 限制输入框的最大字符数(此方法仅适用于英文，一般符号，不可用于中文，emoji表情等)
    if([textField tag] == 20)
    {
        return newLength <= MAX_ACCOUNT_LENGTH;
    }else{
        return newLength <= MAX_PASSWORD_LENGTH;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rememberPasswordChange:(id)sender {
    // 判断是否记住密码
    // 如果取消记住密码，自动取消自动登录
    if(!self.rememberPasswordSwitch.isOn)
    {
        [self.autoLoginSwitch setOn:NO animated:YES];
    }
}

- (IBAction)autoLoginChange:(id)sender {
    // 判断是否自动登录
    // 如果自动登录就记住密码
    if(self.autoLoginSwitch.isOn)
    {
        [self.rememberPasswordSwitch setOn:YES animated:YES];
    }
}

- (IBAction)accountText_DidEndOnExit:(id)sender {
    // 将焦点移至 密码输入框
    [self.passWordText becomeFirstResponder];
}

- (IBAction)passwordText_DidEndOnExit:(id)sender {
    // 隐藏键盘
    [sender resignFirstResponder];
    
    // 触发 登录 按钮的点击事件
    [self.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}
// 点击背景隐藏键盘
- (IBAction)View_TouchDown:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
//登录按键
- (IBAction)login:(id)sender {
    
    //    NSLog(@"loginOnClick");
    
    [self.view endEditing:YES];    
    // 添加蒙版禁止用户操作, 并且提示用户正在登录
    [MBProgressHUD showMessage:@"正在拼命加载ing...."];
    
    //延迟一秒执行
  
        
    Person *nowUser = [[Person alloc]init];
        
    nowUser.userName = _accountText.text;

   [[LoginModule instance] loginWithUsername:_accountText.text password:_passWordText.text success:^(NSNumber* response){
            NSLog(@"main登录成功！");
             [MBProgressHUD hideHUD];
      
       nowUser.userId = response;
       NSLog(@"用户ID:%ld",(long)response);
       nowUser.userName = _accountText.text;

       
       
       //登录成功后查询自己的信息
       [[ContactModule instance]GetUserInfo:[nowUser.userId intValue] success:^(IMUserEntity *user){   //搜索网络，获取当前的联系人资料
           
           
           nowUser.userName = user.name;
           
           nowUser.name =  user.nick;
           
           UIImage * avatar = user.avatar;
           if (nil == user.avatar) {
               avatar = [UIImage imageNamed:@"tn.9.png"];
           }
           
           nowUser.headerImage = avatar;
           
           
           // 2.归档模型对象
           // 2.1.获得Documents的全路径
           NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                   
           // 1.获得Documents的全路径
           NSString *filename = [NSString stringWithFormat:@"%@.data",nowUser.userName];//用户名.data
        // 2.获得文件的全路径
           NSString *path1 = [doc stringByAppendingPathComponent:filename];
           [NSKeyedArchiver archiveRootObject:nowUser toFile:path1];

           
       
           HfDbModel* hfDbModel1 = [[HfDbModel alloc] init];
           
            [hfDbModel1 createTable];
           
           
           ImdbModel* imdbModel = [[ImdbModel alloc] init];
               
           [imdbModel createTable];
        
       } failure:^(NSString* error){
           
       }];
       
       
       
       // 2.归档模型对象
       // 2.1.获得Documents的全路径
       NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
       // 2.2.获得文件的全路径
       NSString *path = [doc stringByAppendingPathComponent:@"nowUser.data"];
       // 2.3.将对象归档   //将person类型变为NSData类型,放入内存
       //     Person *user = [[Person alloc]init];
       
       //   user.userName = _accountText.text;
       
       [NSKeyedArchiver archiveRootObject:nowUser toFile:path];
       
       

       
       
       [self performSegueWithIdentifier:@"login2contatc" sender:nil];
       [self createFolderWithname:_accountText.text];

       //获取离线消息
       
       [[MessageModule instance] getOfflineMessageSuccess:^{
           
       } failure:^{
           
       }];
       
       
        } failure:^(NSString* error){
            NSLog(@"main登录失败！");
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:error];
          //  [self performSegueWithIdentifier:@"login2contatc" sender:nil];
        }];
  
   //   [self performSegueWithIdentifier:@"login2contatc" sender:nil];
        /*
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        // 2.2.获得文件的全路径
        NSString *path = [doc stringByAppendingPathComponent:@"nowUser.data"];
        // 2.3.将对象归档   //将person类型变为NSData类型,放入内存
   //     Person *user = [[Person alloc]init];
        
     //   user.userName = _accountText.text;
        
        [NSKeyedArchiver archiveRootObject:nowUser toFile:path];
         [self performSegueWithIdentifier:@"login2contatc" sender:nil];
        
     // 1.判断账号密码是否正确(lnj/123)
         if ([self.accountField.text isEqualToString:@"lnj"] &&
         [self.pwdField.text isEqualToString:@"123"]) {
         // 2.如果正如,跳转到联系人界面(手动执行segue)
         [self performSegueWithIdentifier:@"login2contatc" sender:nil];
         
         // 3.登录成功后移除蒙版
         [MBProgressHUD hideHUD];
         }else
         {
         
         // 提示用户用户名或者密码不正确
         //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或者密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
         //            [alert show];
         
         
         // [MBProgressHUD showError:@"用户名或者密码不正确!!!"];
         }
         */
    //    passWordText.text        accountText.text
        
   
        
              /* [[LoginModule instance] loginWithUsername: _accountText.text password:_passWordText.text success:^(IMUserEntity* user){
            NSLog(@"main登录成功！");
             [MBProgressHUD hideHUD];
             
             // 3.登录成功后移除蒙版
             [MBProgressHUD hideHUD];
             // 2.如果正如,跳转到联系人界面(手动执行segue)
           //  [self performSegueWithIdentifier:@"login2contatc" sender:nil];
             
        } failure:^(NSString* error){
            NSLog(@"main登录失败！");
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"登录失败!"];
        }];
       */ 
   /*       if (![self.accountField.text isEqualToString:@"lnj"]) {
            // 3.登录成功后移除蒙版
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"用户名不正确!!!"];
            return;
        }
        
        if (![self.pwdField.text isEqualToString:@"123"]) {
            // 3.登录成功后移除蒙版
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"密码不正确!!!"];
            return;
        }
        
        // 3.登录成功后移除蒙版
        [MBProgressHUD hideHUD];
        // 2.如果正如,跳转到联系人界面(手动执行segue)
        [self performSegueWithIdentifier:@"login2contatc" sender:nil];  */
        
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   // NSLog(@"%@ %@ %@",segue.identifier, segue.sourceViewController, segue.destinationViewController);
   
    // 1.拿到目标控制器
  //  UIViewController *vc =  segue.destinationViewController;
    // 2.设置目标控制器的标题
    //    vc.navigationItem.title = [NSString stringWithFormat:@"%@ 的联系人列表", self.accountField.text];
    
    //     vc.title  == vc.navigationItem.title
   // vc.title = [NSString stringWithFormat:@"%@ 的联系人列表", self.accountField.text];
}


//创建用户文件夹，用来存放聊天记录中的语音，图片，文件，视频等消息
- (void)createFolderWithname:(NSString *)userName
{
    
    
    
 NSString *docPath = [self getCachesPath];
 NSString *testPath = [docPath stringByAppendingPathComponent:userName];
 NSFileManager *manage = [NSFileManager defaultManager];
 // withIntermediateDirectories :bool值,检测路径下是否存在改文件夹 YES:可以覆盖 NO:不可覆盖
 BOOL ret = [manage createDirectoryAtPath:testPath withIntermediateDirectories:NO attributes:nil error:nil];
 if(ret){
     
     NSString *imagePath = [testPath stringByAppendingPathComponent:@"Image"];
     
     BOOL ret1 = [manage createDirectoryAtPath:imagePath withIntermediateDirectories:NO attributes:nil error:nil];
     if(ret1){
         
         NSLog(@"图片文件夹创建成功");
     }else{
         NSLog(@"图片文件夹创建失败");
         
     }
     
     NSString *voicePath = [testPath stringByAppendingPathComponent:@"Voice"];
     
     BOOL ret2 = [manage createDirectoryAtPath:voicePath withIntermediateDirectories:NO attributes:nil error:nil];
     if(ret2){
         
         NSLog(@"语音文件夹创建成功");
     }else{
         NSLog(@"语音文件夹创建失败");
         
     }
     
     NSString *videoPath = [testPath stringByAppendingPathComponent:@"Video"];
     
     BOOL ret3 = [manage createDirectoryAtPath:videoPath withIntermediateDirectories:NO attributes:nil error:nil];
     if(ret3){
         
         NSLog(@"视频文件夹创建成功");
     }else{
         NSLog(@"视频文件夹创建失败");
         
     }
     
     NSString *filePath = [testPath stringByAppendingPathComponent:@"File"];
     BOOL ret4 = [manage createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
     if(ret4){
         
         NSLog(@"文档文件夹创建成功");
     }else{
         NSLog(@"文档文件夹创建失败");
         
     }
     
     NSLog(@"文件夹创建成功");
 }else{
    NSLog(@"文件夹创建失败");

}
    
    
    
}

//获取Caches目录路径的方法
- (NSString *)getCachesPath
{
     // 检索指定路径
     // 第一个参数制定了搜索的路径名称
     // 第二个参数限定了在沙盒内部
     NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
     NSString *CachesPath = [docPaths lastObject];
     NSLog(@"CachesPath = %@",CachesPath);
     return CachesPath;
}

@end
