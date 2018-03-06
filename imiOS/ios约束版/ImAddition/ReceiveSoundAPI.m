//
//  ReceiveSoundAPI.m
//  ImAddition
//
//  Created by tongho on 16/8/21.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "ReceiveSoundAPI.h"
#import "IMTcpProtocolHeader.h"
#import "DataInputStream.h"
#import "IMMessageEntity.h"
#import "Person.h"

@implementation ReceiveSoundAPI
- (int)responseCommandID
{
    return IM_MESSAGE;
}

- (int)responseSubcommandID
{
    return IM_MESS_RECEIVE_SOUND;
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
        int soundTime = [datain readInt];
        int soundLength = [datain readInt];
        NSData *sound = [datain readDataWithLength:soundLength];
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [docPaths lastObject];
        
        
        //获取cache，存自建文件
        NSString *nowCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];

        
        NSString *nowPath = [filePath stringByAppendingPathComponent:@"nowUser.data"];
        Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];
        
        NSString *soundPath = [nowCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/Voice/%ld.aac",nowUser.userName,(long)[[NSDate date] timeIntervalSince1970]]];
        NSString *msgpath = [NSString stringWithFormat:@"Voice/%ld.aac",(long)[[NSDate date] timeIntervalSince1970]];
       

        
        [sound writeToFile:soundPath atomically:YES];
        
        IMMessageEntity *msg = [[IMMessageEntity alloc]initWithMsgID:msgID msgTime:time SessionType:sessionType senderID:fromUserID toUserID:toUserID IMMessageContentType:IMMessageTypeFile msgContent:msgpath];
        return msg;
    };
    return analysis;
}
@end
