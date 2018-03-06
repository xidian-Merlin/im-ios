//
//  FriendRequest.m
//  ImAddition
//
//  Created by tongho on 16/8/7.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendRequestAPI.h"
#import "IMTcpProtocolHeader.h"
#import "DataInputStream.h"
#import "IMUserEntity.h"


@implementation FriendRequestAPI
- (int)responseCommandID
{
    return IM_USER;
}

- (int)responseSubcommandID
{
    return IM_USER_ADD_REQUEST;
}

- (UnrequestAPIAnalysis)unrequestAnalysis
{
    UnrequestAPIAnalysis analysis = (id)^(NSData *data)
    {
        NSLog(@"处理被添加消息！");
        DataInputStream *datain = [[DataInputStream alloc] init];
        datain = [DataInputStream dataInputStreamWithData:data];
        int userID = [datain readInt];
        int nameLength = [datain readInt];
        NSData *nameData = [datain readDataWithLength:nameLength];
        NSString *name = [[NSString alloc]initWithData:nameData encoding:NSUTF8StringEncoding];
        int nickLength = [datain readInt];
        NSData *nickData = [datain readDataWithLength:nickLength];
        NSString *nick = [[NSString alloc]initWithData:nickData encoding:NSUTF8StringEncoding];
        int avatarLength = [datain readInt];
        NSData *avatarData = [datain readDataWithLength:avatarLength];
        UIImage *avatar = [UIImage imageWithData:avatarData];
        NSString *text = [datain readUTF];
        NSLog(@"文本消息为：%@",text);
        IMUserEntity *user = [[IMUserEntity alloc] initWithID:userID name:name avatar:avatar nick:nick];
        NSArray *requestInfo = @[user,text];
        return requestInfo;
    };
    return analysis;
}
@end
