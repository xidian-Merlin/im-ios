//
//  IMGroupEntity.m
//  im
//
//  Created by tongho on 16/7/26.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "IMGroupEntity.h"

@implementation IMGroupEntity

- (id)initWithGroupID:(int)ID name:(NSString*)name memberNumber:(int)memberNumber
{
    self = [super init];
    if (self)
    {
        _ID = ID;
        _name = [name copy];
        _avatarPath = nil;
        _groupCreatorId = 0; // 未知时设置为 0
        _memberNumber = memberNumber;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    if (![object isKindOfClass:[IMGroupEntity class]]) {
        return NO;
    }
    
    IMGroupEntity* group = (IMGroupEntity*)object;
    if (group.ID == self.ID &&
        [group.name isEqualToString:self.name])
    {
        return YES;
    }
    return NO;
}

@end
