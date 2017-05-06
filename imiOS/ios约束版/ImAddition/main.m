//
//  main.m
//  ImAddition
//
//  Created by yuhui wang on 16/7/31.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LoginModule.h"
#import "RegisterModule.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        // 存在账号：Lenon ,helloworld   whoami，xidian
        // 注册测试
        NSString* userName = @"whoami";
        NSString* password = @"xidian";
        [[RegisterModule instance] registerWithUsername:userName password:password success:^(){
            NSLog(@"main注册成功！");
        } failure:^(NSString* error){
            NSLog(@"main注册失败！");
        }];
        
        /*          登录测试
        NSString* userName = @"whoami";
        NSString* password = @"xidian";
        [[LoginModule instance] loginWithUsername:userName password:password success:^(){
            NSLog(@"main登录成功！");
        } failure:^(NSString* error){
            NSLog(@"main登录失败！");
        }];
        */
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
