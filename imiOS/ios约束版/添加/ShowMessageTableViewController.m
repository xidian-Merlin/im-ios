//
//  ShowMessageTableViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/5.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "ShowMessageTableViewController.h"
#import "ImdbModel.h"
#import "Person.h"
#import "VerifyViewController.h"
#import "RemarkViewController.h"
#import "ChatViewController.h"
#import "tabbarController.h"
#import "YCXMenu.h"
#import "ContactModule.h"
#import "MBProgressHUD+NJ.h"
#import "HfDbModel.h"
#import "IMConstant.h"


@interface ShowMessageTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *result;
@property (strong, nonatomic) ImdbModel *imdbModel;

@property (weak, nonatomic) IBOutlet UIImageView *iconview;
@property (weak, nonatomic) IBOutlet UILabel *nickNamel;
@property (weak, nonatomic) IBOutlet UILabel *userNamel;
@property (weak, nonatomic) IBOutlet UILabel *nickName2;
@property (weak, nonatomic) IBOutlet UIButton *sendMessage;
@property (strong, nonatomic) NSMutableArray *items;
@property (nonatomic, strong) HfDbModel * hfdbModel;
- (IBAction)sendMess:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addFriend;

@property (weak, nonatomic) IBOutlet UIButton *multiFunction;



- (IBAction)addFri:(id)sender;
@end

@implementation ShowMessageTableViewController

@synthesize items = _items;

- (void)viewDidLoad {
    [super viewDidLoad];
    
      self.tableView.scrollEnabled =NO;
    
    //界面初始化
    
    self.iconview.image = _icon;
    self.nickNamel.text = _nickName;
    self.userNamel.text = [NSString stringWithFormat:@"%@ %@",@"用户名:",_userName];
    _nickName2.text = [NSString stringWithFormat:@"%@ %@",@"昵称:",_nickkName2];
    
    
    
   
    
    
    _imdbModel = [[ImdbModel alloc]init];
    _hfdbModel = [[HfDbModel alloc]init];
   
    
    
    // _imdbModel = [[ImdbModel alloc]init];
    // _imdbModel.tableName = @"ds545";
    BOOL create = [_imdbModel createTable];
    
 //   -(NSArray *)search:(NSString *) nickName
    
    if(create){
    self.result =  [_imdbModel search:_userId];    //查找该好友的ID是否在数据库中
    }
    if (0 == _result.count) {              //如果不是我的好友
         _sendMessage.hidden = YES;
         _addFriend.hidden = NO;
        _multiFunction.hidden = YES;;
        
    } else {                               //如果是我的好友
         _addFriend.hidden = YES;
        _sendMessage.hidden = NO;
        _multiFunction.hidden = NO;
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMenu:(id)sender {
    // 通过NavigationBarItem显示Menu
    
    [YCXMenu setTintColor:[UIColor colorWithRed:0.118 green:0.573 blue:0.820 alpha:1]];
    [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 50, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
        NSLog(@"%@",item);
        NSLog(@"%ld",(long)index);
        switch (index) {
            case 0:{
                //删除好友
                // 初始化
                UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除？"preferredStyle:UIAlertControllerStyleAlert];
                
                // 分别2个创建操作
                UIAlertAction *neverAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [MBProgressHUD showMessage:@"正在拼命加载ing...."];
                    
                    [[ContactModule instance] deleteContact:_userId
                                                    success:^(){
                                                        [self.imdbModel deleteFriendWithuserId:_userId];
                                                        [self.hfdbModel deleteFriendWithuserId:_userId style:1];  //删除联系人时，删除会话记录
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:nil];//发送删除通知给tabbar                                            [self viewDidLoad];
                                                        [MBProgressHUD hideHUD];
                                                        [MBProgressHUD showSuccess:@"删除成功!"];
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                        
                                                        
                                                        
                                                        
                                                    }failure:^(){
                                                        [MBProgressHUD hideHUD];
                                                        
                                                        
                                                        [MBProgressHUD showError:@"删除失败!"];
                                                    }
                     ];
                    
                    
                    
                    
                }];
                
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    // 取消按键
                    
                }];
                
                // 添加操作（顺序就是呈现的上下顺序）
                
                [alertDialog addAction:neverAction];
                [alertDialog addAction:okAction];
                
                // 呈现警告视图
                [self presentViewController:alertDialog animated:YES completion:nil];
                
                
                
              
            }
                break;
            case 1:
            {
                //more
                
               
            }
                break;
            case 2:
                //检查更新
              
                break;
                //more
                
                
            default:
                break;
        }
        
        
        
        
    }];
}



#pragma mark - setter/getter
- (NSMutableArray *)items {
    if (!_items) {
        
        // set title
        YCXMenuItem *menuTitle = [YCXMenuItem menuTitle:@"多功能" WithIcon:nil];
        menuTitle.foreColor = [UIColor whiteColor];
        menuTitle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
        
        //set logout button
        //    YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"Logout" image:nil target:self action:@selector(logout:)];
        //  logoutItem.foreColor = [UIColor redColor];
        //  logoutItem.alignment = NSTextAlignmentCenter;
        //    UIImage *image = [UIImage imageNamed:@"a_h.png"];
        
        
        //set item
        _items = [ @[//menuTitle,
                     [YCXMenuItem menuItem:@"删除好友"
                                     image:nil
                                       tag:100
                                  userInfo:@{@"title":@"Menu"}]
                     //logoutItem
                     ] mutableCopy];
    }
    return _items;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
}


#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section) {
        //跳转入设置备注页面
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
        RemarkViewController * test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"RemarkController"];
        test2obj.userId = _userId;  //即为好友的ID
        
        [self.navigationController pushViewController:test2obj animated:YES];
        
        
        
    }

 [tableView deselectRowAtIndexPath:indexPath animated:YES];         //取消点击效果
    
}





- (IBAction)sendMess:(id)sender {
    //跳转进入聊天界面,先返回到会话界面，仔由会话界面，跳转到聊天界面
    
    

    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    
    ((tabbarController *)self.tabBarController).selectbtn.selected = NO;
    ((tabbarController *)self.tabBarController).selectbtn = ((tabbarController *)self.tabBarController).btn1;
    ((tabbarController *)self.tabBarController).selectbtn.selected = YES;
   
    
    UINavigationController *nav = (UINavigationController *)((tabbarController *)self.tabBarController).viewControllers[0];
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Second"bundle:nil];
    ChatViewController * test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"ChatView"];
    
    test2obj.temTitle = _nickName;
    test2obj.hhId = _userId;
    test2obj.heImage = _icon;    //将图片传给聊天框
    test2obj.isGroupStyle = NO;  //单聊
    
    [nav pushViewController:test2obj animated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];  //执行此处将销毁控制器 所以要放在尾部

    
    
    
    
}


- (IBAction)addFri:(id)sender {
    //发送添加好友请求，
    NSLog(@"添加好友");
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
    VerifyViewController * test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"VerifyView"];
    test2obj.userId = _userId;
    
    [self.navigationController pushViewController:test2obj animated:YES];
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
