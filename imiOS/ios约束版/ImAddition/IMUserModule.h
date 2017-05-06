//
//  IMUserModule.h
//  im
//
//  Created by yuhui wang on 16/7/29.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMRootModule.h"
#import "IMOriginModuleProtocol.h"
#import "IMUserEntity.h"

@interface IMUserModule : IMRootModule<IMOriginModuleProtocol>
+ (IMUserModule*)shareInstance;
- (IMUserEntity*)myUserEntity;
- (NSArray*)getAllUserId;
@end
