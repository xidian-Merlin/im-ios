//
//  MyInfoTableController.m
//  ios约束版
//
//  Created by tongho on 16/7/26.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "MyInfoTableController.h"
#import "InfoViewController.h"
#import "Person.h"
#import "EditViewController.h"
#import "YCXMenu.h"
#import "SearchController.h"
#import "ViewController.h"
#import "SelectFriendViewController.h"
#import "SettingTableViewController.h"
#import "LoginModule.h"
#import "LoginAPI.h"
#import "MBProgressHUD+NJ.h"
#import "tabbarController.h"
#import "QRCodeFactory.h"
#import "KWPopoverView.h"
#import "QRCodeScannerViewController.h"
#import "IMTcpClientManager.h"

@interface MyInfoTableController ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,InfoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *meVIiew;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (nonatomic , strong) NSMutableArray *items;
@property (nonatomic, assign) int userId;
- (IBAction)loginOut:(id)sender;

- (IBAction)showMenu:(id)sender;
//@property (strong, nonatomic)  InfoViewController * info;
@property (strong, nonatomic)  UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *btnPopover;
- (IBAction)showMyCode:(id)sender forEvent:(UIEvent *)event;

@end

@implementation MyInfoTableController

@synthesize items = _items;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.scrollEnabled =NO; //禁止滚动
    // 1.获得Documents的全路径
    NSString *nowDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *nowPath = [nowDoc stringByAppendingPathComponent:@"nowUser.data"]; //扩展名可以自己定义
    
    // 3.从文件中读取MJStudent对象，将nsdata转成对象
    Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];
    _userId = [nowUser.userId intValue];
    
    
    
    // 1.获得Documents的全路径
    NSString *filename = [NSString stringWithFormat:@"%@.data",nowUser.userName];//用户名.data
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:filename];

    // 3.从文件中读取Person对象
    Person *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (nil == user.headerImage) {
         _meVIiew.image = [UIImage imageNamed:@"tn.9.png"];
    }
    else {
    [_meVIiew setImage:user.headerImage];
    
    }
    if (nil == user.name) {
         [_nickName setText:@"暂无"];
    } else {
        [_nickName setText:user.name];
    }
    
    
    
        
    NSLog(@"dfsfdf");
    
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //向右滑动
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:swipeRight];
    
    //隐藏二维码图片
    _contentView = [[UIView alloc]init];
    CGRect rx = [ UIScreen mainScreen ].bounds;
    CGSize size = rx.size;
    [_contentView setFrame:CGRectMake(size.width/2-100,size.height/2-100, 200, 200)];
    _contentView.hidden = YES;
}

- (void) tappedLeftButton:(id)sender{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    // Get the views.
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:selectedIndex - 1] view];
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    
    // Position it off screen.
    toView.frame = CGRectMake(-fromView.frame.size.width, viewSize.origin.y, fromView.frame.size.width, viewSize.size.height);
    
    [UIView animateWithDuration:0.5
                     animations: ^{
                         // Animate the views on and off the screen. This will appear to slide.
                         fromView.frame =CGRectMake(viewSize.size.width, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                         toView.frame =CGRectMake(0, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // Remove the old view from the tabbar view.
                             [fromView removeFromSuperview];
                             [self.tabBarController setSelectedIndex:selectedIndex - 1];
                             ((tabbarController *)self.tabBarController).selectbtn.selected = NO;
                             ((tabbarController *)self.tabBarController).selectbtn = ((tabbarController *)self.tabBarController).btn3;
                             ((tabbarController *)self.tabBarController).selectbtn.selected = YES;
                         }
                     }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refreshPerson:(Person *)personData
{    
    
    [_meVIiew setImage:personData.headerImage];
    [_nickName setText:personData.name];
    
    [self.tableView reloadData];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (0 == indexPath.section) {
        
        NSLog(@"fsdaf");
        
        
        UIStoryboard *ThirdStoryboard = [UIStoryboard storyboardWithName:@"ThirdStoryboard"bundle:nil];
        InfoViewController * test2obj = [ThirdStoryboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
      //      self.hidesBottomBarWhenPushed = YES;
             test2obj.infoDele = self;
        
        [self.navigationController pushViewController:test2obj animated:YES];
        
    }
    
    if (2 == indexPath.section) {
        NSLog(@"点击我设置啊");
        //跳转到设置界面
        UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
        SettingTableViewController * test2obj = [MainStoryboard instantiateViewControllerWithIdentifier:@"settingController"];
        //      self.hidesBottomBarWhenPushed = YES;
      //  test2obj.infoDele = self;
        
        [self.navigationController pushViewController:test2obj animated:YES];
        
    }
    
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];         //取消点击效果    
}


- (IBAction)loginOut:(id)sender {
    
    
    // 初始化
UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出？"preferredStyle:UIAlertControllerStyleAlert];
    
    // 分别2个创建操作
       UIAlertAction *neverAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        // 红色按键
     //点击按钮的响应事件；
   //  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
           // 退出登录
           [MBProgressHUD showMessage:@"正在拼命加载中..."];
           [[LoginModule instance] logoutSuccess:^{
               [MBProgressHUD hideHUD];
               [self.tabBarController.navigationController popToRootViewControllerAnimated:YES ];//退出总的导航控制器
               // [[IMTcpClientManager instance] disconnect];
              
           } failure:^(NSString *error) {
               [MBProgressHUD hideHUD];
               [MBProgressHUD showError:error];
           }];
   
             // [self dismissViewControllerAnimated:YES completion:^{
         
  //   }];
           
     
     
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

- (IBAction)showMenu:(id)sender {
    // 通过NavigationBarItem显示Menu
    
    [YCXMenu setTintColor:[UIColor colorWithRed:0.118 green:0.573 blue:0.820 alpha:1]];
    [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 50, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
        NSLog(@"%@",item);
        NSLog(@"%ld",(long)index);
        switch (index) {
            case 0:{
                //创建群组
                
                
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
                SearchController * test = [mainStoryBoard instantiateViewControllerWithIdentifier:@"nameGroup"];
                
                
                [self.navigationController pushViewController:test animated:YES];
                
                
                
                
                
                
                //   SelectFriendViewController *groupChat = [[SelectFriendViewController alloc] init];
                
                //   [self.navigationController pushViewController:groupChat animated:YES];
                
                NSLog(@"发起群聊");
            }
                break;
            case 1:
            {
                //添加好友
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
                SearchController * test = [mainStoryBoard instantiateViewControllerWithIdentifier:@"search"];
                
                
                [self.navigationController pushViewController:test animated:YES];
                
                
                NSLog(@"添加好友");
            }
                break;
            case 2:
            {
                // 扫一扫
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
                QRCodeScannerViewController * scanner = [mainStoryBoard instantiateViewControllerWithIdentifier:@"scanner"];
                
                [self.navigationController pushViewController:scanner animated:YES];
                NSLog(@"扫描二维码");
            }
                
                break;
            case 3:
            {
                NSLog(@"检查更新");
            }
                break;
            default:
                break;
        }
        
        
        
        
    }];
}



-(void)viewWillAppear:(BOOL)animated{
    
    
      
}
#pragma mark - Table view data source




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

#pragma mark - setter/getter
- (NSMutableArray *)items {
    if (!_items) {
        
        // set title
        YCXMenuItem *menuTitle = [YCXMenuItem menuTitle:@"发起群聊" WithIcon:nil];
        menuTitle.foreColor = [UIColor whiteColor];
        menuTitle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
        
        //set logout button
    //    YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"Logout" image:nil target:self action:@selector(logout:)];
    //    logoutItem.foreColor = [UIColor redColor];
     //   logoutItem.alignment = NSTextAlignmentCenter;
     //   UIImage *image = [UIImage imageNamed:@"a_h.png"];
        
        
        //set item
        _items = [ @[//menuTitle,
                     [YCXMenuItem menuItem:@"发起群聊"
                                     image:nil
                                       tag:100
                                  userInfo:@{@"title":@"Menu"}],
                     [YCXMenuItem menuItem:@"添加朋友"
                                     image:nil
                                       tag:101
                                  userInfo:@{@"title":@"Menu"}],
                     [YCXMenuItem menuItem:@"扫一扫"
                                     image:nil
                                       tag:102
                                  userInfo:@{@"title":@"Menu"}]
                     //logoutItem
                     ] mutableCopy];

    }
    return _items;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
}




- (IBAction)showMyCode:(id)sender forEvent:(UIEvent *)event{
    
    NSLog(@"显示二维码！！！！");
    UIImage * codeImage = [QRCodeFactory qrImageForIntNumber:_userId imageSize:(CGFloat)200 logoImageSize:50];
    
     _contentView.layer.contents = (id)codeImage.CGImage;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    NSSet *set = event.allTouches;
    UITouch *touch = [set anyObject];
      CGPoint point1 = [touch locationInView:window];
    
   // CGPoint point1 = CGPointMake(frame.origin.x + ceil(frame.size.width/2),frame.origin.y + ceil(frame.size.height/2));
    //    CGPoint point = sender.center;
    [KWPopoverView showPopoverAtPoint:point1 inView:self.view withContentView:_contentView];
    
}
@end
