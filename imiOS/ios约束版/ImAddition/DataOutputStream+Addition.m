//
//  DataOutputStream+Addition.m
//  ImAddition
//
//  Created by yuhui wang on 16/8/1.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "DataOutputStream+Addition.h"

@implementation DataOutputStream (Addition)

-(void)writeTcpProtocolHeaderWithCommandID:(short)commandID subcommandID:(short)subcommandID packageID:(int)packageID
{
    [self writeShort:commandID];
    [self writeShort:subcommandID];
    [self writeInt:packageID];
}

-(void)writeH1:(char)protocolVersion encryptType:(char)encryptType serviceType:(short)serviceType dataFiledLength:(int)dataFiledLength packageID:(int)packageID
{
    [self writeChar:protocolVersion];
    [self writeChar:encryptType];
    [self writeShort:serviceType];
    [self writeInt:dataFiledLength];
    [self writeInt:packageID];
}

-(void)writeCheckCode1
{
    unsigned char checkOne[16] = {'0', '0', '0', '0', '0','0','0', '0', '0', '0', '0','0','0', '0', '0', '0'};
    NSData *checkCode1 = [NSData dataWithBytes:checkOne length:sizeof(checkOne)];
    
    [self directWriteBytes:checkCode1];
}
-(void)writeCheckCode2
{
    unsigned char checktwo[16] = {'0', '0', '0', '0', '0','0','0', '0', '0', '0', '0','0','0', '0', '0', '0'};
    NSData *checkCode2 = [NSData dataWithBytes:checktwo length:sizeof(checktwo)];
    
    [self directWriteBytes:checkCode2];
}
@end
