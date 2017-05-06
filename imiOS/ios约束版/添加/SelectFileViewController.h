//
//  SelectFileViewController.h
//  ios约束版
//
//  Created by tongho on 16/8/14.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>


//确定发送后，将文件名回传给聊天框

typedef void (^MyFileBlock)(NSString *fileName);


@interface SelectFileViewController : UIViewController

//设置MyTextBlock
-(void) setMyFileBlock:(MyFileBlock)block;

@end
