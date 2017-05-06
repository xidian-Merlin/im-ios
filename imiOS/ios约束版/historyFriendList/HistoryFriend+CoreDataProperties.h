//
//  HistoryFriend+CoreDataProperties.h
//  ios约束版
//
//  Created by tongho on 16/7/23.
//  Copyright © 2016年 tongho. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HistoryFriend.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryFriend (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *lastMessage;
@property (nullable, nonatomic, retain) NSString *nickname;
@property (nullable, nonatomic, retain) NSDate *timestape;
@property (nullable, nonatomic, retain) NSData *icon;

@end

NS_ASSUME_NONNULL_END
