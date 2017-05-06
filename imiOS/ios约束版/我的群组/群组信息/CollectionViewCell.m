//
//  CollectionViewCell.m
//  testTX
//
//  Created by hackxhj on 15/9/7.
//  Copyright (c) 2015年 hackxhj. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray * nibs=[[NSBundle mainBundle] loadNibNamed:@"CollectionViewCell" owner:self options:nil];
        for (id obj in nibs) {
            if ([obj isKindOfClass:[CollectionViewCell class]]) {
                self =(CollectionViewCell *)obj;
            }
        }
        
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    _tx.userInteractionEnabled=YES;
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickIMG:)];
    [_tx addGestureRecognizer:gesture];
    
    _tx.layer.cornerRadius=_tx.frame.size.width/2;
    _tx.clipsToBounds=YES;
}
-(void)clickIMG:(id)sender
{

    if(_delbtn.isHidden==NO)
    {
       [self.delagate clickImg:sender  isDel:YES];
    }else
    {
      [self.delagate clickImg:sender isDel:NO];
    }
    
}

- (IBAction)clickDEL:(id)sender
{
    [self.delagate delclick:sender];
}


@end
