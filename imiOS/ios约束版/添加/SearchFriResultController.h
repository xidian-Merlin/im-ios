//
//  SearchFriResultController.h
//  ios约束版
//
//  Created by tongho on 16/8/5.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFriResultController : UIViewController<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray *result;

@end
