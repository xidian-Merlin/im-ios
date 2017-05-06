//
//  IMAPIScheduleProtocol.h
//  im
//
//  Created by yuhui wang on 16/7/28.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^Analysis)(NSData* data);
typedef NSMutableData*(^Package)(id object,uint16_t packageID);

@protocol IMAPIScheduleProtocol <NSObject>
@required



/**
 *  请求超时时间
 *
 *  @return 超时时间
 */
- (int)requestTimeOutTimeInterval;

/**
 *  请求的commandID
 *
 *  @return 对应的commandID
 */
- (int)requestCommandID;

/**
 *  请求返回的commandID
 *
 *  @return 对应的commandID
 */
- (int)responseCommandID;

/**
 *  请求的subcommandID
 *
 *  @return 对应的subcommandID
 */
- (int)requestSubcommandID;

/**
 *  请求返回的subcommandID
 *
 *  @return 对应的subcommandID
 */
- (int)responseSubcommandID;
/**
 *  解析数据的block
 *
 *  @return 解析数据的block
 */
- (Analysis)analysisReturnData;

/**
 *  打包数据的block
 *
 *  @return 打包数据的block
 */

- (Package)packageRequestObject;

@end
