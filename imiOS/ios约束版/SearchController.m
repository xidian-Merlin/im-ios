//
//  SearchController.m
//  ios约束版
//
//  Created by tongho on 16/7/27.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "SearchController.h"
#import "historyHf.h"
#import "ContactModule.h"
#import "IMUserEntity.h"
#import "MBProgressHUD+NJ.h" 
#import "SearchFriResultController.h"

@interface SearchController ()

@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataList = [NSMutableArray array];
   // _dataList = [NSMutableArray arrayWithObjects:@"1",@"11",@"2",@"22",@"#",@"3",@"33",@"4",@"44",@"ff",@"a",@"aaa",@"555",@"666",nil];
    
    [self searchControllerLayout];
    
    [self setExtraCellLineHidden:self.mainTable];
    
  //  self.mainTable.scrollEnabled =NO;
}

-(void)searchControllerLayout{
    
    self.mainTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    
    [self.view addSubview:self.mainTable];
    
    self.mainTable.scrollEnabled =NO; //设置tableview 不能滚动
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //    输入框提示
    _searchController.searchBar.placeholder=@"加群或者加好友";
    //    searchResultsUpdater协议代理
    _searchController.searchResultsUpdater = self;
    //    使之背景暗淡当陈述时
    _searchController.dimsBackgroundDuringPresentation = NO;
    //    隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = YES;
    //
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    //   改变系统自带的“cancel”为“取消”
    [self.searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    //   表头视图为searchcontroller的searchbar
    self.mainTable.tableHeaderView = self.searchController.searchBar;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active && ![[self.searchController.searchBar text] isEqualToString:@""]) {
        return _searchList.count;
    }else{
        return _dataList.count;
    }
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier=@"cellFlag";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (self.searchController.active && ![[self.searchController.searchBar text] isEqualToString:@""]) {
    
        UIImage *image = [UIImage imageWithData: ((historyHf *)_searchList[indexPath.row]).icon];
        cell.imageView.image = image;
        cell.textLabel.text = ((historyHf *)_searchList[indexPath.row]).nickName;
        //  cell.textLabel.text = self.searchList[indexPath.row];
    }
    else{
        cell.textLabel.text = self.dataList[indexPath.row];
        
    }
    
  //  [_searchList removeAllObjects];
    return cell;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    //
     [self setExtraCellLineHidden:self.tableView];
    
    historyHf *model1 = [[historyHf alloc]init];
      historyHf *model2 = [[historyHf alloc]init];
    _searchList = [NSMutableArray array];
    
    NSString *searchString = [self.searchController.searchBar text];
    //谓词过滤
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    //self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //添加 查找人  查找群 的数组
    UIImage *img = [UIImage imageNamed:@"avl.png"];
    
    NSData *dataObj = UIImagePNGRepresentation(img);
    
    model1.icon = dataObj;
    model1.nickName = [NSString stringWithFormat:@"%@%@",@"找人:",searchString];
    [_searchList addObject:model1];
    /*
    img = [UIImage imageNamed:@"zq.png"];
    dataObj = UIImagePNGRepresentation(img);
    model2.icon = dataObj;
    
    model2.nickName = [NSString stringWithFormat:@"%@%@",@"加群:",searchString];
    
    [_searchList addObject:model2];
    
    */
   // self.searchList = [NSMutableArray arrayWithObjects:@"tongho",searchString,nil];
    //刷新表格
    [self.mainTable reloadData];
    
  }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchController.active) {
        //1.被选中的是添加联系人，发送查询请求，
        if(0 == indexPath.row)
        {
            //等待查询结果，
            
             [MBProgressHUD showMessage:@"正在拼命加载ing...."];
            
            //跳转进入结果界面，在跳转界面显示结果
            
            NSLog(@"找人");
            
            // 搜索用户测试
            [[ContactModule instance] searchUser:[self.searchController.searchBar text] success:^(NSArray* userArray){
                
                SearchFriResultController *test2obj = [[SearchFriResultController alloc]init];
                
                test2obj.result = userArray;
                
                self.searchController.active = NO;                
            //    [self.searchController.searchBar setHidden:YES];
                [self.navigationController pushViewController:test2obj animated:YES];
                
                
                [MBProgressHUD hideHUD];
            } failure:^(NSString* error){
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请求错误"];
                
            }];
            
            
            
            
            
        
        }
         //2.被选中的是添加群组，则请求加群
        
        if(1 == indexPath.row)
        {
        
        
            NSLog(@"加群");
        }
        
    
    }else{
        NSLog(@"%@被选中",_dataList[indexPath.row]);
    }
   
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];         //取消点击效果
    
}



//下述的两个方法要一起使用，才可以让自定义分割线从最左侧开始

-(void)viewDidLayoutSubviews
{
    // 重写UITableView的方法是分割线从最左侧开始
    if ([self.mainTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTable  setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mainTable  respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTable  setLayoutMargins:UIEdgeInsetsZero];
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
    
     [self.searchController.searchBar setHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    
      _searchController.hidesNavigationBarDuringPresentation = YES;
    
   // self.searchController.active = YES;
    //   view.frame=CGRectMake(0, 480, 0, 0);
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:NO];
    
   
    
      // self.navigationController.navigationBarHidden = YES;
}





@end
