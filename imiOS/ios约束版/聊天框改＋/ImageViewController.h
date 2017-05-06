//
//  ImageViewController.h
//  MecoreMessageDemo
//
//  Created by tongho on 16-11-25.
//  Copyright (c) 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^fullPicBlock)(int newContent);

@interface ImageViewController : UIViewController

//@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) UIImage *image;

@property (assign, nonatomic) BOOL isFinished;

@property (assign, nonatomic) BOOL isGruopChat;

@property (assign, nonatomic) int  chatId;  //聊天对象的id

@property (assign, nonatomic) int messageId;   //消息的id

@property (strong, nonatomic) fullPicBlock fullPicblock;


@property (nonatomic, copy) void (^NextViewControllerBlock)(NSString * tfText);



-(void) setfullPicBlock:(fullPicBlock)block;

@end
