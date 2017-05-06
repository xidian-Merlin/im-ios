//
//  SelectFriendViewController.h
//  ios约束版
//
//  Created by tongho on 16/8/3.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NewMember)(NSArray * newMember);

@interface SelectFriendViewController : UIViewController

@property (nonatomic, copy)NSString *brandNO;


@property (nonatomic, retain) NSMutableArray *dataArr;
@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;

@property (nonatomic, assign) int groupId;

-(void) setNewMember:(NewMember)block;


@end
