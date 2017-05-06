//
//  setPasswordViewController.h
//  login
//
//  Created by 追风 on 16/7/8.
//  Copyright © 2016年 im. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface setPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *secondPasswordText;
- (IBAction)jumpToRootView:(id)sender;
@end
