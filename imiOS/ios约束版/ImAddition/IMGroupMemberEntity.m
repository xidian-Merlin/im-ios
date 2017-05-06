//
//  IMGroupMemberEntity.m
//  ImAddition
//
//  Created by yuhui wang on 16/8/17.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMGroupMemberEntity.h"

@implementation IMGroupMemberEntity
@synthesize ID = _ID;
@synthesize remark = _remark;
@synthesize isManager = _isManager;
@synthesize avatar =_avatar;

- (instancetype)initWithUserID:(int)ID isManager:(BOOL)isManager remark:(NSString*)remark avatar:(UIImage*)avatar
{
    self = [super init];
    if (self) {
        _ID = ID;
        _isManager = isManager;
        _remark = remark;
        _avatar = avatar;
    }
    return self;
}
@end
