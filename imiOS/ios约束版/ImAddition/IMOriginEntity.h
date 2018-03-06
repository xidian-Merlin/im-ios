//
//  IMOriginEntity.h
//  im
//
//  Created by tongho on 16/7/26.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMOriginEntity : NSObject
{
    NSInteger _ID;
    NSString* _name;
    NSString* _avatarPath;
}
@property(nonatomic,assign,readonly)NSInteger ID;
@property(nonatomic,retain,readonly)NSString* name;
@property(nonatomic,retain)NSString* avatarPath;
@end
