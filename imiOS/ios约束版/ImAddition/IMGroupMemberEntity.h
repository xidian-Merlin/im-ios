//
//  IMGroupMemberEntity.h
//  ImAddition
//
//  Created by yuhui wang on 16/8/17.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMOriginEntity.h"
#import <UIKit/UIKit.h>

@interface IMGroupMemberEntity : NSObject
{
    int _ID;
    BOOL _isManager;
    NSString* _remark;
    UIImage* _avatar;
}

@property(nonatomic,assign,readonly)int ID;
@property(nonatomic,assign,readonly)BOOL isManager;
@property(nonatomic,retain,readonly)NSString* remark;
@property(nonatomic,retain,readonly)UIImage* avatar;

- (instancetype)initWithUserID:(int)ID isManager:(BOOL)isManager remark:(NSString*)remark avatar:(UIImage*)avatar;
@end
