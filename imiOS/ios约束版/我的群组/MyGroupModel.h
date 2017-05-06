//
//  MyGruopModel.h
//  ios约束版
//
//  Created by tongho on 16/8/18.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyGroupModel : NSObject

@property (nonatomic, copy) NSString * myGroupName;

@property (nonatomic, assign) int groupId;

@property (nonatomic, strong) NSData *groupIcon;

@property (nonatomic ,assign) int memberNumber;

@end
