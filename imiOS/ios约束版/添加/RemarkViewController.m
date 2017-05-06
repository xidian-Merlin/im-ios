//
//  RemarkViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/12.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "RemarkViewController.h"
#import "ContactModule.h"
#import "MBProgressHUD+NJ.h"
#import "HfDbModel.h"
#import "ImdbModel.h"

@interface RemarkViewController ()
- (IBAction)remark:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *remarkName;

@end

@implementation RemarkViewController

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

- (IBAction)remark:(id)sender {
    
    // 修改好友备注
    
    if ([@"" isEqualToString: _remarkName.text]) {
        [MBProgressHUD showError:@"备注不能为空"];
        return;
    }
    if(_remarkName.text.length >15) {
        [MBProgressHUD showError:@"备注名太长"];
        return;
    
    }
    
    
    [MBProgressHUD showMessage:@"正在拼命加载ing...."];
    [[ContactModule instance] changeRemark:_userId remark:_remarkName.text success:^(){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"备注修改成功"];
        //将修改成功的备注名存入我的好友表  同时要更新会话表的备注名，通知会话表更新  //备注是用户自己定义的，只会在此处发生改变
        //更新我的好友列表
        ImdbModel *fldb = [[ImdbModel alloc]init];
        [fldb set:_remarkName.text withUserId:_userId];
        
        
        
        //更新会话表
        HfDbModel *hfdb = [[HfDbModel alloc]init];
        
        [hfdb set:_remarkName.text withUserId:_userId style:1];
        
        
        [self .navigationController popToRootViewControllerAnimated:YES];
        
        
    
    } failure:^(){
    [MBProgressHUD hideHUD];
      [MBProgressHUD showError:@"备注修改失败"];
    }];
    
    
    
}
@end
