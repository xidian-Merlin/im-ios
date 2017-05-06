//
//  IMAPIScheduler.h
//  im
//
//  Created by yuhui wang on 16/7/28.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMAPIScheduleProtocol.h"
#import "IMAPIUnrequestScheduleProtocol.h"

typedef struct Response_Server_Data_Head {
    unsigned short commandID;
    unsigned short subcommandID;
    unsigned int packageID;
}ServerDataType;

NS_INLINE ServerDataType IMMakeServerDataType(unsigned short commandID, unsigned short subcommandID,unsigned int packageID)
{
    ServerDataType type;
    type.commandID = commandID;
    type.subcommandID = subcommandID;
    type.packageID = packageID;
    return type;
}


// 应该有自己的专属线程

@interface IMAPIScheduler : NSObject

@property (nonatomic,readonly)dispatch_queue_t apiSchedulerQueue;

+ (instancetype)instance;

/**
 *  注册接口，此接口只应该在SuperAPI中被使用
 *
 *  @param api 接口
 */
- (BOOL)registerApi:(id<IMAPIScheduleProtocol>)api;

/**
 *  注册超时的查询表，此接口只应该在SuperAPI中被使用
 *
 *  @param api 接口
 */
- (void)registerTimeoutApi:(id<IMAPIScheduleProtocol>)api;

/**
 *  接收到服务器端的数据进行解析，对外的接口
 *
 *  @param data 服务器端的数据
 */
- (void)receiveServerData:(NSData*)data forDataType:(ServerDataType)dataType;

/**
 *  注册没有请求，只有返回的api
 *
 *  @param api api
 */
- (BOOL)registerUnrequestAPI:(id<IMAPIUnrequestScheduleProtocol>)api;
/**
 *  发送数据包
 *
 *  @param data 数据包
 */
- (void)sendData:(NSMutableData*)data;
@end
