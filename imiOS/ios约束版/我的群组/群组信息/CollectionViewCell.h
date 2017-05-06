//
//  CollectionViewCell.h
//  testTX
//
//  Created by hackxhj on 15/9/7.
//  Copyright (c) 2015年 hackxhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionViewCellDelagate <NSObject>

-(void)clickImg:(UITapGestureRecognizer *)recognizer  isDel:(BOOL)isDel;
-(void)delclick:(id)sender;

@end
@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *mem;
@property (weak, nonatomic) IBOutlet UIImageView *tx;

@property (weak, nonatomic) IBOutlet UIButton *delbtn;

@property(nonatomic,weak)id<CollectionViewCellDelagate>delagate;
@end
