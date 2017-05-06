//
//  ReVeriController.m
//  ios约束版
//
//  Created by tongho on 16/8/8.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "ReVeriController.h"
#import "MBProgressHUD+NJ.h"
#import "ContactModule.h"

@interface ReVeriController ()
@property (weak, nonatomic) IBOutlet UITextField *myMessage;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *remarkName;
@property (weak, nonatomic) IBOutlet UILabel *userName;

- (IBAction)sendMess:(id)sender;

@end

@implementation ReVeriController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _icon.image = [UIImage imageWithData:_icon1];
    _remarkName.text = _remarkName1;
    _userName.text = _userName1;
    
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (IBAction)sendMess:(id)sender {            //发送再次验证请求
    
    //_myMessage.text
    
    if(_myMessage.text.length >30) {
        [MBProgressHUD showError:@"信息太长"];
        return;
        
    }
    
    [MBProgressHUD showMessage:@"正在拼命加载..."];
    
    [[ContactModule instance]  replyRequest:_userId
                                  replyCode:1
                                       text:_myMessage.text
                                    success:^(){
                                        [MBProgressHUD hideHUD];
                                        [MBProgressHUD showSuccess:@"发送成功"];
                                        [self.navigationController popViewControllerAnimated:YES];//成功后返回上级界面
                                        
                                    }failure:^(){
                                        [MBProgressHUD hideHUD];
                                        [MBProgressHUD showError:@"发送失败"];
                                    }];
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    // self.hidesBottomBarWhenPushed=YES;
    
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
    
    // self.navigationController.navigationBarHidden = YES;
}




@end
