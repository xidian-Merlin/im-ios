//
//  InfoViewController.m
//  静态列表——编辑资料
//
//  Created by Rannie on 13-9-4.
//  Copyright (c) 2013年 Rannie. All rights reserved.
//

#import "InfoViewController.h"
#import "Person.h"
#import "EditViewController.h"

@interface InfoViewController () <EditViewControllerDelegate>


@end

@implementation InfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化时读取
    
    
    
    // 1.获得Documents的全路径
    NSString *nowDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *nowPath = [nowDoc stringByAppendingPathComponent:@"nowUser.data"]; //扩展名可以自己定义
    
    // 3.从文件中读取MJStudent对象，将nsdata转成对象
    Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];
    
    _qqLabel.text = nowUser.userName;           //此处QQ修改成为了用户名    
    
    
    
    
    // 1.获得Documents的全路径    //根据上述的用户名，读取用户名.data中的数据
      NSString *filename = [NSString stringWithFormat:@"%@.data",_qqLabel.text];  //用户名.data
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:filename]; //扩展名可以自己定义
    
    // 3.从文件中读取MJStudent对象，将nsdata转成对象
    Person *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    [self setPerson:user];
    
 
    
}

/*
 - (IBAction)save {
 // 1.新的模型对象
 MJStudent *stu = [[MJStudent alloc] init];
 stu.no = @"42343254";
 stu.age = 20;
 stu.height = 1.55;
 
 // 2.归档模型对象
 // 2.1.获得Documents的全路径
 NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
 // 2.2.获得文件的全路径
 NSString *path = [doc stringByAppendingPathComponent:@"stu.data"];
 // 2.3.将对象归档
 [NSKeyedArchiver archiveRootObject:stu toFile:path];
 }
 
 - (IBAction)read {
 // 1.获得Documents的全路径
 NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
 // 2.获得文件的全路径
 NSString *path = [doc stringByAppendingPathComponent:@"stu.data"];
 
 // 3.从文件中读取MJStudent对象
 MJStudent *stu = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
 
 NSLog(@"%@ %d %f", stu.no, stu.age, stu.height);
 }
 */





- (void)setPerson:(Person *)person
{
    _person = person;
    _headerImageView.image = _person.headerImage;
    _nameLabel.text = _person.name;
    _signatureLabel.text = _person.signature;
    _sexLabel.text = _person.sex;
    _birthdayLabel.text = _person.birthday;
    
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EditViewController *editVC = (EditViewController *)segue.destinationViewController;
    editVC.editPerson = _person;
    editVC.editDelegate = self;
}


//edit代理方法
- (void)sendEditPerson:(Person *)ePerson
{
    self.person = ePerson;
    
     [self.infoDele refreshPerson:_person];
    
    [self setPerson:ePerson];

    
    //将数据保存
     NSString *filename = [NSString stringWithFormat:@"%@.data",_qqLabel.text];  //用户名.data
    
    // 2.归档模型对象
    // 2.1.获得Documents的全路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:filename];
    //先将原来的电话与邮箱读取出来
    
  Person *oldUser = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    ePerson.tel = oldUser.tel;
    ePerson.mail = oldUser.mail;
    
    
    // 2.3.将对象归档   //将person类型变为NSData类型,放入内存
    
    
    [NSKeyedArchiver archiveRootObject:ePerson toFile:path];
    
    
   
    
    
    

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
    
     
}



@end
