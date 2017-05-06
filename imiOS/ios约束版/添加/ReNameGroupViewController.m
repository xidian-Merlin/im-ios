//
//  ReNameGroupViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/29.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "ReNameGroupViewController.h"
#import "MBProgressHUD+NJ.h"
#import "GroupModule.h"
#import "Person.h"
#import "MyGroupDB.h"

@interface ReNameGroupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *groupName;
- (IBAction)submit:(id)sender;


@end

@implementation ReNameGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _groupName.text = _myOldGroupName;
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
    
    
    if (2 > _groupName.text.length) {
        [MBProgressHUD showError:@"群名称太短!"];
        return;
    }
    if (10 < _groupName.text.length) {
        [MBProgressHUD showError:@"群名称太长!"];
        return;
    }
    if ([_groupName.text isEqualToString:_myOldGroupName]) {
        [MBProgressHUD showError:@"请先修改群名称"];
        return;
    }
    
    
    [MBProgressHUD showMessage:@"正在拼命加载ing...."];
    
    // 1.获得Documents的全路径
    NSString *nowDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *nowPath = [nowDoc stringByAppendingPathComponent:@"nowUser.data"]; //扩展名可以自己定义
    
    // 3.从文件中读取MJStudent对象，将nsdata转成对象
    Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];

    
    [[GroupModule instance] changeGroupNameWithGroupID:_groupId userID:[nowUser.userId intValue] newName:_groupName.text success:^{
        
        [MBProgressHUD hideHUD];
        //存入群组数据表,更新群名
        
        MyGroupDB *groupList = [[MyGroupDB alloc]init];
        
        BOOL creat1 = [groupList createTable];
        
        if (creat1) {
            [groupList saveMygroup:_groupName.text groupId:_groupId];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSString *error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"修改失败!"];
        
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
