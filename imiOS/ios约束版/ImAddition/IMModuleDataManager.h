//
//  IMModuleDataManager.h
//  im
//
//  Created by yuhui wang on 16/7/19.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMModuleDataManager : NSObject
{
    NSArray*                    _moduleArray;
}

-(id)initModuleData:(NSArray*)moduleArray;
-(BOOL)archive;
-(BOOL)unArchive;
@end
