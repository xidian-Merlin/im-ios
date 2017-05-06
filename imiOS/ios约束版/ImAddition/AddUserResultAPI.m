//
//  addUserResultAPI.m
//  ImAddition
//
//  Created by yuhui wang on 16/8/7.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "AddUserResultAPI.h"
#import "IMTcpProtocolHeader.h"
#import "DataInputStream.h"
#import "IMUserEntity.h"
#import "IMUnrequestSuperAPI.h"

@implementation AddUserResultAPI
- (int)responseCommandID
{
    return IM_USER;
}

- (int)responseSubcommandID
{
    return IM_USER_ADDED_RESULT;
}

- (UnrequestAPIAnalysis)unrequestAnalysis
{
    UnrequestAPIAnalysis analysis = (id)^(NSData *data)
    {
        DataInputStream *datain = [[DataInputStream alloc] init];
        datain = [DataInputStream dataInputStreamWithData:data];
        NSNumber *addResult = [NSNumber numberWithShort:[datain readShort]];
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
        NSArray *resultInfo = @[addResult,user,text];
        return resultInfo;
    };
    return analysis;
}
@end
