//
//  DataOutputStream+Addition.h
//  ImAddition
//
//  Created by tongho on 16/8/1.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "DataOutputStream.h"

@interface DataOutputStream (Addition)
-(void)writeTcpProtocolHeaderWithCommandID:(short)commandID subcommandID:(short)subcommandID packageID:(int)packageID;
-(void)writeH1:(char)protocolVersion encryptType:(char)encryptType serviceType:(short)serviceType dataFiledLength:(int)dataFiledLength packageID:(int)packageID;
-(void)writeCheckCode1;
-(void)writeCheckCode2;
@end
