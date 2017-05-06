//
//  IMUserEntity.m
//  im
//
//  Created by yuhui wang on 16/7/26.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMUserEntity.h"

@implementation IMUserEntity
@synthesize gender = _gender;
@synthesize nick = _nick;
@synthesize tel = _tel;
@synthesize email = _email;
@synthesize position = _position;
@synthesize avatar = _avatar;
@synthesize signature = _signature;
@synthesize remark = _remark;

- (instancetype)initWithID:(NSInteger)ID
                      name:(NSString*)name
                avatarPath:(NSString*)avatarPath
                      nick:(NSString*)nick

{
    self = [super init];
    if (self)
    {
        _ID = ID;
        _name = [name copy];
        _avatarPath = [avatarPath copy];
        _nick = [nick copy];
        _gender = 0; // 0：未知，1：男，2：女
        _avatar = nil;
        _tel = nil;
        _email = nil;
        _position = nil;
        _signature = nil;
        _remark = nil;
    }
    return self;
}

-(instancetype)initWithID:(NSInteger)ID name:(NSString *)name avatar:(UIImage *)avatar nick:(NSString *)nick
{
    self = [super init];
    if (self)
    {
        _ID = ID;
        _name = [name copy];
        _avatar = [avatar copy];
        _nick = [nick copy];
        _gender = 0; // 0：未知，1：男，2：女
        _avatarPath = nil;
        _tel = nil;
        _email = nil;
        _position = nil;
        _signature = nil;
        _remark = nil;
    }
    return self;
}

-(instancetype)initWithName:(NSString *)name avatar:(UIImage *)avatar nick:(NSString *)nick
{
    self = [super init];
    if (self)
    {
        _name = [name copy];
        _avatar = [avatar copy];
        _nick = [nick copy];
        _gender = 0; // 0：未知，1：男，2：女
        _ID = 0; // 0:未知
        _avatarPath = nil;
        _tel = nil;
        _email = nil;
        _position = nil;
        _signature = nil;
        _remark = nil;
    }
    return self;
}

-(instancetype)initWithID:(NSInteger)ID
                     name:(NSString *)name
                     avatar:(UIImage *)avatar
                       nick:(NSString *)nick
                     remark:(NSString*)remark
{
    self = [super init];
    if (self)
    {
        _name = [name copy];
        _avatar = [avatar copy];
        _nick = [nick copy];
        _remark = [remark copy];
        _gender = 0; // 0：未知，1：男，2：女
        _ID = ID;
        _avatarPath = nil;
        _tel = nil;
        _email = nil;
        _position = nil;
        _signature = nil;
        
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (object == self)
    {
        return YES;
    }
    if (![object isKindOfClass:[IMUserEntity class]])
    {
        return NO;
    }
    IMUserEntity* user = (IMUserEntity*)object;
    if (self.ID == user.ID)
    {
        return YES;
    }
    return NO;
}

@end
