//
//  NewFriendTableViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/3.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "NewFriendTableViewController.h"
//#import "ImdbModel.h" //此处将被修改，选择新的数据库建表模型
#import "historyHf.h"
#import "HfDbModel.h"
#import "IMConstant.h"
#import "NewFriendDb.h"
#import "ImdbModel.h"
#import "TimeConvert.h"
#import "NewFriendTableViewCell.h"
#import "UILabel+MyLable.h"
#import "Person.h"
#import "ReVeriController.h"
#import "ShowMessageTableViewController.h"
#import "MBProgressHUD+NJ.h"
#import "ContactModule.h"
#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import "YCXMenu.h"//#import "LoginViewController.h"

@interface NewFriendTableViewController ()

@property (strong, nonatomic) NSArray *result;
@property (strong, nonatomic) UITableView *friendTableView;


@property (strong, nonatomic) NewFriendDb *nfdbModel;

-(void)setExtraCellLineHidden: (UITableView *)tableView;
- (void)createTableView;

@end

@implementation NewFriendTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self  createTableView];
    
    [self setExtraCellLineHidden:_friendTableView];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//使分隔线可以调整
    [self.tableView setSeparatorColor:[UIColor grayColor]];  //设置分隔线的颜色
    
    [self setExtraCellLineHidden:self.tableView];//隐藏多余的分割线
    
    //设置监听：
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:IMNotificationReceiveFriendRequest   //好友请求
                                               object:nil];
    
    
    _nfdbModel = [[NewFriendDb alloc]init];
   
    
    
    BOOL create = [_nfdbModel createTable];
    
    if(create){
    self.result =  [_nfdbModel  queryAll];
    
    }
    
    // _historyFirend = [[FriendModelClass alloc] init];
    // self.result = [_historyFirend queryAll];
    
    
    NSLog(@"%@",self.result);
    [self.tableView reloadData];
    
}

- (void)createTableView {
    
    self.friendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    self.friendTableView.delegate =self;
    self.friendTableView.dataSource = self;
    self.friendTableView.showsVerticalScrollIndicator = NO;
    // self.friendTableView.separatorStyle = 0;
    self.friendTableView.rowHeight = 60;
    self.friendTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//使分隔线可以调整
    [self.friendTableView setSeparatorColor:[UIColor grayColor]];  //设置分隔线的颜色
    
    
    
    
    [self.view addSubview:self.friendTableView];
    
    [self createTopView];
    
}

- (void)createTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 47)];
    UILabel *label = [UILabel initWithText:@"新的朋友" withFontSize:16 WithFontColor:[UIColor blueColor] WithMaxSize:CGSizeMake(100, 20)];
    label.textAlignment = NSTextAlignmentLeft;
    label.frame = CGRectMake(15, 20, 220, 20);
    [topView addSubview:label];
    
    topView.backgroundColor = [UIColor whiteColor];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:line];
    
    self.friendTableView.tableHeaderView = topView;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 60;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    historyHf *friend = self.result[indexPath.row];
    
    
    
    static NSString *identifier = @"newFrendCell";
    NewFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    
    if (cell == nil) {
        cell = [[NewFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
     __weak __block NewFriendTableViewCell *copy_cell = cell;
    cell.selectBlock = ^(BOOL isSelec){              //将cell中按钮的点击情况传给控制器
        if (isSelec) {
            
           //发送添加包
            [MBProgressHUD showMessage:@"正在拼命加载..."];
            
            [[ContactModule instance]  replyRequest:friend.userId
                                          replyCode:0
                                               text:@"我通过了你的验证请求，现在可以聊天了"
                                            success:^(){
                                                
                                                copy_cell.selectBtn.hidden = YES;
                                                copy_cell.bSelectBtn.hidden = NO;
                                                
                                                
                                                //将选中标志存入数据库，flag ＝1；
                                                NSString *cerify = [NSString stringWithFormat:@"SET agreeFlag = ? WHERE agreeFlag = ? AND userId = %d", friend.userId];
                                                
                                                
                                                [_nfdbModel set:0 tonewFlag:1 withCerify:cerify];
                                                [MBProgressHUD hideHUD];
                                                [MBProgressHUD showSuccess:@"添加成功"];
                                                NSString *test = @"你已经添加了对方";
                                                
                                                NSDate *time = [NSDate date];
                                                // 添加成功，存入联系人
                                                NSLog(@"添加成功，存入联系人!");
                                                ImdbModel* imdbModel = [[ImdbModel alloc] init];
                                                BOOL create = [imdbModel createTable];
                                                if (create) {
                                                    [imdbModel saveHistoryFriend:friend.nickName userId:friend.userId nickName:friend.nickName1 remakeName:friend.nickName2  lastMessage:test icon:friend.icon tel:(NSString *)@"未知" email:(NSString *)@"未知"];
                                                }
                                                NSLog(@"添加成功，存入联系人!");
                                                [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationNewContact object:nil];
                                                // 存入历史会话
                                                NSLog(@"添加成功，存入历史会话!");
                                                HfDbModel* hfDbModel = [[HfDbModel alloc] init];
                                                BOOL create1 = [hfDbModel createTable];
                                            if (create1) {
                                                    [hfDbModel saveHistoryFriend:friend.nickName2 lastMessage:test icon:friend.icon time:time userId:friend.userId redCount:(int)1 style:1];
                                                }
                                                [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:nil];
                                                
                                                
                                                
                                                
                                            }failure:^(){
                                                    [MBProgressHUD hideHUD];
                                                    [MBProgressHUD showError:@"添加失败"];
                                            }];
            
            
            
        }
        
    };
    
    //如果从数据库中读取的标志为已添加，那么，隐藏selecrBtn  ,显示bselect
    if (1 == friend.agreeFlag) {
        cell.selectBtn.hidden = YES;
        cell.bSelectBtn.hidden = NO;
    }
    //flag= 2;  为待验证，，隐藏selecrBtn  ,显示bselect，修改它的text为待验证
    else if (2 == friend.agreeFlag) {
        cell.selectBtn.hidden = YES;
        cell.bSelectBtn.hidden = NO;
        [cell.bSelectBtn setTitle:@"待验证" forState:UIControlStateNormal];
        
    }
    else {
    
        cell.selectBtn.hidden = NO;
        cell.bSelectBtn.hidden = YES;
    }
    
    
    cell.userId = friend.userId;
    cell.userName = friend.nickName;
    cell.remarkName = friend.nickName2;  //备注
    cell.icon = friend.icon;
    cell.agreeFlag = friend.agreeFlag;
    
    [cell setCellValue:friend.nickName2  lastMessage:friend.lastMessage icon:friend.icon ];
    
    return cell;
}


//下述的两个方法要一起使用，才可以让自定义分割线从最左侧开始

-(void)viewDidLayoutSubviews
{
    // 重写UITableView的方法是分割线从最左侧开始
    if ([self.friendTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.friendTableView  setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.friendTableView  respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.friendTableView  setLayoutMargins:UIEdgeInsetsZero];
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
        
        [self.nfdbModel deleteFriendWithuserId:friend.userId];
        
        [self viewDidLoad];
        
    }
}




#pragma mark - Navigation

//点击cell跳转入聊天界面


//1.UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Storyboard2"bundle:nil];
//2.test2* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"test2"];
//3.[self.navigationController pushViewController:test2obj animated:YES];

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果flag标志为已添加flag ＝ 1，那么点击后进入详细信息界面，否则进入再次请求验证界面
    
    
     NewFriendTableViewCell *cell = (NewFriendTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]; //获取cell
  
    
    if (1 == cell.agreeFlag){   //已经同意，进入详细信息界面
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
      ShowMessageTableViewController* test2obj2 = [secondStoryBoard instantiateViewControllerWithIdentifier:@"showMessageController"];
    //将cell的值传给test2object
    
    test2obj2.userId =  cell.userId ;
    test2obj2.userName = cell.userName ;
    test2obj2.nickName = cell.remarkName;  //备注
    test2obj2.nickkName2 = cell.remarkName;

        
    test2obj2.icon = [UIImage imageWithData:cell.icon];
    
    
      [self.navigationController pushViewController:test2obj2 animated:YES];
    
    
    }
    else  {             //否则，进入继续验证界面
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
        ReVeriController* test2obj1 = [secondStoryBoard instantiateViewControllerWithIdentifier:@"ReVeri"];
        //将cell的值传给test2object
        
        test2obj1.userId =  cell.userId ;
        test2obj1.userName1 = cell.userName ;
        test2obj1.remarkName1 = cell.remarkName;  //备注
        test2obj1.icon1 = cell.icon;
        
        
        [self.navigationController pushViewController:test2obj1 animated:YES];
    }
    //[tar.mytarbar removeFromSuperview];
   // UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Second"bundle:nil];
  //  ChatViewController * test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"ChatView"];
    
    
  //  [self.navigationController pushViewController:test2obj animated:YES];
    
    // [self presentViewController:test2obj animated:YES completion:^{
    //     }];
    //self.hidesBottomBarWhenPushed=NO;
}



-(void)viewWillAppear:(BOOL)animated{
    
    // self.hidesBottomBarWhenPushed=YES;
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:YES];
    
    self.result =  [_nfdbModel  queryAll];
    [self.tableView reloadData];              //界面即将出现时刷新界面
    
    self.navigationController.navigationBarHidden = NO;
    //   view.frame=CGRectMake(0, 480, 0, 0);
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:NO];
    
    //在界面即将消失时，将所有的新的好友的isread值变为1，表示已读
    
    [_nfdbModel set:0 tonewFlag:1 withCerify:@"SET isread = ? WHERE isread = ?"];
    
    
    
    
    
    // self.navigationController.navigationBarHidden = YES;
}



-(void)refresh {
    
     self.result =  [_nfdbModel  queryAll];
    [self.tableView reloadData];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMNotificationReceiveFriendRequest object:nil];
    
}


@end
