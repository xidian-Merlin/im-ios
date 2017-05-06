//
//  NJMessageFrameModel.h
//  01-QQ聊天
//
//  Created by apple on 14-5-30.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class NJMessageModel;
#define NJTextFont [UIFont systemFontOfSize:15]
#define NJEdgeInsetsWidth 20


@interface NJMessageFrameModel : NSObject

/**
 *  数据模型
 */
@property (nonatomic, strong) NJMessageModel *message;

/**
 *  时间的frame
 */
@property (nonatomic, assign) CGRect timeF;
/**
 *  头像frame
 */
@property (nonatomic, assign) CGRect iconF;
/**
 *  正文frame
 */
@property (nonatomic, assign) CGRect textF;
/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;
@end
