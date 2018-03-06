//
//  IMUserEntity.h
//  im
//
//  Created by tongho on 16/7/26.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "IMOriginEntity.h"
#import <UIKit/UIKit.h>

@interface IMUserEntity : IMOriginEntity
{
    NSInteger _gender;
    NSString* _nick;
    NSString* _tel;
    NSString* _email;
    NSString* _position;
    UIImage* _avatar;
    NSString* _signature;
    NSString* _remark;
}
@property (nonatomic,assign,readonly)NSInteger gender;
@property (nonatomic,retain,readonly)NSString* nick;
@property (nonatomic,retain,readonly)NSString* tel;
@property (nonatomic,retain,readonly)NSString* email;
@property (nonatomic,retain,readonly)NSString* position;
@property (nonatomic,retain,readonly)UIImage* avatar;
@property (nonatomic,retain,readonly)NSString* signature;
@property (nonatomic,retain,readonly)NSString* remark;

- (instancetype)initWithID:(NSInteger)ID
                      name:(NSString*)name
                avatarPath:(NSString*)avatarPath
                      nick:(NSString*)nick;

- (instancetype)initWithID:(NSInteger)ID
                      name:(NSString*)name
                    avatar:(UIImage*)avatar
                      nick:(NSString*)nick;

-(instancetype)initWithName:(NSString *)name
                     avatar:(UIImage *)avatar
                       nick:(NSString *)nick;

-(instancetype)initWithID:(NSInteger)ID
                     name:(NSString *)name
                     avatar:(UIImage *)avatar
                       nick:(NSString *)nick
                     remark:(NSString*)remark;
@end
