//
//  SearchController.h
//  ios约束版
//
//  Created by tongho on 16/7/27.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchController : UITableViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>

@property (nonatomic,strong)UITableView *mainTable;

@property (nonatomic,strong)UISearchController *searchController;

@property (nonatomic,strong)NSMutableArray *dataList;
@property (nonatomic,strong)NSMutableArray *searchList;

//隐藏多余的cell

-(void)setExtraCellLineHidden: (UITableView *)tableView;


@end
