//
//  VerifyViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/8.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "VerifyViewController.h"
#import "MBProgressHUD+NJ.h"
#import "ContactModule.h"


@interface VerifyViewController ()
- (IBAction)sendReq:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *myMessage;

@end

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)sendReq:(id)sender {
    //发送添加好友的请求，成功则返回上一级界面
    //_myMessage.text
    
    if(_myMessage.text.length >30) {
        [MBProgressHUD showError:@"信息太长"];
        return;
        
    }
    [MBProgressHUD showMessage:@"正在拼命加载ing...."];      
    
    [[ContactModule instance]addContact:_userId text:_myMessage.text success:^(){
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"请求发送成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(){
        [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"请求发送失败!"];
    }];
    
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    // self.hidesBottomBarWhenPushed=YES;
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:YES];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    
    // self.searchController.active = YES;
    //   view.frame=CGRectMake(0, 480, 0, 0);
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:NO];
    
    
    
    // self.navigationController.navigationBarHidden = YES;
}



@end
