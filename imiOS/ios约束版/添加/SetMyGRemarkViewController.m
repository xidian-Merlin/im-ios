//
//  SetMyGRemarkViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/29.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "SetMyGRemarkViewController.h"
#import "MBProgressHUD+NJ.h"
#import "Person.h"
#import "GroupModule.h"
#import "GroupMemeberDb.h"

@interface SetMyGRemarkViewController ()
@property (weak, nonatomic) IBOutlet UITextField *reMarkname;
- (IBAction)submit:(id)sender;

@end

@implementation SetMyGRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _reMarkname.text = _myOldRemarkName;
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

- (IBAction)submit:(id)sender {
    
    if (2 > _reMarkname.text.length) {
        [MBProgressHUD showError:@"群名称太短!"];
        return;
    }
    if (10 < _reMarkname.text.length) {
        [MBProgressHUD showError:@"群名称太长!"];
        return;
    }
    if ([_reMarkname.text isEqualToString:_myOldRemarkName]) {
        [MBProgressHUD showError:@"请先修改个人备注"];
        return;
    }
    [MBProgressHUD showMessage:@"正在拼命加载ing...."];
    
    // 1.获得Documents的全路径
    NSString *nowDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *nowPath = [nowDoc stringByAppendingPathComponent:@"nowUser.data"]; //扩展名可以自己定义
    
    // 3.从文件中读取MJStudent对象，将nsdata转成对象
    Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];
    
    [[GroupModule instance] changeMemberRemarkWithID:[nowUser.userId intValue] remark:_reMarkname.text success:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"修改成功"];
        //将新名字存入数据库
        GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
        [gmdb createTableWithGroupId:_groupId];
        [gmdb set:_reMarkname.text  withMemberId:[nowUser.userId intValue]];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSString *error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"修改失败"];
        
    }];


    
}
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
    
    
}
@end
