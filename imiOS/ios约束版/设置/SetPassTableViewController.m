//
//  SetPassTableViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/4.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "SetPassTableViewController.h"
#import "Person.h"
#import "MBProgressHUD+NJ.h"
#import "ResetPasswordAPI.h"
#import "SettingModule.h"


@interface SetPassTableViewController ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;


@property (weak, nonatomic) IBOutlet UITextField *passWord;


@property (weak, nonatomic) IBOutlet UITextField *rePassWord;
- (IBAction)endSetting:(id)sender;

@end

@implementation SetPassTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.获得Documents的全路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:@"nowUser.data"]; //扩展名可以自己定义
    
    // 3.从文件中读取MJStudent对象，将nsdata转成对象
    Person *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    _userName.text = user.userName;
      

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}



- (IBAction)endSetting:(id)sender {
    
    
    NSLog(@"grsg");
    if ([_passWord.text isEqualToString:_rePassWord.text] && nil != _passWord.text && nil !=_oldPassWord.text) {
        
         [MBProgressHUD showMessage:@"正在拼命加载ing...."];
        // 修改密码测试 
        [[SettingModule instance] resetPasswordWithUsername: _userName.text oldPassword:_oldPassWord.text newPassword:_rePassWord.text success:^(){
            
        [MBProgressHUD showError:@"修改密码成功!"];
            NSLog(@"密码修改成功！");
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } failure:^(NSString* error){
            
             [MBProgressHUD showError:@"修改密码失败!"];
            NSLog(@"密码修改失败！");
        }];
        
        
    }
    else {
        if (nil != _passWord.text || nil !=_oldPassWord.text) {
            [MBProgressHUD showError:@"请完善信息"];
            return;
        }
         [MBProgressHUD showError:@"两次输入的新密码不同"];
          NSLog(@"两次输入的新密码不同");
    
    
    }
    
    
    
    
    
    
}
@end
