//
//  Compress.h
//  ios约束版
//
//  Created by tongho on 16/12/4.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Compress : NSObject
//压缩图片至(size)kb 以下
+ (NSData*)compressPicture:(UIImage *)image withDataSize:(int)size;
@end
