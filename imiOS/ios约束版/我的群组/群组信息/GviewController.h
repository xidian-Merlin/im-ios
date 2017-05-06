//
//  ViewController.h
//  WeChatGroupInfo
//
//  Created by hackxhj on 15/10/19.
//  Copyright © 2015年 hackxhj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^rootBlock)(int flag);


@interface GviewController : UIViewController

@property (assign, nonatomic) int groupId;
@property (copy, nonatomic) NSString *groupName;

-(void)setrootBlock:(rootBlock) block;


@end

