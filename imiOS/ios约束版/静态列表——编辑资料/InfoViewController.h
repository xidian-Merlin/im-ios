//
//  InfoViewController.h
//  静态列表——编辑资料
//
//  Created by Rannie on 13-9-4.
//  Copyright (c) 2013年 Rannie. All rights reserved.
//

#import <UIKit/UIKit.h>




@class Person;




@protocol InfoViewControllerDelegate <NSObject>

@required
- (void)refreshPerson:(Person *)personData;

@end

@interface InfoViewController : UITableViewController

@property (strong, nonatomic) Person *person;

@property (weak, nonatomic) id<InfoViewControllerDelegate> infoDele;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;





@end
