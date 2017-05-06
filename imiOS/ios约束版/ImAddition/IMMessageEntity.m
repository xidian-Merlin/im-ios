//
//  IMMessageEntity.m
//  im
//
//  Created by yuhui wang on 16/7/30.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMMessageEntity.h"

@implementation IMMessageEntity

- (IMMessageEntity*) initWithMsgID:(long)ID
                           msgTime:(long)msgTime
                       SessionType:(SessionType)sessionType
                          senderID:(int)senderID
                          toUserID:(int)toUserID
              IMMessageContentType:(IMMessageContentType)messageContentType
                        msgContent:(NSString*)msgContent
{
    self = [super init];
    if (self)
    {
        _msgID = ID;
        _msgTime = msgTime;
        _sessionType = sessionType;
        _senderId = senderID;
        _toUserID = toUserID;
        _msgContentType = messageContentType;
        _msgContent = msgContent;
    }
    return self;
}

@end
