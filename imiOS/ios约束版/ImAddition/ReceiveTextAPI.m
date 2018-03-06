//
//  ReceiveTextAPI.m
//  ImAddition
//
//  Created by tongho on 16/8/10.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "ReceiveTextAPI.h"
#import "IMTcpProtocolHeader.h"
#import "DataInputStream.h"
#import "IMMessageEntity.h"

@implementation ReceiveTextAPI
- (int)responseCommandID
{
    return IM_MESSAGE;
}

- (int)responseSubcommandID
{
    return IM_MESS_RECEIVE_TEXT;
}

- (UnrequestAPIAnalysis)unrequestAnalysis
{
    UnrequestAPIAnalysis analysis = (id)^(NSData *data)
    {
        DataInputStream *datain = [[DataInputStream alloc] init];
        datain = [DataInputStream dataInputStreamWithData:data];
        long msgID = [datain readLong];
        long time = [datain readLong];
        int sessionType = [datain readInt];
        int fromUserID = [datain readInt];
        int toUserID = [datain readInt];
        NSString* text = [datain readUTFWithInt];
        IMMessageEntity *msg = [[IMMessageEntity alloc] initWithMsgID:msgID msgTime:time SessionType:sessionType senderID:fromUserID toUserID:toUserID IMMessageContentType:IMMessageTypeText msgContent:text];
        return msg;
    };
    return analysis;
}
@end
