//
//  GroupListTableViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/3.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "GroupListTableViewController.h"
#import "MBProgressHUD+NJ.h"
#import "MyGroupDB.h"
#import "MyGroupModel.h"
#import "MyGroupListCell.h"
#import "NewFriendTableViewCell.h"
#import "UILabel+MyLable.h"
#import "Person.h"
#import "tabbarController.h"
#import "ChatViewController.h"
#import "GroupModule.h"
#import "IMGroupEntity.h"
#import "IMGroupMemberEntity.h"
#import "GroupMemeberDb.h"
#import "GroupMemeberModel.h"
#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import "YCXMenu.h"//#import "LoginViewController.h"

@interface GroupListTableViewController ()

@property (strong, nonatomic) NSArray *result;
@property (strong, nonatomic) MyGroupDB *gldbModel;

-(void)setExtraCellLineHidden: (UITableView *)tableView;

@end

@implementation GroupListTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setExtraCellLineHidden:self.tableView];
    
 
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//使分隔线可以调整
    [self.tableView setSeparatorColor:[UIColor grayColor]];  //设置分隔线的颜色
   
    [self setExtraCellLineHidden:self.tableView];//隐藏多余的分割线
    
    _gldbModel = [[MyGroupDB alloc]init];
    
    //获取服务器群列表
  
    [[GroupModule instance] getGroupListSuccess:^(NSArray* groupList){
     //   NSLog(@"群组数：%d",[groupList[0] intValue]);
    //    NSLog(@"首个群组ID:%ld,群组名:%@,成员数:%d",(long)((IMGroupEntity*)groupList[1]).ID,((IMGroupEntity*)groupList[1]).name,((IMGroupEntity*)groupList[1]).memberNumber);
      if (groupList.count > 1) {     //当返回数组中群列表不为空
            
            
            BOOL create = [_gldbModel createTable];
            if (create) {
                //先删除原数据表，再将新的数据存入
                [_gldbModel deleteTable];
                [_gldbModel createTable];
                for(int i=1;i<groupList.count;i++){
                    
                    int groupId = (int)((IMGroupEntity*)groupList[i]).ID;
                   
                    [_gldbModel saveMygroup:((IMGroupEntity*)groupList[i]).name groupId:(int)((IMGroupEntity*)groupList[i]).ID];
                    
       
                    
                    [[GroupModule alloc] getGroupMemberListWithID:groupId success:^(NSArray *memberList) {
                    //    NSLog(@"群成员数：%d",[memberList[0] intValue]);
                   //     NSLog(@"首个成员ID:%ld,备注:%@,权限:%d",(long)((IMGroupMemberEntity *)memberList[1]).ID,((IMGroupMemberEntity*)memberList[1]).remark,((IMGroupMemberEntity*)memberList[1]).isManager);
                  //      NSLog(@"2号成员ID:%ld,备注:%@,权限:%d",(long)((IMGroupMemberEntity *)memberList[2]).ID,((IMGroupMemberEntity*)memberList[2]).remark,((IMGroupMemberEntity*)memberList[2]).isManager);
                        //先清空群成员列表数据库
                        GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
                        [gmdb createTableWithGroupId:groupId];
                        [gmdb deleteTable];
                      
                        //再存入群成员列表数据库
                       BOOL creat1 = [gmdb createTableWithGroupId:groupId];
                        if (creat1) {  //昵称， id，，头像，权限；创建者权限为1；
                            for(int j=1;j<memberList.count;j++){
                                UIImage * avatar = ((IMGroupMemberEntity *)memberList[j]).avatar;
                                if (nil == avatar) {
                                    avatar = [UIImage imageNamed:@"tn.9.png"];
                                }
                                NSData* avatarData;
                                if (UIImagePNGRepresentation(avatar)) {
                                    avatarData = UIImagePNGRepresentation(avatar);
                                }else {
                                    avatarData = UIImageJPEGRepresentation(avatar, 1.0);
                                }

                            [gmdb saveMygroupMember:((IMGroupMemberEntity*)memberList[j]).remark memberId:(int)((IMGroupMemberEntity *)memberList[j]).ID Icon:avatarData permit:((IMGroupMemberEntity*)memberList[j]).isManager];
                        }
                        }
                        
                         [self.tableView reloadData];
                    } failure:^(NSString *error) {}];
        
                    
                           }

            }
        }
        _result =  [_gldbModel  queryAll];
        [self.tableView reloadData];
    } failure:^(NSString* error){
    

    }];
    
    
    
    
    
    BOOL create = [_gldbModel createTable];
    
    if (create) {
        _result =  [_gldbModel  queryAll];
    }
    
    
    
    [self createTopView];
   
    [self.tableView reloadData];
    
}


    
    
    
    


- (void)createTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 47)];
    UILabel *label = [UILabel initWithText:@"我的群组" withFontSize:16 WithFontColor:[UIColor blueColor] WithMaxSize:CGSizeMake(100, 20)];
    label.textAlignment = NSTextAlignmentLeft;
    label.frame = CGRectMake(15, 20, 220, 20);
    [topView addSubview:label];
    
    topView.backgroundColor = [UIColor whiteColor];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:line];
    
    self.tableView.tableHeaderView = topView;
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
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 40)];
        view.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        [view addSubview:label];
        
        return view;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyGroupModel *groupList = self.result[indexPath.row];
    
    
    
    static NSString *identifier = @"gruopListCell";
    MyGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    
    if (cell == nil) {
        cell = [[MyGroupListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.groupId = groupList.groupId;
    cell.groupNameLabel.text = groupList.myGroupName;
     cell.icon = [cell createIconWihgroupId:groupList.groupId];     //创建头像
    
    
    return cell;
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
        //获取cell数据
        MyGroupListCell *cell = (MyGroupListCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        // 初始化
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除？"preferredStyle:UIAlertControllerStyleAlert];
        
        // 分别2个创建操作
        UIAlertAction *neverAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [MBProgressHUD showMessage:@"正在拼命加载ing...."];
            
          [[ContactModule instance] deleteContact:cell.userId
                                            success:^(){
                                                [_gldbModel deleteGroupWithId:cell.groupId];
                                                [self.hfdbModel deleteFriendWithuserId:cell.groupId];  //删除会话记录
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

     //   [_gldbModel deleteGroupWithId:];
        
        [self viewDidLoad];
        
    }
}


*/

#pragma mark - Navigation

//点击cell跳转入聊天界面


//1.UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Storyboard2"bundle:nil];
//2.test2* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"test2"];
//3.[self.navigationController pushViewController:test2obj animated:YES];

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选中将直接进入聊天界面
    
    MyGroupListCell *cell = (MyGroupListCell *)[tableView cellForRowAtIndexPath:indexPath];
    //将群ID与群名传给聊天界面
    
    //跳转进入聊天界面,先返回到会话界面，仔由会话界面，跳转到聊天界面
    
    //在聊天界面中，将会根据显示的是群聊还是单聊，分别显示不同的用户图形
    
    
    
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    
    ((tabbarController *)self.tabBarController).selectbtn.selected = NO;
    ((tabbarController *)self.tabBarController).selectbtn = ((tabbarController *)self.tabBarController).btn1;
    ((tabbarController *)self.tabBarController).selectbtn.selected = YES;
    
    
    UINavigationController *nav = (UINavigationController *)((tabbarController *)self.tabBarController).viewControllers[0];
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Second"bundle:nil];
    ChatViewController * test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"ChatView"];
    
    test2obj.temTitle = cell.groupNameLabel.text;
    test2obj.hhId = cell.groupId;
    test2obj.isGroupStyle = YES; //是群聊
    test2obj.heImage = cell.icon;//空值
    
    [nav pushViewController:test2obj animated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];  //执行此处将销毁控制器 所以要放在尾部

    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    // self.hidesBottomBarWhenPushed=YES;
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:YES];
    
    
  //  self.result =  [_imdbModel  queryAll];
   // [self.tableView reloadData];              //界面即将出现时刷新界面
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