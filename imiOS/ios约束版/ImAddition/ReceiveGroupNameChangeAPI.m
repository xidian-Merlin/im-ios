//
//  ReceiveGroupNameChangeAPI.m
//  ImAddition
//
//  Created by tongho on 16/8/17.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "ReceiveGroupNameChangeAPI.h"
#import "IMTcpProtocolHeader.h"
#import "DataInputStream.h"

@implementation ReceiveGroupNameChangeAPI
- (int)responseCommandID
{
    return IM_GROUP;
}

- (int)responseSubcommandID
{
    return IM_GRP_REC_CHANGE_NAME;
}

- (UnrequestAPIAnalysis)unrequestAnalysis
{
    UnrequestAPIAnalysis analysis = (id)^(NSData *data)
    {
        DataInputStream *datain = [[DataInputStream alloc] init];
        datain = [DataInputStream dataInputStreamWithData:data];
        NSNumber* groupID = [NSNumber numberWithInt:[datain readInt]];
        NSNumber* userID = [NSNumber numberWithInt:[datain readInt]];
        NSString* groupName = [datain readUTFWithInt];
        NSArray* changeInfo = @[groupID,userID,groupName];
        return changeInfo;
    };
    return analysis;
}
@end
