//
//  SetRightTableViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/5.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "SetRightTableViewController.h"

@interface SetRightTableViewController ()
- (IBAction)forbidVisit:(id)sender;

@end

@implementation SetRightTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (IBAction)forbidVisit:(id)sender {
    
           UISwitch *switchButton = (UISwitch*)sender;
        BOOL isButtonOn = [switchButton isOn];
        if (isButtonOn) {
            NSLog(@"禁止查看");
        }else {
            NSLog(@"可以查看");
}
}


-(void)viewWillAppear:(BOOL)animated{
    
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:YES];
    
    self.navigationController.navigationBarHidden = NO;
    //   view.frame=CGRectMake(0, 480, 0, 0);
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:NO];
    
    self.navigationController.navigationBarHidden = YES;
}

    
@end
