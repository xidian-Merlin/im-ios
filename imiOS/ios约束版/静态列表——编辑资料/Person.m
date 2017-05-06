//
//  Person.m
//  静态列表——编辑资料
//
//  Created by Rannie on 13-9-4.
//  Copyright (c) 2013年 Rannie. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_headerImage forKey:@"header"];
    [aCoder encodeObject:_tel forKey:@"qq"];
    [aCoder encodeObject:_sex forKey:@"sex"];
    [aCoder encodeObject:_birthday forKey:@"birthday"];
    [aCoder encodeObject:_signature forKey:@"signature"];
    [aCoder encodeObject:_userId forKey:@"userId"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    _name = [aDecoder decodeObjectForKey:@"name"];
    _userName = [aDecoder decodeObjectForKey:@"userName"];
    _headerImage = [aDecoder decodeObjectForKey:@"header"];
    _tel = [aDecoder decodeObjectForKey:@"qq"];
    _sex = [aDecoder decodeObjectForKey:@"sex"];
    _birthday = [aDecoder decodeObjectForKey:@"birthday"];
    _signature = [aDecoder decodeObjectForKey:@"signature"];
    _userId = [aDecoder decodeObjectForKey:@"userId"];
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Person-%p, name: %@, qq: %@, sex: %@.", self, _name, _tel, _sex];
}

@end
