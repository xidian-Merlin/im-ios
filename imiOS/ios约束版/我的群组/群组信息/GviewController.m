//
//  ViewController.m
//  WeChatGroupInfo
//
//  Created by hackxhj on 15/10/19.
//  Copyright © 2015年 hackxhj. All rights reserved.
//

#import "GviewController.h"
#import "ChatViewController.h"
#import "TopViewController.h"
#import "GroupInfoCell.h"
#import "SelectFriendViewController.h"
#import "GroupMemeberModel.h"
#import "GroupMemeberDb.h"
#import "ImdbModel.h"
#import "GroupModule.h"
#import "CreatGroupAPI.h"
#import "MBProgressHUD+NJ.h"
#import "MyGroupDB.h"
#import "SetMyGRemarkViewController.h"
#import "ReNameGroupViewController.h"
#import "IMGroupMemberEntity.h"
#import "Person.h"


#define mainHeight     [[UIScreen mainScreen] bounds].size.height
#define mainWidth      [[UIScreen mainScreen] bounds].size.width


@interface GviewController ()<UITableViewDataSource,UITableViewDelegate,TopViewControllerDelagate>

//@property (strong, nonatomic)  SelectFriendViewController * selcontroller;
@property (assign, nonatomic) int memberNumber;
@property (assign,nonatomic) int nowUserId;
@property (copy ,nonatomic) NSString *myRemarkName;
@property (strong, nonatomic) rootBlock rootblock;


@end

@implementation GviewController
{
     UITableView *_showTable;
     TopViewController *_topview;
     UIButton *_sendBtn;
     NSMutableArray *_groupAll;
     NSMutableArray *_arrPer;
     BOOL isDel;
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    

    //查询成员数据库，获取我的备注
    
    // 1.获得Documents的全路径
    NSString *nowDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *nowPath = [nowDoc stringByAppendingPathComponent:@"nowUser.data"]; //扩展名可以自己定义
    
    // 3.从文件中读取MJStudent对象，将nsdata转成对象
    Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];
    
    _nowUserId = [nowUser.userId intValue] ;
    
    
        self.navigationController.navigationBar.translucent = NO;
  //  [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
  //  [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
  // */
}

-(void)initCreateData
{
    _groupAll=[NSMutableArray new];
    _arrPer=[NSMutableArray new];
    
    NSArray *arr1=@[@"群聊名称",@"群聊人数"];
    NSArray *arr2=@[@"消息免打扰"];
    NSArray *arr4=@[@"我在本群的备注"];
    NSArray *arr5=@[@"清空聊天记录"];
    [_groupAll addObject:arr1];
    [_groupAll addObject:arr2];
    [_groupAll addObject:arr4];
    [_groupAll addObject:arr5];
    
    //先搜索服务器数据， 若没有再搜索我的群组成员数据库
   __block  NSArray *result1 = [NSArray array];
   [[GroupModule alloc] getGroupMemberListWithID:_groupId success:^(NSArray *memberList) {
        NSLog(@"群成员数：%d",[memberList[0] intValue]);
        NSLog(@"首个成员ID:%ld,备注:%@,权限:%d",(long)((IMGroupMemberEntity *)memberList[1]).ID,((IMGroupMemberEntity*)memberList[1]).remark,((IMGroupMemberEntity*)memberList[1]).isManager);
        NSLog(@"2号成员ID:%ld,备注:%@,权限:%d",(long)((IMGroupMemberEntity *)memberList[2]).ID,((IMGroupMemberEntity*)memberList[2]).remark,((IMGroupMemberEntity*)memberList[2]).isManager);
        
        //先清空群成员列表数据库
        GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
        [gmdb createTableWithGroupId:_groupId];
        [gmdb deleteTable];
        
        //再存入群成员列表数据库
        BOOL creat1 = [gmdb createTableWithGroupId:_groupId];
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

       //将结果放入新的模型中去，将模型添加到数组
       
       GroupMemeberDb *groupdb = [[GroupMemeberDb alloc]init];
       
       BOOL creat = [groupdb createTableWithGroupId:_groupId];
       
       if (creat) {
           result1 = [groupdb queryAll];
       }

    } failure:^(NSString *error) {}];
  
    
    //将结果放入新的模型中去，将模型添加到数组
    
    GroupMemeberDb *groupdb = [[GroupMemeberDb alloc]init];
    
    BOOL creat = [groupdb createTableWithGroupId:_groupId];
    
    if (creat) {
        result1 = [groupdb queryAll];
    }

    
    
    
    for (GroupMemeberModel* model in result1) {
    PersonModel *pm=[[PersonModel alloc]init];
    
    pm.friendId = model.memberId;
    pm.userName = model.memberName;
    pm.txicon = [UIImage imageWithData:model.icon];
    
    
    [_topview addOneTximg:pm];
    [_arrPer addObject:pm];
    
    }
    
 /*
    
    PersonModel *pm1=[[PersonModel alloc]init];
    pm1.friendId=@"1";
    pm1.userName=@"张三";
    pm1.txicon=[UIImage imageNamed:@"qq1"];
    
    
    
   
    [_topview addOneTximg:pm1];
    
    [_arrPer addObject:pm1];
  */

    [self setTopViewFrame:_arrPer];
    
}

// 设置topview的高度变化
-(void)setTopViewFrame:(NSArray*)allP
{
    int lie=0;
    if([UIScreen mainScreen].bounds.size.width>320)
    {
        lie=5;
    }else
    {
        lie=4;
    }
    int Allcount=(int)allP.count+2;
    int line=Allcount/lie;
    if(Allcount%lie>0)
        line++;
    _topview.view.frame=CGRectMake(0, 0, mainWidth, line*90);
    _showTable.tableHeaderView=_topview.view;
}


-(void)initMyView
{
    self.title=@"群资料";
    //添加左边返回的按钮
    
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
    Button.frame = CGRectMake(0, 0, 30, 30);
    [Button setBackgroundImage:[UIImage imageNamed:@"zq.png"] forState:UIControlStateNormal];
    [Button addTarget:self action:@selector(returnChat:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:Button];
    self.navigationItem.leftBarButtonItem = ButtonItem;
    
    
   // _showTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 1, mainWidth, mainHeight)];
    _showTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight) style:UITableViewStylePlain];
    _showTable.delegate=self;
    _showTable.dataSource=self;
    _showTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//使分隔线可以调整
    self.view.backgroundColor = [UIColor grayColor];
    [_showTable setSeparatorColor:[UIColor grayColor]];  //设置分隔线的颜色

    _showTable.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"uitableviewbackground"]];
    [self.view addSubview:_showTable];
    
    _topview=[[TopViewController alloc]initWithNibName:@"TopViewController" bundle:nil];
    _topview.groupId = _groupId;
    _topview.delagate=self;
    _topview.view.frame=CGRectMake(0, 0, mainWidth, 90);
    _topview.isGroupM=YES;
    _showTable.tableHeaderView=_topview.view;
    

    
    UIView *txtfootview=[[UIView alloc]init];
    txtfootview.frame=CGRectMake(0, 0, mainWidth,100);
    txtfootview.backgroundColor=[UIColor clearColor];
    UIButton *btnRegis=[[UIButton alloc]initWithFrame:CGRectMake(10, 40,mainWidth-20, 44)];
    UIImage *buttonImageRegis=[UIImage imageNamed:@"deletebtn"];
    UIImage *stretchableRegister=[buttonImageRegis stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [btnRegis.layer setMasksToBounds:YES];
    [btnRegis.layer setCornerRadius:3];
    [btnRegis setBackgroundImage:stretchableRegister forState:UIControlStateNormal];
    btnRegis.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:19.0];
    [btnRegis setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [btnRegis setTitle:@"删除并退出" forState:0];
    [btnRegis setTitleColor:[UIColor whiteColor] forState:0];
      [btnRegis addTarget:self action:@selector(regis:) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn=btnRegis;
    [txtfootview addSubview:_sendBtn];
    _showTable.tableFooterView=txtfootview;
}


-(void)returnChat:(id)sender{

    [self dismissViewControllerAnimated:YES completion:nil];

}


-(void)regis:(id)sender {

   // NSLog(@"我退出了该群");
    
    // 退出群组测试
  
    [MBProgressHUD showMessage:@"正在拼命加载..."];
    [[GroupModule instance]quitGroupWithGroupID:_groupId success:^(){
        NSLog(@"推出群组成功");
        [MBProgressHUD hideHUD];
        //删除该群的成员列表
        GroupMemeberDb *member = [[GroupMemeberDb alloc]init];
         [member deleteTable];
        
        
        
        //删除群列表中的该群
        MyGroupDB *groupdb = [[MyGroupDB alloc]init];
        
        [groupdb deleteGroupWithId:_groupId];
       //删除该群的会话显示
        
        //返回根界面
        
        [self dismissViewControllerAnimated:YES completion:^{
            _rootblock(1);
        }];
        
      

     //  [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        
    } failure:^(NSString* error){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"退出失败!"];
    }];
    
    //返回跟界面


}

-(void)setrootBlock:(rootBlock)block{
    self.rootblock = block;
    

}



#pragma  mark topview delagate 邀请加群;
-(void)addBtnClick
{
    NSLog(@"add btn click!");
    
    
       SelectFriendViewController *selcontroller = [[SelectFriendViewController alloc] init];
    
       selcontroller.groupId = _groupId;
    
      [self.navigationController pushViewController:selcontroller animated:YES];

    [selcontroller setNewMember:^(NSArray *newMember) {   //回传好友id
    
         ImdbModel *friendList = [[ImdbModel alloc]init];
        BOOL creat2 = [friendList createTable];
        for (NSNumber *userId in newMember) {
            //在我的好友列表中搜索ID ，得到好友的详细信息，将结果加入数组中
            if (creat2) {
              NSArray *res = [friendList search:[userId intValue]];
                
                PersonModel *pmqq=[[PersonModel alloc]init];
                pmqq.friendId = ((GroupMemeberModel *) res[0]).memberId;
                pmqq.userName = ((GroupMemeberModel *) res[0]).memberName;
                pmqq.txicon = [ UIImage  imageWithData:((GroupMemeberModel *)res[0]).icon];
                [_topview addOneTximg:pmqq];
                [_arrPer addObject:pmqq];
            }
            
            
        }
          //将数组中的ID提取出来，分别获取它们的信息，放入personmodel，再加入view的显示数组中
        //  NSString *randomfid=[NSString stringWithFormat:@"%d",rx];
        //  pmqq.friendId=randomfid;
        //  pmqq.userName=@"默认";
        //  pmqq.txicon=[UIImage imageNamed:@"qq"];
        
        [self setTopViewFrame:_arrPer];
        //添加的时候取消删除模式
        if(isDel==YES)
            [self subBtnClick];
    
    }];
    
    
    
    if(isDel==YES)
        [self subBtnClick];

}




#pragma  mark delagate 点击进入编辑模式
-(void)subBtnClick
{
    if(isDel==NO)
    {
        [_topview isInputDelMoudle:YES];
        isDel=YES;
    }else
    {
        [_topview isInputDelMoudle:NO];
        isDel=NO;
    }
}


#pragma  mark  delagate  踢出群
-(void)delDataWithStr:(PersonModel*)person
{
    
    //在此处执行是否真的踢出群
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定踢出？"preferredStyle:UIAlertControllerStyleAlert];
    
    // 分别2个创建操作
    UIAlertAction *neverAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
     //   [self.tabBarController.navigationController popToRootViewControllerAnimated:YES ];//退出总的导航控制器
       
        NSLog(@"删除的用户--%d",person.friendId);
        [_topview delOneTximg:person];
        [_arrPer removeObject:person];
        [self setTopViewFrame:_arrPer];

        
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



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_groupAll[section]count] ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _groupAll.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 6;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *idfCell=@"grouptopcell";
    GroupInfoCell *topcell=(GroupInfoCell*)[tableView dequeueReusableCellWithIdentifier:idfCell];
    if(topcell==nil)
    {
        topcell=[[[NSBundle mainBundle]loadNibNamed:@"GroupInfoCell" owner:self options:nil] lastObject];
    }
    topcell.titleShow.text=_groupAll[indexPath.section][indexPath.row];
    
    
    if(indexPath.section==0 || indexPath.section == 2)//名字标签的显示
    {
        topcell.nameShow.hidden=NO;
    }else
    {
        topcell.nameShow.hidden=YES;
    }
    if((indexPath.section==0&&indexPath.row == 0)||indexPath.section==2)//此行要显示点击
    {
        topcell.clickimg.hidden=NO;
    }else
    {
        topcell.clickimg.hidden=YES;
    }
    if(indexPath.section==1)//要显示开关按钮
    {
        topcell.switchClickimg.hidden=NO;
    }
    else{
        topcell.switchClickimg.hidden=YES;
    }
    
    //以上控制显示和不显示的控件
    
    if(indexPath.section==0&&indexPath.row==0)
    {
        topcell.nameShow.text=_groupName;
    }
    
    
    if(indexPath.section==0&&indexPath.row==1)
    {
        topcell.nameShow.text=[NSString stringWithFormat:@"%d人",_memberNumber];
    }
    if(indexPath.section==2)
    {
        topcell.nameShow.text=_myRemarkName;
    }
    
    return topcell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

     //如果点击群名，将进入修改群名界面
    
    
    if(indexPath.section==0&&indexPath.row==0) {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
    ReNameGroupViewController * test2obj = [mainStoryBoard instantiateViewControllerWithIdentifier:@"reNameGroup"];
    
        //
        test2obj.groupId = _groupId;
        test2obj.myOldGroupName = _groupName;
        [self.navigationController pushViewController:test2obj animated:YES];
        
    }

    
    
      //如果点击个人备注，将进入修改备注界面
    if(indexPath.section==2)
    {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
    SetMyGRemarkViewController * test1obj = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SetMyGRemark"];
        test1obj.myOldRemarkName = _myRemarkName;
        test1obj.groupId = _groupId;

        [self.navigationController pushViewController:test1obj animated:YES];
        
        
    }
    
    


    [tableView deselectRowAtIndexPath:indexPath animated:YES];         //取消点击效果


}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    // self.hidesBottomBarWhenPushed=YES;
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:YES];
  //  [self initCreateData];
    [self initMyView];
    
    
    //  self.result =  [_imdbModel  queryAll];
    // [self.tableView reloadData];              //界面即将出现时刷新界面
    self.navigationController.navigationBarHidden = NO;
    
    //个人备注
    
    GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
    [gmdb createTableWithGroupId:_groupId];
    NSArray *res = [gmdb search:_nowUserId];
    if (0 == res.count) {
        _myRemarkName = @"服务器不给我";
    }
    else _myRemarkName = ((GroupMemeberModel *)res[0]).memberName;

    //将在此处获取群信息
    // 获取群信息测试
   
    
    [[GroupModule alloc] getGroupInfoWithID:_groupId success:^(IMGroupEntity* group){
          NSLog(@"群组ID:%ld,群组名:%@,成员数:%d",(long)((IMGroupEntity*)group).ID,((IMGroupEntity*)group).name,((IMGroupEntity*)group).memberNumber);
        _groupId = (int)((IMGroupEntity*)group).ID;
        _groupName = ((IMGroupEntity*)group).name;
        _memberNumber = ((IMGroupEntity*)group).memberNumber;
        [_showTable reloadData];
        
    } failure:^(NSString *error){}];
    
        [self initCreateData];
        [_showTable reloadData];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:NO];
    
    // self.navigationController.navigationBarHidden = YES;
}





@end
