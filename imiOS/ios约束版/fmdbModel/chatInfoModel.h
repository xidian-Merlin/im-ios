//
//  chatInfoModel.h
//  ios约束版
//
//  Created by tongho on 16/7/30.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>


//  @"CREATE TABLE IF NOT EXISTS t_chatInfo (id integer PRIMARY,sendID integer NOT NULL,receiverID integer NOT NULL, chatting text NOT NULL, date text NOT NULL, style integer NOT NULL, is_finished int DEFAULT -1, is_read int NOT NULL)"

@interface chatInfoModel : NSObject
@property(nonatomic, copy) NSString *content;     //假如是文本则直接放入，假如是文件，图片或者视频／语音 将纪录它们的路径
@property(nonatomic, copy) NSDate *date; //日期
@property(nonatomic, assign) int messageStyle;// 消息类型  将由此判断是文本还是某一路径
@property(nonatomic, assign) int style;  //判断是单聊还是群
@property(nonatomic, assign) int sendId; //发送者ID
@property(nonatomic, assign) int receiverId; //接收者ID
@property(nonatomic, assign)  int isFinished;  //是否是缩略图
@property(nonatomic, assign) int messageId;    //消息的id，唯一标识一条消息
@property(nonatomic, assign) int serverMessageId;

@end
