//
//  SelectFileViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/14.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "SelectFileViewController.h"

#import "SelectFriendCell.h"
#import "Person.h"
#import "UILabel+MyLable.h"
#import "ImdbModel.h"
#import "historyHf.h"
#import "ChineseString.h"
#import "pinyin.h"
#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(100)]
@interface SelectFileViewController ()<UITableViewDelegate,UITableViewDataSource>
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

@property (strong, nonatomic) NSMutableArray *result;

@property (strong, nonatomic) historyHf *model;
@property (strong,nonatomic) MyFileBlock fileBlock;


-(void)setExtraCellLineHidden: (UITableView *)tableView;

- (NSArray*) allFilesAtPath:(NSString*) dirString;

@end

@implementation SelectFileViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc]init];
    selectGoods = [[NSMutableArray alloc]init];
    
    // 1.获得Documents的全路径
    NSString *nowDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *nowPath = [nowDoc stringByAppendingPathComponent:@"nowUser.data"]; //扩展名可以自己定义
    
    // 3.从文件中读取MJStudent对象，将nsdata转成对象
    Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];
    
    
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [docPaths lastObject];
    
    
    //获取cache，存自建文件
    NSString *nowCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    
    NSString *testPath = [nowCache stringByAppendingPathComponent:nowUser.userName];
    NSString *filePath = [testPath stringByAppendingPathComponent:@"File"];
      _result  = (NSMutableArray *)[self allFilesAtPath:filePath];
    
    // NSLog(@"documentsPath = %@",documentsPath);
    
    
    
    [self setNav];
    [self createTableView];
    
    [self setExtraCellLineHidden:self.friendTableView];
   
    
    [self.friendTableView reloadData];
    
}

-(void)setMyFileBlock:(MyFileBlock)block
{
    self.fileBlock = block;
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
    UILabel *label = [UILabel initWithText:@"选择发送文件" withFontSize:16 WithFontColor:[UIColor blueColor] WithMaxSize:CGSizeMake(100, 20)];
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  _result.count;
}






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * identifier=@"fileTableViewCell";
    
    
    SelectFriendCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SelectFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.isSelected = isSelect;
    
    
        if ([selectGoods containsObject:_result[indexPath.row]]) {
                cell.isSelected = YES;
            }
            
            cell.cartBlock = ^(BOOL isSelec){
                
                if (isSelec) {
                    [selectGoods addObject:_result[indexPath.row]];
                }
                else
                {
                    [selectGoods removeObject:_result[indexPath.row]];
                }
                
                if (selectGoods.count == _result.count) {
                    selectAll.selected = YES;
                }
                else
                {
                    selectAll.selected = NO;
                }
                
            };
            [cell reloadDataWith:_result[indexPath.row]];
    
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
    for (int i = 0; i < selectGoods.count ; i++) {
        _model = [[historyHf alloc]init];
        _model = selectGoods[i];
        str = [str stringByAppendingString:_model.nickName2];
    }
    NSString * str1 = @"选中文件:";
    if (selectGoods.count == 0) {
        str1 = @"请先选择文件";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@%@", str1, str] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        // 1.获得Documents的全路径
        NSString *nowDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        // 2.获得文件的全路径
        NSString *nowPath = [nowDoc stringByAppendingPathComponent:@"nowUser.data"]; //扩展名可以自己定义
        
        // 3.从文件中读取MJStudent对象，将nsdata转成对象
        Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];

        
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [docPaths lastObject];
        
        //获取cache，存自建文件
        NSString *nowCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        
        NSString *testPath = [nowCache stringByAppendingPathComponent:nowUser.userName];
        //得到文件的完整路径
        NSString *path = [testPath stringByAppendingPathComponent:@"File"];

        
        NSString *filePath = [path stringByAppendingPathComponent:_model.nickName2];
        
        //确定之后获取文件完整路径，发送最后一个被选择文件
        
        //传文件名
        self.fileBlock(_model.nickName2);
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }]];
    
    UIAlertAction *neverAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:neverAction];
    
    //显示对话框
    [self presentViewController:alert animated:true completion:nil];
    
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

- (NSArray*) allFilesAtPath:(NSString*) dirString {
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil]; //当前路径下的文件名
    
    for (NSString* fileName in tempArray) {
        
        BOOL flag = YES;
        
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            
            if (!flag) {
                
                historyHf *res = [[historyHf alloc]init];
                res.nickName2 = fileName;
                res.icon = UIImagePNGRepresentation([UIImage imageNamed:@"a1l.png"]);
                
                [array addObject:res];
                
            }
            
        }
        
    }
    
    return array;
    
}

@end

