//
//  MoreView.h
//  MyKeyBoard
//


#import <UIKit/UIKit.h>

typedef void (^MoreBlock) (NSInteger index);


@interface MoreView : UIView

-(void)setMoreBlock:(MoreBlock) block;

@end
