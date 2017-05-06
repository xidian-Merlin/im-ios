//
//  HistoryFriendTableViewController.m
//  MecoreMessageDemo

//  Created by tongho on 16/7/20.
//  Copyright © 2016年 tongho. All rights reserved.
//
#import "HistoryFriendTableViewController.h"
#import "UserInfoCell.h"
#import "FriendModelClass.h"
#import "HistoryFriend.h"
#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "ChatViewController.h"
#import "tabbarController.h"
#import "SearchController.h"
#import "ImdbModel.h"
#import "historyHf.h"
#import "Person.h"
#import "TimeConvert.h"
#import "SelectFriendViewController.h"
#import "HfDbModel.h"
#import "tabbarController.h"
#import "IMConstant.h"
#import "MyGroupDB.h"
#import "IMGroupMemberEntity.h"
#import "GroupModule.h"
#import "GroupMemeberModel.h"
#import "GroupMemeberDb.h"
#import "groupCell.h"
#import "MessageModule.h"
#import "QRCodeScannerViewController.h"


#import "YCXMenu.h"//#import "LoginViewController.h"

@interface HistoryFriendTableViewController ()

@property (strong, nonatomic) NSArray *result;

@property (nonatomic , strong) NSMutableArray *items;
@property (strong, nonatomic) FriendModelClass *historyFirend;
@property (strong, nonatomic) HfDbModel *hfdbModel;
@property (assign, nonatomic) int allRedcount;
// 被选中cell的IndexPath;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

- (IBAction)showMenu:(id)sender;
-(void)setExtraCellLineHidden: (UITableView *)tableView;

- (void)adddata;

@end

@implementation HistoryFriendTableViewController

@synthesize items = _items;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
   
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//使分隔线可以调整
    [self.tableView setSeparatorColor:[UIColor grayColor]];  //设置分隔线的颜色
    
    [self setExtraCellLineHidden:self.tableView];//隐藏多余的分割线
    
    
    
    
    _hfdbModel = [[HfDbModel alloc]init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:IMNotificationReceiveMessage         //新的消息
                                               object:nil];
   
    
    
   // _historyFirend = [[FriendModelClass alloc] init];
   // self.result = [_historyFirend queryAll];
    
    
   // NSLog(@"%@",self.result);
   // [self.tableView reloadData];
    
    //table表刷新后，计算所有的小红点的个数，显示在tabbar上
    
    
    // [(( tabbarController *)self.tabBarController).hub1 setCount:_allRedcount];   //经验证该方法有效
    
    
    //添加左右滑动手势，切换tab 的view
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self.view addGestureRecognizer:swipeLeft];
    
    
}





- (IBAction)tapLoginOut:(id)sender {
    
   // NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
   // [userDefault removeObjectForKey:@"username"];
  //  [userDefault removeObjectForKey:@"password"];
   // [self adddata];
   /* UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    ViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:loginViewController animated:YES completion:^{
    }];*/
    
    
    
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.result.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    historyHf *friend = self.result[indexPath.row];
    
    
    
    
    if (2 == friend.style) {
      static NSString *  identifier = @"ghistoryFrendCell";   //这样避免群cell重用了单聊cell。导致头像碟在一起；
        groupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier  ];
        
        if (cell == nil) {
            cell = [[groupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier ];
        }
        
        if (cell.gestureRecognizers.count ==0) {
            UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(display:)];
            [cell addGestureRecognizer:longPre];
        }
        //现根据群id判断是否有这个群
        MyGroupDB * gldbModel = [[MyGroupDB alloc]init];
        [gldbModel createTable];
        
        NSArray *resarry =  [gldbModel search:friend.userId];
        
        if (0 == resarry.count) {
            //获取群组信息，以下在后台已经实现，不会执行
            
            [[GroupModule alloc] getGroupInfoWithID:friend.userId success:^(IMGroupEntity* group){
                NSLog(@"群组ID:%ld,群组名:%@,成员数:%d",(long)((IMGroupEntity*)group).ID,((IMGroupEntity*)group).name,((IMGroupEntity*)group).memberNumber);
                //   _groupName = ((IMGroupEntity*)group).name;
                //   _memberNumber = ((IMGroupEntity*)group).memberNumber;
                [gldbModel saveMygroup:((IMGroupEntity*)group).name groupId:(int)((IMGroupEntity*)group).ID];
                
                
            } failure:^(NSString *error){}];
            
            
            //发送请求群组成员，成功后读取数据库，合成头像
            [[GroupModule alloc] getGroupMemberListWithID:friend.userId success:^(NSArray *memberList) {
                //先清空群成员列表数据库
                GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
                [gmdb createTableWithGroupId:friend.userId];
                [gmdb deleteTable];
                
                //再存入群成员列表数据库
                BOOL creat1 = [gmdb createTableWithGroupId:friend.userId];
                if (creat1) {  //昵称， id，，头像，权限；创建者权限为1；
                    for(int j=1;j<memberList.count;j++){
                        UIImage * avatar = ((IMGroupMemberEntity *)memberList[j]).avatar;
                        
                        NSData* avatarData;
                        if (UIImagePNGRepresentation(avatar)) {
                            avatarData = UIImagePNGRepresentation(avatar);
                        }else {
                            avatarData = UIImageJPEGRepresentation(avatar, 1.0);
                        }
                        
                        [gmdb saveMygroupMember:((IMGroupMemberEntity*)memberList[j]).remark memberId:(int)((IMGroupMemberEntity *)memberList[j]).ID Icon:avatarData permit:((IMGroupMemberEntity*)memberList[j]).isManager];
                    }
                }
                [cell createIconWihgroupId:friend.userId];
            } failure:^(NSString *error) {}];
            
            
            
        }
        else {
            //数据库中有数据，直接合成头像,替换之前的头像
            [cell createIconWihgroupId:friend.userId];
        }
        
        cell.userId = friend.userId;
        cell.style = friend.style;    //群聊还是单聊
        
        
        [cell setCellValue:friend.nickName  lastMessage:friend.lastMessage icon:friend.icon time:friend.time chatStyle:friend.style];

    
    //读会话数据表中该发送者   显示小红点的个数
    [cell.hub setCount:friend.redCount];
    return cell;

    }
    
    else{
     static  NSString *identifier = @"historyFrendCell";
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier  ];
    
    if (cell == nil) {
        cell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier ];
    }
        
        if (cell.gestureRecognizers.count ==0) {
            UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(display:)];
            [cell addGestureRecognizer:longPre];
        }
    
   // NSString * time1 = @"12:12";
    
   // [cell.hub increment];
    
   // _allRedcount += friend.redCount;             //计算所有的小红点的个数
    cell.userId = friend.userId;
    cell.style = friend.style;    //群聊还是单聊
   
    
    [cell setCellValue:friend.nickName  lastMessage:friend.lastMessage icon:friend.icon time:friend.time chatStyle:friend.style];

    //读会话数据表中该发送者   显示小红点的个数
    [cell.hub setCount:friend.redCount];
    return cell;
}
}


//让置顶的cell颜色改变


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
{     // 重写UITableView的方法是分割线从最左侧开始
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    //让置顶的cell颜色改变
     historyHf *friend = self.result[indexPath.row];
    //手动设置一个默认的时间戳
     NSString *str=@"0";//时间戳
     NSTimeInterval time=[str doubleValue];//
     NSDate * detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
     if (detaildate != friend.topTime) {
         cell.backgroundColor  = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:235/255.0 alpha:1]; //天蓝色
     }else  cell.backgroundColor  = [UIColor clearColor];


}

//菜单

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
        
        //获取数据
        historyHf *friend = self.result[indexPath.row];
        
        
        [self.hfdbModel deleteFriendWithuserId:friend.userId style:friend.style];
        
        [self viewDidLoad];
        
    }
}

*/



/**
 *  长按cell时显示的menu配置
 *
 *  @param data longPre
 */
-(void)display:(UILongPressGestureRecognizer *)longPre{
    
    
    
    
    if (longPre.state ==UIGestureRecognizerStateBegan) {
        
        CGPoint location = [longPre locationInView:self.tableView];
        self.selectIndexPath = [self.tableView indexPathForRowAtPoint:location];
        historyHf *friend = self.result[self.selectIndexPath.row];
        
        //如果当前好友为置顶标志，则长按后将显示为移除置顶
        
        NSString *setTopFlag = @"移除置顶";
        //手动设置一个默认的时间戳
        NSString *str=@"0";//时间戳
        NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
        NSDate * detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        if (detaildate == friend.topTime) {
            setTopFlag = @"置顶";
        }

        
        //这里把cell做为第一响应(cell默认是无法成为responder,需要重写canBecomeFirstResponder方法)
        UITableViewCell *cell = (UITableViewCell *)longPre.view;
        [cell becomeFirstResponder];
        UIMenuItem *item1 = [[UIMenuItem alloc]initWithTitle:@"删除"action:@selector(delete1:)];
        UIMenuItem *item2 = [[UIMenuItem alloc]initWithTitle:setTopFlag action:@selector(ontop:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:item1, item2,  nil]];
        [menu setTargetRect:cell.frame inView:self.view];
        [menu setMenuVisible:YES animated:YES];
        
    }
}


//删除
-(void)delete1:(id)sender{
   // UITableViewCell * cell = (UITableViewCell *)[sender superview];
    
  //  NSLog(@"%@",cell);
    //NSIndexPath * path = [self.baseTableView indexPathForCell:cell];
   
   // NSLog(@"index row%ld", self.selectIndexPath.row);
    //获取数据
    historyHf *friend = self.result[self.selectIndexPath.row];
    [self.hfdbModel deleteFriendWithuserId:friend.userId style:friend.style];
    //NSLog(@"view:%@", [[[sender superview] superview] description]);
    [self refresh];

}

// 置顶与移除置顶
-(void)ontop:(id)sender{

    
    historyHf *friend = self.result[self.selectIndexPath.row];
    NSDate *myDate = [NSDate date];
    
    
    //手动设置一个默认的时间戳
    NSString *str=@"0";//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate * detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    if (detaildate == friend.topTime) {
        [self.hfdbModel setToptime:myDate withUserId:friend.userId style:friend.style];   //置顶

    } else [self.hfdbModel setToptime:detaildate withUserId:friend.userId style:friend.style];  //移除置顶
    
    //刷新界面
    [self refresh];

   
    
}
- (BOOL)canBecomeFirstResponder{
    return  YES;//注意这个一定要写
}



/**
 *  左右切换界面手势
 *
 *  @param data sender
 */
/*
- (void) tappedRightButton:(id)sender

{
    
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    
    
    NSArray *aryViewController = self.tabBarController.viewControllers;
    
    if (selectedIndex < aryViewController.count - 1) {
        
        UIView *fromView = [self.tabBarController.selectedViewController view];
        
        UIView *toView = [[self.tabBarController.viewControllers objectAtIndex:selectedIndex + 1] view];
        
        [UIView transitionFromView:fromView toView:toView duration:0.5f options:nil completion:^(BOOL finished) {
            
            if (finished) {
                
                [self.tabBarController setSelectedIndex:selectedIndex + 1];
                
            }
            
        }];
        
    }
    
    
    
}

*/
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
                             ((tabbarController *)self.tabBarController).selectbtn = ((tabbarController *)self.tabBarController).btn2;
                             ((tabbarController *)self.tabBarController).selectbtn.selected = YES;
                         }
                     }];
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

//点击cell跳转入聊天界面


//1.UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Storyboard2"bundle:nil];
//2.test2* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"test2"];
//3.[self.navigationController pushViewController:test2obj animated:YES];


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  UserInfoCell *cell = (UserInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
    
     //[tar.mytarbar removeFromSuperview];
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Second"bundle:nil];
    ChatViewController * test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"ChatView"];
    
    
    test2obj.hhId = cell.userId;
    test2obj.temTitle = cell.userNameLabel.text;
    test2obj.isGroupStyle = YES;
    test2obj.heImage = cell.headImage.image;  //，直接将头像传给界面，避免查询数据库
    if (1 == cell.style) {   //如果是单聊
        test2obj.isGroupStyle = NO;
        
    }
    
    [self.navigationController pushViewController:test2obj animated:YES];
    
   // [self presentViewController:test2obj animated:YES completion:^{
    //     }];
     //self.hidesBottomBarWhenPushed=NO;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];         //取消点击效果
}


/*

 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //做一个类型的转换
    UITableViewCell *cell = (UITableViewCell *)sender;
    
    //通过tableView获取cell对应的索引，然后通过索引获取实体对象
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    //获取数据
       HistoryFrirend *friend = self.result[indexPath.row];
    
    //通过segue来获取我们目的视图控制器
    UIViewController *nextView = [segue destinationViewController];
    
    
    //通过KVC把参数传入目的控制器
    [nextView setValue:friend.nickname forKey:@"sendUserName"];
   // [nextView setValue:friend. forKey:@"jidStr"];
    
   // FriendModelClass *historyFriend = [[FriendModelClass alloc] init];
   // [historyFriend saveHistoryFriend:friend.nickname WithJid:friend.jidStr];
    [self viewDidLoad];
}*/


- (void)adddata {
    
    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES ];
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
      //  logoutItem.foreColor = [UIColor redColor];
      //  logoutItem.alignment = NSTextAlignmentCenter;
    //    UIImage *image = [UIImage imageNamed:@"a_h.png"];
        
    
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


//界面即将出现时
-(void)viewWillAppear:(BOOL)animated{
    
    //self.result =  [_hfdbModel  queryAll];
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:NO];
    
   // [(( tabbarController *)self.tabBarController).hub1 increment];   //经验证该方法有效
    BOOL create = [_hfdbModel createTable];
    
    if (create) {
        self.result =  [_hfdbModel  queryAll];
    }
    
    [self.tableView reloadData];              //界面即将出现时刷新界面
    // 计算 所有 小红点的个数 显示在气泡数上
    
    if (create) {
        _allRedcount =  [_hfdbModel  countAllred];
    }
    
 
     [(( tabbarController *)self.tabBarController).hub1 setCount:_allRedcount];   //经验证该方法有效
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
}

-(void)dealloc {

[[NSNotificationCenter defaultCenter] removeObserver:self name:IMNotificationReceiveMessage object:nil];
    
}

-(void)refresh {    //收到通知刷新界面
    
    self.result =  [_hfdbModel  queryAll];
    [self.tableView reloadData];
    
    //此处遍历会话表，获取小红点总数，应为当在它的其它三个平行界面时，无法进行tableview的刷新，就不能获取总数
    BOOL create = [_hfdbModel createTable];
    
    if (create) {
        _allRedcount =  [_hfdbModel  countAllred];
    }
    
    
    
    [(( tabbarController *)self.tabBarController).hub1 setCount:_allRedcount];   //经验证该方法有效
}




@end
