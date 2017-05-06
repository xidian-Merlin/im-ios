//
//  NameGroupViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/14.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "NameGroupViewController.h"
#import "MBProgressHUD+NJ.h"
#import "GroupModule.h"
#import "CreatGroupAPI.h"
#import "GroupMemeberDb.h"
#import "Person.h"
#import "MyGroupDB.h"

@interface NameGroupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *groupName;
- (IBAction)submit:(id)sender;

@end

@implementation NameGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    
    [MBProgressHUD showMessage:@"正在拼命加载ing...."];
    
    
    
    [[GroupModule instance] creatGroupWithName:_groupName.text success:^(NSNumber* ID){
        NSLog(@"创建成功！！！ID:%d",[ID intValue]);
      [MBProgressHUD hideHUD];
      
      // 1.获得Documents的全路径
      NSString *nowDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
      // 2.获得文件的全路径
      NSString *nowPath = [nowDoc stringByAppendingPathComponent:@"nowUser.data"]; //扩展名可以自己定义
      
      // 3.从文件中读取MJStudent对象，将nsdata转成对象
      Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];
      // Do any additional setup after loading the view.
      // 1.获得Documents的全路径    //根据上述的用户名，读取用户名.data中的数据
      NSString *filename = [NSString stringWithFormat:@"%@.data",nowUser.userName];  //用户名.data
      
      NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
      // 2.获得文件的全路径
      NSString *path = [doc stringByAppendingPathComponent:filename]; //扩展名可以自己定义
      
      // 3.从文件中读取MJStudent对象，将nsdata转成对象
      Person *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];//当前用户的信息

      //若成功，将自己加入群组成员数据库，界面返回到根界面
      
      GroupMemeberDb *groupMember = [[GroupMemeberDb alloc]init];
      
      BOOL creat = [groupMember createTableWithGroupId:[ID intValue]];
      
      UIImage * avatar = user.headerImage;
      if (nil == user.headerImage) {
          avatar = [UIImage imageNamed:@"tn.9.png"];
      }
      
      NSData* avatarData;
      if (UIImagePNGRepresentation(avatar)) {
          avatarData = UIImagePNGRepresentation(avatar);
      }else {
          avatarData = UIImageJPEGRepresentation(avatar, 1.0);
      }

      
      if (creat) {  //我的昵称， id，头像，权限；创建者权限为1；
          [groupMember saveMygroupMember:user.name memberId:nowUser.userId Icon:avatarData permit:1];
      }
      
     
    //存入群组数据表
      MyGroupDB *groupList = [[MyGroupDB alloc]init];
      
      BOOL creat1 = [groupList createTable];
      
      if (creat1) {
          [groupList saveMygroup:_groupName.text groupId:[ID intValue]];
      }
      
      
      
      
      
      //返回根目录
      [self.navigationController popToRootViewControllerAnimated:YES];
      
    } failure:^(NSString* error){
    
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"创建失败!"];
    
    
    }];
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    // self.hidesBottomBarWhenPushed=YES;
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:YES];
  
    
    self.navigationController.navigationBarHidden = NO;
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:NO];
    
    // self.navigationController.navigationBarHidden = YES;
}


@end
