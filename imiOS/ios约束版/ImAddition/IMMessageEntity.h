//
//  IMMessageEntity.h
//  im
//
//  Created by yuhui wang on 16/7/30.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(short, IMMessageContentType)
{
    IMMessageTypeText   =0,
    IMMessageTypeImage  =1,
    IMMessageTypeFile   =2,
    IMMessageTypeVoice  =3,
    IMMessageTypeVadio  =4,
    MSG_TYPE_AUDIO      =5,
    MSG_TYPE_GROUP_AUDIO = 6
};

typedef NS_ENUM(short, IMMessageState)
{
    IMMessageSending =0,
    IMMessageSendFailure =1,
    IMmessageSendSuccess =2
};

// 会话类型
typedef NS_ENUM(int, SessionType) {
    SessionTypeSingle = 1,
    SessionTypeGroup = 2,
};
 
@interface IMMessageEntity : NSObject
@property (nonatomic,assign) long                 msgID;//MessageID
@property (nonatomic,assign) long                 msgTime;//消息收发时间
@property (nonatomic,assign) SessionType          sessionType;//消息类型
@property (nonatomic,assign) int                  senderId;//发送者的Id,群聊天表示发送者id
@property (nonatomic,assign) int                  toUserID;//消息发至的用户ID
@property (nonatomic,strong) NSString             * msgContent;//消息内容
@property (assign          ) IMMessageContentType msgContentType;
@property (nonatomic,assign) IMMessageState       state;//消息发送状态

- (IMMessageEntity*) initWithMsgID:(long)ID
                           msgTime:(long)msgTime
                       SessionType:(SessionType)sessionType
                          senderID:(int)senderID
                          toUserID:(int)toUserID
              IMMessageContentType:(IMMessageContentType)messageContentType
                        msgContent:(NSString*)msgContent;

@end
