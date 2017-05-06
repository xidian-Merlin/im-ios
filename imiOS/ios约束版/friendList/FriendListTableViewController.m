//
//  FriendListTableViewController.m
//  ios约束版
//
//  Created by tongho on 16/7/23.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "FriendListTableViewController.h"
#import "FriendListCell.h"
#import "FriendListClass.h"
#import "FriendList.h"
#import <CoreData/CoreData.h>
#import "YCXMenu.h"
#import "SearchController.h"
#import "ImdbModel.h"
#import "NewFriendDb.h"     //新的好友表操作模型，方便获取新的朋友的未读消息数
#import "HfDbModel.h"
#import "historyHf.h"
#import "ChineseString.h"
#import "pinyin.h"
#import "Person.h"
#import "SelectFriendViewController.h"
#import "NewFriendTableViewController.h"
#import "GroupListTableViewController.h"
#import "IMConstant.h"
#import "tabbarController.h"
#import "ShowMessageTableViewController.h"
#import "GetUserInfoAPI.h"
#import "ContactModule.h"
#import "MBProgressHUD+NJ.h"
#import "NameGroupViewController.h"
#import "QRCodeScannerViewController.h"

//#import "RKNotificationHub.h"

@interface FriendListTableViewController ()
@property (strong, nonatomic) NSMutableArray *result;
@property (strong, nonatomic) NSMutableArray *result1;
@property (strong, nonatomic) FriendListClass *friendList;
@property (nonatomic , strong) NSMutableArray *items;
@property (nonatomic, strong) ImdbModel *imdbModel;
@property (nonatomic, strong) NewFriendDb *nfdbModel;
@property (nonatomic, strong) HfDbModel * hfdbModel;
@property (nonatomic,assign)  int flag;
@property (nonatomic, assign)double oldY;


-(void)setExtraCellLineHidden: (UITableView *)tableView;
- (IBAction)showMenu:(id)sender;
-(void)refresh;
@end

@implementation FriendListTableViewController

@synthesize items = _items;        //此处为什么不是默认的，版本问题？

- (void)viewDidLoad
{
   
    
    
     [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _flag =  0;
    
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//使分隔线可以调整
    [self.tableView setSeparatorColor:[UIColor grayColor]];  //设置分隔线的颜色
    
    [self setExtraCellLineHidden:self.tableView];
    _nfdbModel = [[NewFriendDb alloc]init];
    
    
    _imdbModel = [[ImdbModel alloc]init];
    
     _hfdbModel = [[HfDbModel alloc]init];
    //设置监听：
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:IMNotificationNewContact   //添加了联系人
                                               object:nil];
    
    //设置监听：
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:IMNotificationReceiveFriendRequest   //好友请求
                                               object:nil];
    
    
    
       /*  if(_dataArr.count<8){
    self.tableView.scrollEnabled = NO;
    }
    */
    //左右滑动
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:swipeRight];
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
                             ((tabbarController *)self.tabBarController).selectbtn = ((tabbarController *)self.tabBarController).btn1;
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
                             ((tabbarController *)self.tabBarController).selectbtn = ((tabbarController *)self.tabBarController).btn3;
                             ((tabbarController *)self.tabBarController).selectbtn.selected = YES;
                         }
                     }];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sortedArrForArrays count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 2;
    }
     return  [(NSMutableArray *)[self.sortedArrForArrays objectAtIndex:(section-1)] count];//此处必须转，不然无法分辨使用哪个
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return nil;
    }
    
    return [_sectionHeadsKeys objectAtIndex:(section-1)];
}

//修改headlable的位置信息


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init] ;
    label.frame = CGRectMake(20, 0, CGRectGetWidth(tableView.frame)-20, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHue:(136.0/360.0)  // Slightly bluish green
                                 saturation:1.0
                                 brightness:0.60
                                      alpha:1.0];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 20)];
    view.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [view addSubview:label];
    
    return view;
}

//设置标题尾
/*设置标题脚的名称*/


-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if ([self.sortedArrForArrays count] == section  ) {
        
      NSString *string = [NSString stringWithFormat:@"%lu%@", (unsigned long)[_dataArr count], @"位联系人" ];
        return string;
        
    }else{
       return nil;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    if (0 == section  ) {
        
        return 2;
        
    }else{
        return 20;
    }
    
}


//设置标题脚的位置与高度

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

{
    if ([self.sortedArrForArrays count] == section  ) {
        
     
        return 40;
        
    }else{
        return 0;
    }
   
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForFooterInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
     if ([self.sortedArrForArrays count] == section  ) {
         // Create label with section title
    UILabel *label = [[UILabel alloc] init] ;
    label.frame = CGRectMake(tableView.frame.size.width/2-40, 10, CGRectGetWidth(tableView.frame)-20, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHue:(136.0/360.0)  // Slightly bluish green
                                 saturation:1.0
                                 brightness:0.60
                                      alpha:1.0];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 40)];
    view.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [view addSubview:label];
    
    return view;
}
    return nil;
}


//为了使最后一个标签出现时，禁止向下滚动，设置标志flag 表示最后一个尾部的出现

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    
    if ([self.sortedArrForArrays count] == section  ) {
        
        _flag = 1;
        
    }else{
        _flag = 0;
    }


}
/*
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.tableView.contentOffset.y > _oldY) {
        // 上滑
        self.tableView.scrollEnabled = NO;
    }
    else{
        // 下滑
        self.tableView.scrollEnabled = YES;                   //用这个方法也是可以的，但是不是一直判断，而是结束时判断
    }
    
    // _oldY = self.tableView.contentOffset.y;
    
}

*/



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{                 //该方法会进行多次判断,需要真机判段
    if ([scrollView isEqual: self.tableView] &&  _flag == 1) {
        if (self.tableView.contentOffset.y > _oldY) {
            // 上滑
            self.tableView.scrollEnabled = NO;
            NSLog(@"gfsgf");
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.001f];   //当程序判为上滑时，可以继续向下
        }
        else{
            // 下滑
            self.tableView.scrollEnabled = YES;
        }
        
       // _oldY = self.tableView.contentOffset.y;
    
    }
}

- (void)delayMethod {
    
    NSLog(@"allow scroll");
    self.tableView.scrollEnabled = YES;

}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 获取开始拖拽时tableview偏移量
    _oldY = self.tableView.contentOffset.y;
   // self.tableView.scrollEnabled = YES;
}



/*
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"我是button 1" forState:UIControlStateNormal ];
        return button;
    }
    else
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"我是button 2" forState:UIControlStateNormal ];
        return button;
    }
    
    
}

*/


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"friendListCell";
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    
    if (cell == nil) {
        cell = [[FriendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    if (0 == indexPath.section) {
        
        if (0 == indexPath.row) {
            
            //查询新的朋友数据库中，read 标志为0的，0表示未读，按时间降序，并将它们中的第一个显示在该cell中，将总数显示在气泡中
            //如果result结果为0，那么表示没有新的消息，则默认取一下的值，同时在选中该cell的时候将所有的消息的0的isread标志变为1，
            BOOL create1 = [_nfdbModel createTable];
            
            if(create1){
                self.result1 = (NSMutableArray *) [_nfdbModel searchIsread:0];   //未读的请求数，两个查询可以合并
            }
            //
            [(( tabbarController *)self.tabBarController).hub2 setCount:(int)_result1.count];   //将未读数目显示在tab上
            NSString *str1;
            UIImage *image;
            NSData *dataObj1;
            
            
            
            if(0 == _result1.count){
           str1 = @"新的朋友";
            image = [UIImage imageNamed:@"avl.png"];
             dataObj1 = UIImagePNGRepresentation(image);
                [cell.hub setCount:(int)_result1.count];    //将气泡数变为零
            }
            else{      //此处改为读取第一个
            
                
                
                str1 = ((historyHf *)_result1[0]).nickName2;    //显示的是备注
               // str1 = @"新的朋友";
               // image = [UIImage imageNamed:@"avl.png"];
               // dataObj1 = UIImagePNGRepresentation(image);
                dataObj1 = ((historyHf *)_result1[0]).icon;
               [cell.hub setCount:(int)_result1.count];       //显示气泡数
            }
            
          //  [cell.hub increment];
            
            [cell setCellValue:str1   icon:dataObj1];
        }
        if (1 == indexPath.row) {
            NSString * str2 = @"群聊";
            UIImage *image = [UIImage imageNamed:@"zq.png"];
            NSData *dataObj2 = UIImagePNGRepresentation(image);
            
            [cell setCellValue:str2   icon:dataObj2];
        }
    }
    
    else if ([self.sortedArrForArrays count]+1 > indexPath.section) {
       
        
        
        NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section-1];
        if ([arr count] > indexPath.row) {
            
            
            ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
            //将得到的str.string 放入result的循环，得到相对应的result，再对cell賦值
            //等于过滤查询
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nickName2 == %@", str.string];//按照备注
            NSArray *filteredArray = [_result filteredArrayUsingPredicate:predicate];
             historyHf *friend = filteredArray[0];
            
            if(filteredArray.count > 1)       //如果有的用户的备注名一样，则在显示一个后将它删除
             [_result removeObject:filteredArray[0]];//考虑到多个用户的备注可以一样
            cell.userName = friend.nickName;    //存储用户名
            cell.userId = friend.userId;
            cell.nickName = friend.nickName1;    //存储昵称
            [cell setCellValue:friend.nickName2   icon:friend.icon ]; //存储用户名与头像
            
        } else {
            NSLog(@"arr out of range");
        }
    } else {
        NSLog(@"sortedArrForArrays out of range");
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    if (0 == indexPath.section) {
        
        
        if (0 == indexPath.row) {
            //跳转进入好友申请记录界面
            BOOL create2 = [_nfdbModel createTable];
            if(create2){
                [_nfdbModel set:0 tonewFlag:1 withCerify:@"SET isread = ? WHERE isread = ?"];   //将未读标准统一修改为已读
            }
            
            
            NewFriendTableViewController *newFriendList =[[NewFriendTableViewController alloc]init];
            [self.navigationController pushViewController:newFriendList animated:YES];
            
            
        }
        if (1 == indexPath.row){
            
               //跳转进入我的群组界面
            GroupListTableViewController * group = [[GroupListTableViewController alloc]init];
            [self.navigationController pushViewController:group animated:YES];
            
        }
    }
    else{
    
      //拿到对应的cell，将cell的值传给即将跳转的界面
        FriendListCell *cell = (FriendListCell *)[tableView cellForRowAtIndexPath:indexPath];
        [MBProgressHUD showMessage:@"正在加载..."];
        [[ContactModule instance]GetUserInfo:cell.userId success:^(IMUserEntity *user){   //搜索网络，获取当前的联系人资料
            [MBProgressHUD hideHUD];
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
            ShowMessageTableViewController * test2obj = [secondStoryBoard           instantiateViewControllerWithIdentifier:@"showMessageController"];
            
            test2obj.userId = cell.userId;
            test2obj.userName = user.name;
            test2obj.nickName = cell.userNameLabel.text;
            test2obj.nickkName2 =  cell.nickName;
            test2obj.icon = user.avatar;
            [self.navigationController pushViewController:test2obj animated:YES];
            //网络搜索成功，将联系人的表与会话表更新
            
            
            
            
            
            UIImage * avatar = user.avatar;
            if (nil == user.avatar) {
                avatar = [UIImage imageNamed:@"tn.9.png"];
            }
            
            NSData *avatarData;
            if (UIImagePNGRepresentation(avatar)) {
                avatarData = UIImagePNGRepresentation(avatar);
            }else {
                avatarData = UIImageJPEGRepresentation(avatar, 1.0);
            }
            
            //跟新联系人界面
            [_imdbModel setIcon:avatarData withUserId:cell.userId];   //更新头像
            
            if ([cell.nickName isEqualToString:cell.userNameLabel.text]) {   //如果原昵称与备注一样，则说明没有备注,将备注变为新昵称
                [_imdbModel set:user.nick withUserId:cell.userId];
            }
            //否则，有定义备注，则备注不用更新
            
            //跟新会话界面
            HfDbModel* hfDbModel1 = [[HfDbModel alloc] init];
            
            BOOL create1 = [hfDbModel1 createTable];
            if (create1) {
                
                [hfDbModel1 setIcon:avatarData withUserId:cell.userId style:1];
            }
            
            if ([cell.nickName isEqualToString:cell.userNameLabel.text]) {   //如果原昵称与备注一样，则说明没有备注,将备注变为新昵称
                [hfDbModel1 set:user.nick withUserId:cell.userId style:1];
            }
            //否则，有定义备注，则备注不用更新
            
            
            
        } failure:^(NSString* error){       //如果网络搜索失败，那么使用本地的用户信息
             [MBProgressHUD hideHUD];
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
            ShowMessageTableViewController * test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"showMessageController"];
            
            test2obj.userId = cell.userId;
            test2obj.userName = cell.userName;
            test2obj.nickName = cell.userNameLabel.text;   //备注
            test2obj.nickkName2 =  cell.nickName;
            test2obj.icon = cell.headImage.image;
            
            
            [self.navigationController pushViewController:test2obj animated:YES];
            
        }];
        
        
        
       
    
    }
    
      [tableView deselectRowAtIndexPath:indexPath animated:YES];         //取消点击效果

}





//下述的两个方法要一起使用，才可以让自定义分割线从最左侧开始

-(void)viewDidLayoutSubviews
{
    // 重写UITableView的方法是分割线从最左侧开始
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView  setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView  respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView  setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    // 重写UITableView的方法是分割线从最左侧开始
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
//此方法用来隐藏多余的cell

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
/*
//自定义删除按钮
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//开启在Cell中向左划时显示删除按钮
// Override to support editing the table
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //获取cell数据
        FriendListCell *cell = (FriendListCell *)[tableView cellForRowAtIndexPath:indexPath];

        // 初始化
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除？"preferredStyle:UIAlertControllerStyleAlert];
        
        // 分别2个创建操作
        UIAlertAction *neverAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [MBProgressHUD showMessage:@"正在拼命加载ing...."];
            
            [[ContactModule instance] deleteContact:cell.userId
                                            success:^(){
                                                [self.imdbModel deleteFriendWithuserId:cell.userId];
                                                [self.hfdbModel deleteFriendWithuserId:cell.userId style:1];  //删除联系人时，删除会话记录
                                                [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:nil];//发送删除通知给tabbar                                            [self viewDidLoad];
                                                [MBProgressHUD hideHUD];
                                                
                                                [self refresh];
                                                
                                                
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
}
*/


/*
 //通过KVC把参数传入目的控制器
 [nextView setValue:friend.nickname forKey:@"sendUserName"];
 // [nextView setValue:friend. forKey:@"jidStr"];
 
 // FriendModelClass *historyFriend = [[FriendModelClass alloc] init];
 // [historyFriend saveHistoryFriend:friend.nickname WithJid:friend.jidStr];
 [self viewDidLoad];
 }*/



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




#pragma mark - setter/getter
- (NSMutableArray *)items {
    if (!_items) {
        
        // set title
        YCXMenuItem *menuTitle = [YCXMenuItem menuTitle:@"发起群聊" WithIcon:nil];
        menuTitle.foreColor = [UIColor whiteColor];
        menuTitle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
        
        //set logout button
     //   YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"Logout" image:nil target:self action:@selector(logout:)];
      //  logoutItem.foreColor = [UIColor redColor];
     //   logoutItem.alignment = NSTextAlignmentCenter;
       
        
        
        //set item
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
                                  userInfo:@{@"title":@"Menu"}],
                     [YCXMenuItem menuItem:@"检查更新"
                                     image:nil
                                       tag:103
                                  userInfo:@{@"title":@"Menu"}]
                     
                     //logoutItem
                     ] mutableCopy];
    }
    return _items;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
}




//将昵称进行排序，返回结果
- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string=[NSString stringWithString:[arrToSort objectAtIndex:i]];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
     //   [chineseString release];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] init] ;
            checkValueAtIndex = NO;
        }
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}



-(void)viewWillAppear:(BOOL)animated{
    
    [self refresh];
  /*  self.result =  [_imdbModel  queryAll];
    
    //得到result后要将其进行循环，得出用户的昵称放入数组，进行排序
    for (id object in _result) {
        NSLog(@"langArray=%@", ((historyHf *)object).nickName);
        [_dataArr addObject:((historyHf *)object).nickName];
        
    }
    self.sortedArrForArrays = [self getChineseStringArr:_dataArr];
     self.tableView.scrollEnabled = YES;
    [self.tableView reloadData];        */      //界面即将出现时刷新界面
    
    
     self.tableView.scrollEnabled = YES;
}

-(void)refresh {    //刷新界面
    
 _dataArr = [[NSMutableArray alloc] init];
    _sortedArrForArrays = [[NSMutableArray alloc] init];
    _sectionHeadsKeys = [[NSMutableArray alloc] init];      //initialize a array to hold keys like A,B,C ...
    
    BOOL create = [_imdbModel createTable];
    
    if(create){
        self.result = (NSMutableArray *) [_imdbModel  queryAll];
    }
    
    //得到result后要将其进行循环，得出用户的昵称放入数组，进行排序
    for (id object in _result) {
        NSLog(@"langArray=%@", ((historyHf *)object).nickName);
        [_dataArr addObject:((historyHf *)object).nickName2];
        
    }
    self.sortedArrForArrays = [self getChineseStringArr:_dataArr];
    
    [self.tableView reloadData];

    
    BOOL create1 = [_nfdbModel createTable];
    
    if(create1){
        self.result1 = (NSMutableArray *) [_nfdbModel searchIsread:0];   //未读的请求数，两个查询可以合并
       
    }
    //
    [(( tabbarController *)self.tabBarController).hub2 setCount:(int)_result1.count];   //将未读数目显示在tab上
    
    
}
-(void)dealloc{
   // 移除监听：
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMNotificationNewContact object:nil];
}

@end


