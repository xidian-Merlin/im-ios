//
//  SearchFriResultController.m
//  ios约束版
//
//  Created by tongho on 16/8/5.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "SearchFriResultController.h"
#import "historyHf.h"
#import "TimeConvert.h"
#import "UILabel+MyLable.h"
#import "SearchFriResultCell.h"
#import "IMUserEntity.h"
#import "ShowMessageTableViewController.h"
#import "GetUserInfoAPI.h"
#import "ContactModule.h"


#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import "YCXMenu.h"//#import "LoginViewController.h"

@interface SearchFriResultController ()


@property (strong, nonatomic) UITableView *friendTableView;

-(void)setExtraCellLineHidden: (UITableView *)tableView;
- (void)createTableView;

@end

@implementation SearchFriResultController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self  createTableView];                           //临时数据，不需要读数据库表
    
    [self setExtraCellLineHidden:_friendTableView];
    
    
    
    [self setExtraCellLineHidden:self.friendTableView];//隐藏多余的分割线

      [self.friendTableView reloadData];
    
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
    UILabel *label = [UILabel initWithText:@"搜索结果列表" withFontSize:16 WithFontColor:[UIColor blueColor] WithMaxSize:CGSizeMake(100, 20)];
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


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForFooterInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.friendTableView.frame), 40)];
    view.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [view addSubview:label];
    
    return view;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    static NSString *identifier = @"searchFrendCell";
    SearchFriResultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    
    if (cell == nil) {
        cell = [[SearchFriResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //    NSLog(@"搜索到用户数目：%lu",(unsigned long)userArray.count);
    //    NSLog(@"首个用户ID：%ld",(long)((IMUserEntity*)userArray[0]).ID);
    //   NSLog(@"首个用户名：%@",((IMUserEntity*)userArray[0]).name);
    //   NSLog(@"首个用户昵称：%@",((IMUserEntity*)userArray[0]).nick);
    //   NSLog(@"第二个用户ID：%ld",(long)((IMUserEntity*)userArray[1]).ID);
    //   NSLog(@"第二个用户名：%@",((IMUserEntity*)userArray[1]).name);
    //   NSLog(@"第二个用户昵称：%@",((IMUserEntity*)userArray[1]).nick);
    
  //  UIImageView *imageView NS_AVAILABLE_IOS(3_0);   // default is nil.  image view will be created if necessary.
    
  //  @property (nonatomic, readonly, strong, nullable) UILabel *textLabel NS_AVAILABLE_IOS(3_0);   // default is nil.  label will be created if necessary.
   // @property (nonatomic, readonly, strong, nullable) UILabel *detailTextLabel NS_AVAI
    
    cell.userId = (int)((IMUserEntity*)_result[indexPath.row]).ID;
    
    cell.headImage.image = ((IMUserEntity*)_result[indexPath.row]).avatar;
    cell.userNameLabel.text = ((IMUserEntity*)_result[indexPath.row]).nick;
    cell.lastMessage.text = ((IMUserEntity*)_result[indexPath.row]).name;
    
    
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




#pragma mark - Navigation

//点击cell跳转入聊天界面


//1.UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Storyboard2"bundle:nil];
//2.test2* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"test2"];
//3.[self.navigationController pushViewController:test2obj animated:YES];

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchFriResultCell *cell = (SearchFriResultCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    //点击此处，将cell的值传给队员的控制器，显示查询好友信息的结果表
    
    // 获取用户信息测试
    [[ContactModule instance]GetUserInfo:cell.userId success:^(IMUserEntity *user){
        NSLog(@"首个用户名：%@",user.name);
        NSLog(@"首个用户昵称：%@",user.nick);
        
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
        ShowMessageTableViewController * test2obj = [secondStoryBoard           instantiateViewControllerWithIdentifier:@"showMessageController"];
        
        test2obj.userId = cell.userId;
        test2obj.userName = user.name;
        test2obj.nickName = user.nick;
        test2obj.nickkName2 = user.nick;
        test2obj.icon = user.avatar;
        [self.navigationController pushViewController:test2obj animated:YES];
        
    } failure:^(NSString* error){
        
    }];
    
    
   
    
    
    // [self presentViewController:test2obj animated:YES completion:^{
    //     }];
    //self.hidesBottomBarWhenPushed=NO;
    
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];         //取消点击效果
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    // self.hidesBottomBarWhenPushed=YES;
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:YES];
    
    
 //   self.result =  [_imdbModel  queryAll];
    [self.friendTableView reloadData];              //界面即将出现时刷新界面
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
