//
//  NJMessageModel.h
//  01-QQ聊天
//
//  Created by apple on 14-5-30.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJGlobal.h"


typedef enum
{
    NJMessageModelTypeMe = 0,
    NJMessageModelTypeOther
}NJMessageModelType;

@interface NJMessageModel : NSObject
/**
 *  正文
 */
@property (nonatomic, copy) NSString *text;
/**
 *  时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  消息类型
 */
@property (nonatomic, assign) NJMessageModelType type;
/**
 *  是否隐藏时间
 */
@property (nonatomic, assign) BOOL hiddenTime;

NJInitH(messageModel)
@end
