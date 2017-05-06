//
//  ChatViewController.h
//  CocoaPods
//
//  Created by tongho on 16/7/12.
//  Copyright © 2016年 im. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//好友的jid

@property (assign, nonatomic) int hhId;//成员会话表cell对应的ID

//@property (assign, nonatomic) int groupId;//会话表cell对应的ID
@property (strong, nonatomic) NSString *temTitle;   //导航栏标题

@property (assign ,nonatomic) BOOL isGroupStyle;

@property (strong, nonatomic) UIImage *heImage;

@end
