//
//  historyHf.h
//  ios约束版
//
//  Created by tongho on 16/7/30.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface historyHf : NSObject


//id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, userId INTEGER NOT NULL, icon BLOB NOT NULL ,nickName text NOT NULL,nickName1 text NOT NULL,nickName2 text NOT NULL, lastMessage text NOT NULL,tel text NOT NULL,email text NOT NULL, date timestamp NOT NULL



@property(nonatomic, assign) int userId;        //用户id
@property(nonatomic, strong) NSString *nickName;     //用户名
@property(nonatomic, strong) NSString *nickName1;       //昵称
@property(nonatomic, strong) NSString *nickName2;       //备注
@property(nonatomic, strong) NSString *lastMessage;
@property(nonatomic, strong) NSString *tel;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSData *icon;
@property(nonatomic, strong) NSString *time;
@property(nonatomic, assign) int redCount;             //小红点的气泡数目
@property(nonatomic, assign) int agreeFlag;         //0,1,2 三种情况，如果是0，显示添加，1，显示已添加，2，显示待验证；
@property(nonatomic, assign) int isread;
@property(nonatomic, assign)  int style; //用于分辨是群聊还是单聊
@property(nonatomic, strong)  NSDate * topTime;



@end
