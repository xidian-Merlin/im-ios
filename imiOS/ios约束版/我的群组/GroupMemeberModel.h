//
//  GroupMemeberModel.h
//  ios约束版
//
//  Created by tongho on 16/8/18.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupMemeberModel : NSObject

@property (nonatomic, strong) NSString *memberName;
@property (nonatomic, assign) int memberId;
@property (nonatomic, assign) int permit;  //权限
@property (nonatomic, strong) NSData *icon;   //头像



@end
