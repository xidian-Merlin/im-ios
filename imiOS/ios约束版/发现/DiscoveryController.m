//
//  DiscoveryController.m
//  ios约束版
//
//  Created by tongho on 16/7/27.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "DiscoveryController.h"
#import "YCXMenu.h"
#import "SearchController.h"
#import "SelectFriendViewController.h"
#import "tabbarController.h"
#import "QRCodeScannerViewController.h"


@interface DiscoveryController ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *items;


- (IBAction)showMenu:(id)sender;
@end

@implementation DiscoveryController



@synthesize items = _items;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.scrollEnabled =NO;
    
  
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //左右滑动
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:swipeRight];
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



#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
*/
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (0 == indexPath.section) {
        
        // 扫一扫
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
        QRCodeScannerViewController * scanner = [mainStoryBoard instantiateViewControllerWithIdentifier:@"scanner"];
        
        [self.navigationController pushViewController:scanner animated:YES];
        NSLog(@"扫描二维码");
        
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];         //取消点击效果
}




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
      //  UIImage *image = [UIImage imageNamed:@"a_h.png"];
        
        
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
                             ((tabbarController *)self.tabBarController).selectbtn = ((tabbarController *)self.tabBarController).btn2;
                             ((tabbarController *)self.tabBarController).selectbtn.selected = YES;
                         }
                     }];
}


- (void) tappedRightButton:(id)sender{
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    // Get the views.
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:selectedIndex + 1] view];
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    
    // Position it off screen.
    toView.frame = CGRectMake(fromView.frame.size.width, viewSize.origin.y, fromView.frame.size.width, viewSize.size.height);
    
    [UIView animateWithDuration:0.5
                     animations: ^{
                         // Animate the views on and off the screen. This will appear to slide.
                         fromView.frame =CGRectMake(-viewSize.size.width, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                         toView.frame =CGRectMake(0, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // Remove the old view from the tabbar view.
                             [fromView removeFromSuperview];
                             [self.tabBarController setSelectedIndex:selectedIndex + 1];
                             
                             ((tabbarController *)self.tabBarController).selectbtn.selected = NO;
                             ((tabbarController *)self.tabBarController).selectbtn = ((tabbarController *)self.tabBarController).btn4;
                             ((tabbarController *)self.tabBarController).selectbtn.selected = YES;
                         }
                     }];
}

@end
