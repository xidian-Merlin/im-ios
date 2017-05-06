//
//  SettingTableViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/4.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation SettingTableViewController- (void)viewDidLoad {
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (0 == indexPath.section ) {
        if (0 == indexPath.row) {
            //进入修改密码界面
            UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
            UITableViewController * test2obj = [MainStoryboard instantiateViewControllerWithIdentifier:@"setPassController"];
            //      self.hidesBottomBarWhenPushed = YES;
            //  test2obj.infoDele = self;
            
            [self.navigationController pushViewController:test2obj animated:YES];
            
            
            
            
            
        }
        if (1 == indexPath.row){
            
            //进入设置权限界面
            UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
        UITableViewController * test2obj = [MainStoryboard instantiateViewControllerWithIdentifier:@"setRightController"];
        //      self.hidesBottomBarWhenPushed = YES;
        //  test2obj.infoDele = self;
        
        [self.navigationController pushViewController:test2obj animated:YES];
        
        }
            
            if (2 == indexPath.row) {
                //进入绑定信息界面
                //进入设置权限界面
                UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
                UITableViewController * test2obj = [MainStoryboard instantiateViewControllerWithIdentifier:@"setTelController"];
                //      self.hidesBottomBarWhenPushed = YES;
                //  test2obj.infoDele = self;
                
                [self.navigationController pushViewController:test2obj animated:YES];
                
                
                
            }
    }
    if (1 == indexPath.section) {
        //进入关于app
    }

[tableView deselectRowAtIndexPath:indexPath animated:YES];         //取消点击效果

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
    
   // self.navigationController.navigationBarHidden = YES;
}








/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
