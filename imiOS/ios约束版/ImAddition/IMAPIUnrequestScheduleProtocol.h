//
//  IMAPIUnrequestScheduleProtocol.h
//  im
//
//  Created by yuhui wang on 16/7/31.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^UnrequestAPIAnalysis)(NSData* data);

@protocol IMAPIUnrequestScheduleProtocol <NSObject>
@required
/**
 *  数据包中的commandID
 *
 *  @return commandID
 */
- (int)responseCommandID;

/**
 *  数据包中的subcommandID
 *
 *  @return subcommandID
 */
- (int)responseSubcommandID;

/**
 *  解析数据包
 *
 *  @return 解析数据包的block
 */
- (UnrequestAPIAnalysis)unrequestAnalysis;

@end
