//
//  ReceiveFileAPI.m
//  ImAddition
//
//  Created by yuhui wang on 16/8/13.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "ReceiveFileAPI.h"
#import "IMTcpProtocolHeader.h"
#import "DataInputStream.h"
#import "IMMessageEntity.h"
#import "Person.h"

@implementation ReceiveFileAPI
- (int)responseCommandID
{
    return IM_MESSAGE;
}

- (int)responseSubcommandID
{
    return IM_MESS_RECEIVE_FILE;
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
        NSString *fileName = [datain readUTFWithInt];
        NSLog(@"文件名:%@",fileName);
        int fileLength = [datain readInt];
        
        NSString *msgContent = [NSString stringWithFormat:@"%@ %d",fileName,fileLength];

        IMMessageEntity *msg = [[IMMessageEntity alloc]initWithMsgID:msgID msgTime:time SessionType:sessionType senderID:fromUserID toUserID:toUserID IMMessageContentType:IMMessageTypeFile msgContent:msgContent];
        return msg;
    };
    return analysis;
}

@end
