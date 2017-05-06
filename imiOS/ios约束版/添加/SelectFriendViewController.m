//
//  SelectFriendViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/3.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "SelectFriendViewController.h"
#import "SelectFriendCell.h"
#import "UILabel+MyLable.h"
#import "ImdbModel.h"
#import "historyHf.h"
#import "ChineseString.h"
#import "pinyin.h"
#import "GroupModule.h"
#import "CreatGroupAPI.h"
#import "GroupMemeberDb.h"
#import "MBProgressHUD+NJ.h"
#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(100)]
@interface SelectFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //展示数据源数组
    NSMutableArray *dataArray;
    //全选按钮
    UIButton *selectAll;
    //是否全选
    BOOL isSelect;
    
    //已选的朋友的集合
    NSMutableArray *selectGoods;
}

@property (nonatomic, strong)UITableView *friendTableView;

@property (nonatomic, strong) ImdbModel *imdbModel;
@property (strong, nonatomic) NSMutableArray *result;

@property (strong, nonatomic) NewMember newMemberblock;

-(void)setExtraCellLineHidden: (UITableView *)tableView;

@end

@implementation SelectFriendViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc]init];
    selectGoods = [[NSMutableArray alloc]init];
    
    
    _dataArr = [[NSMutableArray alloc] init];
    _sortedArrForArrays = [[NSMutableArray alloc] init];
    _sectionHeadsKeys = [[NSMutableArray alloc] init];      //initialize a array to hold keys like A,B,C ...
    
    
    [self setNav];
    [self createTableView];
    
    [self setExtraCellLineHidden:self.friendTableView];
    _imdbModel = [[ImdbModel alloc]init];
    BOOL create = [_imdbModel createTable];
    if (create)
    self.result =  (NSMutableArray *)[_imdbModel  queryAll];
    for (id object in _result) {
        NSLog(@"langArray=%@", ((historyHf *)object).nickName);
        [_dataArr addObject:((historyHf *)object).nickName];
        
    }
    self.sortedArrForArrays = [self getChineseStringArr:_dataArr];
    
    [self.friendTableView reloadData];
    
}




- (void)createTableView {
    
    self.friendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    self.friendTableView.delegate =self;
    self.friendTableView.dataSource = self;
    self.friendTableView.showsVerticalScrollIndicator = NO;
   // self.friendTableView.separatorStyle = 0;
    self.friendTableView.rowHeight = 50;
    self.friendTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//使分隔线可以调整
    [self.friendTableView setSeparatorColor:[UIColor grayColor]];  //设置分隔线的颜色
    
    
    
    
    [self.view addSubview:self.friendTableView];
    
    [self createTopView];
    
}

- (void)createTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    UILabel *label = [UILabel initWithText:@"选择群聊好友" withFontSize:16 WithFontColor:[UIColor blueColor] WithMaxSize:CGSizeMake(100, 20)];
    label.textAlignment = NSTextAlignmentLeft;
    label.frame = CGRectMake(15, 20, 220, 20);
    [topView addSubview:label];
    
    //全选按钮
    selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:15];
   // [selectAll setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    selectAll.frame = CGRectMake(15, 10, WIDTH - 30, 30);
   // [selectAll setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
    //    selectAll.backgroundColor = [UIColor lightGrayColor];
    [selectAll setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    [selectAll setTitle:@"        " forState:UIControlStateNormal];
    selectAll.imageEdgeInsets = UIEdgeInsetsMake(0,WIDTH - 50,0,selectAll.titleLabel.bounds.size.width);
    [topView addSubview:selectAll];
    
    
    topView.backgroundColor = [UIColor whiteColor];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:line];
    
    self.friendTableView.tableHeaderView = topView;
}


-(void)selectAllBtnClick:(UIButton*)button
{
    
    
    /*
    //点击全选时,把之前已选择的全部删除
    [selectGoods removeAllObjects];
    
    button.selected = !button.selected;
    isSelect = button.selected;
    if (isSelect) {
        
        for (historyHf *model in dataArray) {
            [selectGoods addObject:model];
        }
        
    }
    else
    {
        [selectGoods removeAllObjects];
        
    }
    
    [self.friendTableView reloadData];
     
     */
}

#pragma mark uitableview

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sortedArrForArrays count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  [[self.sortedArrForArrays objectAtIndex:section] count];
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return dataArray.count;
     
}*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionHeadsKeys objectAtIndex:section];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.friendTableView.frame), 20)];
    view.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * identifier=@"ProductTableViewCell";
    
    
    SelectFriendCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SelectFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.isSelected = isSelect;
    
    if ([self.sortedArrForArrays count] > indexPath.section) {
        NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row) {
            ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
            //将得到的str.string 放入result的循环，得到相对应的result，再对cell賦值
            //等于过滤查询
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nickName == %@", str.string];
            NSArray *filteredArray = [_result filteredArrayUsingPredicate:predicate];
       //     historyHf *friend = filteredArray[0];
            [_result removeObject:filteredArray[0]];
            //   [cell setCellValue:friend.nickName   icon:friend.icon ];
            
            if ([selectGoods containsObject:filteredArray[0]]) {
                cell.isSelected = YES;
            }
            
            cell.cartBlock = ^(BOOL isSelec){
                
                if (isSelec) {
                    [selectGoods addObject:filteredArray[0]];
                }
                else
                {
                    [selectGoods removeObject:filteredArray[0]];
                }
                
                if (selectGoods.count == _dataArr.count) {
                    selectAll.selected = YES;
                }
                else
                {
                    selectAll.selected = NO;
                }
                
            };
            [cell reloadDataWith:filteredArray[0]];
            
            
            
            
        } else {
            NSLog(@"arr out of range");
        }
    } else {
        NSLog(@"sortedArrForArrays out of range");
    }
    
    
    return cell;
}



/*
-(void)creatData
{
    for (int i = 0; i < 10; i++) {
        historyHf *model = [[historyHf alloc]init];
        model.nickName = MJRandomData;
        [dataArray addObject:model];
    }
    
}
*/

#pragma mark ---配置导航条
- (void)setNav{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *additionBtn = [[UIButton alloc] init];
    [additionBtn setTitle:@"确定" forState:UIControlStateNormal];
    additionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [additionBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [additionBtn addTarget:self action:@selector(saveClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    additionBtn.frame = CGRectMake(0, 0, 40, 25);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:additionBtn];
    
   /* [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Library" style:UIBarButtonItemStyleDone target:self action:@selector(onLibraryButtonClicked:)]];
    self.navigationItem.hidesBackButton = YES;*/
    
}


- (void)saveClickBtn:(UIButton *)btn {
    NSLog(@"保存");
    NSString *str= @"";
     NSMutableArray *arry0 = [NSMutableArray array];
    for (int i = 0; i < selectGoods.count ; i++) {
        
        historyHf *model = [[historyHf alloc]init];
        model = selectGoods[i];
        
       
        [arry0 addObject:[NSNumber numberWithInt:model.userId]];
        str = [str stringByAppendingString:model.nickName2];
        str = [str stringByAppendingString:@"; "];
    }
     NSString * str1 = @"选中成员:";
    if (selectGoods.count == 0) {
        str1 = @"请先选择成员";
    }
   __weak __block SelectFriendViewController *copy_self = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@%@", str1, str] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray *arry1 = [NSMutableArray array];    //成员ID数组
        //点击确认，将向服务器发送成员添加申请，
        // 邀请入群测试
        [MBProgressHUD showMessage:@"正在拼命加载..."];
        [[GroupModule instance] inviteContactToGroupWithGroupID:_groupId contacts:arry0 success:^(NSArray* object){
            NSLog(@"邀请成功人数：%d",[object[0] intValue]);
            [MBProgressHUD hideHUD];
            for (int i = 1;i<= [object[0] intValue];i++) {
                [arry1  addObject:object[i]];
                //将邀请成功人员加入数据库
                GroupMemeberDb *groupMember = [[GroupMemeberDb alloc]init];
                
                BOOL creat = [groupMember createTableWithGroupId:_groupId];
                
                
                //由好友id搜索我的好友数据库，将我的好友的详细信息得出来，加入到群成员列表中去
              NSArray * result2 = [_imdbModel search:[object[i] intValue]];
                
                
                
                UIImage * avatar = [UIImage imageWithData: ((historyHf *)result2[0]).icon];
                if (nil == avatar) {
                    avatar = [UIImage imageNamed:@"tn.9.png"];
                }
                
                NSData* avatarData;
                if (UIImagePNGRepresentation(avatar)) {
                    avatarData = UIImagePNGRepresentation(avatar);
                }else {
                    avatarData = UIImageJPEGRepresentation(avatar, 1.0);
                }
                
                
                if (creat) {  //昵称， id，，头像，权限；创建者权限为1；
                    [groupMember saveMygroupMember:((historyHf *)result2[0]).nickName2 memberId:((historyHf *)result2[0]).userId Icon:avatarData permit:0];
                }
                

                
                
                
            }
           //如果申请成功
             [copy_self.navigationController popViewControllerAnimated:YES];
            
            
            
        } failure:^(NSString* error){
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"邀请失败!"];
            
        }];
        
        
        
        
        
        
        
        
    }]];
    
    UIAlertAction *neverAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:neverAction];
    
    [self presentViewController:alert animated:true completion:nil];
    
}


-(void) setNewMember:(NewMember)block
{

    _newMemberblock = block;


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
    
    // self.hidesBottomBarWhenPushed=YES;
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:YES];
    
    //每次进入的时候把选择的置空
    [selectGoods removeAllObjects];
    isSelect = NO;
    selectAll.selected = NO;
    // [self creatData];
    
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



