//
//  NJMessageCell.h
//


#import <UIKit/UIKit.h>
@class NJMessageModel, NJMessageFrameModel;

@interface NJMessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

//@property (nonatomic, strong) NJMessageModel *message;

@property (nonatomic, strong) NJMessageFrameModel *messageFrame;

@end
