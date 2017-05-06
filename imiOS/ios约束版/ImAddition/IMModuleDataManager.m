//
//  IMModuleDataManager.m
//  im
//
//  Created by yuhui wang on 16/7/19.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "IMModuleDataManager.h"
#import "IMModuleManager.h"

@interface IMModuleDataManager()

-(NSString*)getDataPath;

@end

@implementation IMModuleDataManager

-(NSString*)getDataPath
{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [docPaths lastObject];
    NSString* filePath = [documentsPath stringByAppendingPathComponent:@"IMModuleData"];
    return filePath;
}

-(id)initModuleData:(NSArray*)moduleArray
{
    if(self = [super init])
    {
        _moduleArray = moduleArray;
    }
    return self;
}

-(BOOL)archive
{
    @autoreleasepool
    {
        NSMutableData* dataArchiver = [[NSMutableData alloc] init];
        NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataArchiver];
        for (IMModule* module in _moduleArray)
        {
            if([module conformsToProtocol:@protocol(NSCoding)])
            {
                NSString* key = [NSString stringWithFormat:@"%d",module.moduleId];
                [archiver encodeObject:module forKey:key];
            }
        }
        [archiver finishEncoding];
        NSString* filePath = [self getDataPath];
        return [dataArchiver writeToFile:filePath atomically:YES];
    }
}

-(BOOL)unArchive
{
    @autoreleasepool
    {
        NSString* filePath = [self getDataPath];
        NSData* dataUnArchiver = [[NSData alloc] initWithContentsOfFile:filePath];
        if(!dataUnArchiver)
            return NO;
        NSKeyedUnarchiver* unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataUnArchiver];
        if(!unArchiver)
            return NO;
        
        for (IMModule* module in _moduleArray)
        {
            if([module conformsToProtocol:@protocol(NSCoding)])
            {
                NSString* key = [NSString stringWithFormat:@"%d",module.moduleId];
                [unArchiver decodeObjectForKey:key];
            }
        }
        [unArchiver finishDecoding];
    }
    
    return YES;
}
@end
