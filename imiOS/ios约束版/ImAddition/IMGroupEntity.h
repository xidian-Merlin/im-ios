//
//  IMGroupEntity.h
//  im
//
//  Created by yuhui wang on 16/7/26.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMOriginEntity.h"


@interface IMGroupEntity : IMOriginEntity

/**
 *  群主
 */
@property (nonatomic,assign)int groupCreatorId;

/**
 * 群成员
 */
@property (nonatomic,assign)int memberNumber;


/**
 *  群组初始化
 *
 *  @param ID           群ID
 *  @param name         群名
 *  @param memberNumber 群成员数
 *
 */
- (id)initWithGroupID:(int)ID name:(NSString*)name memberNumber:(int)memberNumber;

@end
