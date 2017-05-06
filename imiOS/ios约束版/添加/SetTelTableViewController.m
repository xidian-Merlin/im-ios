//
//  SetTelTableViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/5.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "SetTelTableViewController.h"
#import "SetNewTel.h"
#import "SetnewMail.h"
#import "Person.h"

@interface SetTelTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *telNumber;
@property (weak, nonatomic) IBOutlet UILabel *emailNuber;

@end

@implementation SetTelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source






- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (0 == indexPath.section ) {
        if (0 == indexPath.row) {
            //进入修改密码界面
            UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
            SetNewTel * test2obj = [MainStoryboard instantiateViewControllerWithIdentifier:@"newTel"];
          //将当前绑定的手机号与邮箱号传给SetNewTel
            
            test2obj.nowTel = _telNumber.text;
            test2obj.nowMail = _emailNuber.text;
            [self.navigationController pushViewController:test2obj animated:YES];
            
            
            
            
            
        }
        if (1 == indexPath.row){
            
            //进入设置权限界面
            UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
            SetnewMail * test2obj = [MainStoryboard instantiateViewControllerWithIdentifier:@"newMail"];
            //      self.hidesBottomBarWhenPushed = YES;
            //  test2obj.infoDele = self;
            //将当前绑定的手机号与邮箱号传给SetNewTel
            
            test2obj.nowTel = _telNumber.text;
            test2obj.nowMail = _emailNuber.text;
            [self.navigationController pushViewController:test2obj animated:YES];
            
        }
        
           }
       
    [tableView deselectRowAtIndexPath:indexPath animated:YES];         //取消点击效果
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:YES];
    
    self.navigationController.navigationBarHidden = NO;
    //   view.frame=CGRectMake(0, 480, 0, 0);
    //读取归档数据，显示在手机号与邮箱号中
    //读取nowUser.data，获取用户名
    // 1.获得Documents的全路径
    NSString *nowDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *nowPath = [nowDoc stringByAppendingPathComponent:@"nowUser.data"]; //扩展名可以自己定义
    
    // 3.从文件中读取MJStudent对象，将nsdata转成对象
    Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];
    
    //读取用户名.data，得到旧的邮箱与电话号码
    
    // 1.获得Documents的全路径    //根据上述的用户名，读取用户名.data中的数据
    NSString *filename = [NSString stringWithFormat:@"%@.data",nowUser.userName];  //用户名.data
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:filename]; //扩展名可以自己定义
    
    // 3.从文件中读取用户信息对象，将nsdata转成对象
    Person *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    _telNumber.text = user.tel;
    _emailNuber.text = user.mail;

    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:NO];
    
    self.navigationController.navigationBarHidden = YES;
}



@end
