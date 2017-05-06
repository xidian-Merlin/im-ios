//
//  tabbarController.m
//  login
//
//  Created by tongho on 16/7/9.
//  Copyright © 2016年 im. All rights reserved.
//

#import "tabbarController.h"
#import "tabTbar.h"
#import "RKNotificationHub.h"
#import "IMConstant.h"
#import "NewFriendDb.h"
#import "HfDbModel.h"
#import "ImdbModel.h"
#import "ContactModule.h"
#import "MessageModule.h"


@interface tabbarController ()

//定义变量记录当前选中的按钮

@property (nonatomic, strong)tabTbar *mytarbar;
@property (nonatomic, strong) NewFriendDb *nfdbModel;
@property (nonatomic, strong) NSArray* result1;
@end

@implementation tabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSLog(@"FDGD");
    //1.创建自定义的Tabbar
    tabTbar *myTabBar = [[tabTbar alloc] init];   //此处tabbar与UIview没有差别
   // myTabBar.backgroundColor = [UIColor greenColor];
    
    myTabBar.frame = self.tabBar.frame;
     myTabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbar_bottom_bar.png"]];
    
    [self.view addSubview:myTabBar];
    _nfdbModel = [[NewFriendDb alloc]init];
    
    BOOL create1 = [_nfdbModel createTable];
    
    if(create1){
        _result1 =  [_nfdbModel searchIsread:0];   //未读的请求数，两个查询可以合并
    }
    //
    [_hub2 setCount:(int)_result1.count];   //将未读数目显示在tab上
  
    
    //设置监听：
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh1)
                                                 name:IMNotificationReceiveMessage   //会话消息
                                               object:nil];
    
    
    
    

    //设置监听：
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh2)
                                                 name:IMNotificationReceiveFriendRequest   //好友请求
                                               object:nil];
    
    //获取好友列表。存入数据库
    
    [[ContactModule instance] getUserListsuccess:^(NSArray* userArray){
        NSLog(@"搜索到用户数目：%lu",(unsigned long)userArray.count-1);
        NSLog(@"首个用户ID：%ld",(long)((IMUserEntity*)userArray[1]).ID);
        NSLog(@"首个用户名：%@",((IMUserEntity*)userArray[1]).name);
        NSLog(@"首个用户昵称：%@",((IMUserEntity*)userArray[1]).nick);
        
        
        ImdbModel* imdbModel = [[ImdbModel alloc] init];
        if (userArray.count > 1) {     //当返回数组不为空
            
        
        BOOL create = [imdbModel createTable];
        if (create) {
            
            for(int i=1;i<userArray.count;i++){
            NSString *remark;
            UIImage * avatar = ((IMUserEntity*)userArray[i]).avatar;
                if (nil == ((IMUserEntity*)userArray[i]).avatar) {
                    avatar = [UIImage imageNamed:@"tn.9.png"];
                }
                
            NSData* avatarData;
            if (UIImagePNGRepresentation(avatar)) {
                avatarData = UIImagePNGRepresentation(avatar);
            }else {
                avatarData = UIImageJPEGRepresentation(avatar, 1.0);
            }
                
                remark = ((IMUserEntity*)userArray[i]).remark;
                if ([@"" isEqualToString:((IMUserEntity*)userArray[i]).remark]) {
                  remark = ((IMUserEntity*)userArray[i]).nick;
                }
                
            [imdbModel saveHistoryFriend:((IMUserEntity*)userArray[i]).name userId:(int)((IMUserEntity*)userArray[i]).ID nickName:((IMUserEntity*)userArray[i]).nick remakeName:remark  lastMessage:@"我的签名" icon:avatarData tel:(NSString *)@"未知" email:(NSString *)@"未知"];
                
                
                //跟新会话表中的头像与备注
                
                HfDbModel* hfDbModel1 = [[HfDbModel alloc] init];
                
                BOOL create1 = [hfDbModel1 createTable];
                if (create1) {
                    [hfDbModel1 set:remark withUserId:(int)((IMUserEntity*)userArray[i]).ID style:1];
                    [hfDbModel1 setIcon:avatarData withUserId:(int)((IMUserEntity*)userArray[i]).ID style:1];
                }
                
                
                
                
                
                
        }
       
        
        }
        }
       
    } failure:^(NSString* error){
        NSLog(@"请求失败");
    }];
    
  
    
    //2.删除系统自带的tabbar
    
    // [self.tabBar removeFromSuperview];
    
  //  NSArray *tabBarItems = self.navigationController.tabBarController.tabBar.items;
   // UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:3];
  //  personCenterTabBarItem.badgeValue = @"2";//显示消息条数为 2
    
   /* hub = [[RKNotificationHub alloc]initWithView:imageView];
    [hub moveCircleByX:-5 Y:5]; // moves the circle five pixels left and 5 down
    //    [hub hideCount]; // uncomment for a blank badge
    
    barHub = [[RKNotificationHub alloc] initWithBarButtonItem: _barButtonItem];
    [barHub increment];
    */
    //3.创建按钮，添加到自定义的tabbar上
        
    for (int i = 0; i < 4; i++) {
            // 3.1创建按钮
            UIButton *btn = [[UIButton alloc] init];
        
            // 3.2设置按钮上显示的图片
            // 3.2.1设置默认状态图片
            NSString *norImageName = [NSString stringWithFormat:@"TabBar%d", i + 1];
            [btn setImage:[UIImage imageNamed:norImageName] forState:UIControlStateNormal];
        
             // 3.2.2设置选中状态图片
              //更正,由于按钮被选中后不应再被点击, 所以应该用不可用状态
             NSString *selImageName = [NSString stringWithFormat:@"TabBar%dSel", i + 1];
             [btn setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
             
            
           /* NSString *disableImageName = [NSString stringWithFormat:@"TabBar%dSel", i + 1];
            [btn setBackgroundImage:[UIImage imageNamed:disableImageName] forState:UIControlStateDisabled];
            */
            // 3.3设置frame
            CGFloat btnY = 0;
            CGFloat btnW = myTabBar.frame.size.width / 4;
            CGFloat btnH = myTabBar.frame.size.height;
            CGFloat btnX = i * btnW;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
            // 3.4添加按钮到自定义TabBar
            [myTabBar addSubview:btn];
            
            // 3.5监听按钮点击事件
            //        [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchDown];
            
        
            
            // 3.7设置按钮高亮状态不调整图片
            btn.adjustsImageWhenHighlighted = NO;
            
            // 3.8设置按钮的Tag作为将来切换子控制器的索引
            btn.tag = i+1;
        
        // 3.6设置默认选中按钮
        if (0 == i) {
            [self btnOnClick:btn];
            _btn1 = btn;
        }
        if (1 == i) _btn2 = btn;
        if (2 == i) _btn3 = btn;
        if (3 == i) _btn4 = btn;
        
        
        //  NSLog(@"%ld",(long)btn.tag);
    
    }
    _mytarbar = myTabBar;
    //四个提醒气泡
    
    UIButton *bt1 = (UIButton *)[myTabBar viewWithTag:1];       //此处tag标志不要为0，真心读不出值啊
    _hub1 = [[RKNotificationHub alloc]initWithView:bt1];
    [_hub1 moveCircleByX:-20 Y:10];
    [_hub1 scaleCircleSizeBy:0.7];
   // [_hub1 increment];
   
    UIButton *bt2 = (UIButton *)[myTabBar viewWithTag:2];
    _hub2 = [[RKNotificationHub alloc]initWithView:bt2];
    [_hub2 moveCircleByX:-20 Y:10];
    [_hub2 scaleCircleSizeBy:0.7];

    
    UIButton *bt3 = (UIButton *)[myTabBar viewWithTag:3];
    _hub3 = [[RKNotificationHub alloc]initWithView:bt3];
    [_hub3 moveCircleByX:-20 Y:10];
    [_hub3 scaleCircleSizeBy:0.7];
  
    
 
    }
    
    
-(void)btnOnClick:(UIButton *)btn
{
   // NSLog(@"DFFFDF");
    //取消上次点击状态
    self.selectbtn.selected = NO;
   // 1.设置被选中按钮为点击状态
    btn.selected = YES;
    
    self.selectbtn = btn;
    
    // 3.切换子控制器
    self.selectedIndex = btn.tag-1;
  
}
        
-(void)refresh1{
    
    HfDbModel* hfDbModel = [[HfDbModel alloc] init];
    
    BOOL create1 = [hfDbModel createTable];
    int count1 =0;
    
    if(create1){
         count1 =  [hfDbModel  countAllred];
   //未读的请求数，两个查询可以合并
    }
    //
    [_hub1 setCount:count1];   //将未读数目显示在tab上
    
}





-(void)refresh2{

    
    BOOL create1 = [_nfdbModel createTable];
    
    if(create1){
      _result1 =  [_nfdbModel searchIsread:0];   //未读的请求数，两个查询可以合并
    }
    //
    [_hub2 setCount:(int)_result1.count];   //将未读数目显示在tab上

}
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMNotificationReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMNotificationReceiveFriendRequest object:nil];
    
}

@end
