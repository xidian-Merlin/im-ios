//
//  chatOperateClass.h
//  ios约束版
//
//  Created by tongho on 16/7/30.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sChatDb : NSObject   //聊天数据表操作模型

//操作


//建表  //单聊消息记录表名：xdsc+当前登录用户名＋聊天对象id＋HF;
- (BOOL)createTableWithContacterId:(int)contactId;

//存数据  发送者ID，接收者ID，
//content : 如果是文本，直接存，如果是其它类型，则存储它们的地址
//style :单聊 群聊
//date：消息时间
//messagestyle:消息的内容的类型，判断content的类型
//isfinished:为0表示缩略图，1表示完整信息已加载   文本为1

-(void)saveHistoryFriend:(int)sendId receiverId:(int)receiverId content:(NSString *)content style:(int)style date:(NSDate *)date
            messageStyle:(int)messageStyle isFinished:(int)isFinished serverMessageId:(int)serverMessageId;

//每次下拉加载查询18条
-(NSArray *) queryPartWith:(int)nowId ;

//获取最大的消息ID，此处为自增长，方便上述下拉加载18条的索引位置的判断
-(int)maxId;
//按照某一值，来删除一条消息，此功能还在考虑是否要实现
-(void) deleteFriendWithNickName:(NSString *)nickName;

-(void) updatewihtId:(int) messageId newContent:(NSString *)content newFinishFlag:(BOOL)flag;


-(void) updatewihtId:(int) messageId  newFinishFlag:(int)flag;

//查询最新的一条记录
-(NSArray *) querryLast;
@end
