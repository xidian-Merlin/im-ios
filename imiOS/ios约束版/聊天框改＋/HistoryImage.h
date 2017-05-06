//
//  HistoryImage.h
//  CocoaPods
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HistoryImage : NSManagedObject

@property (nonatomic, retain) NSData * headerImage;
@property (nonatomic, retain) NSString * imageText;
@property (nonatomic, retain) NSDate * time;

@end
