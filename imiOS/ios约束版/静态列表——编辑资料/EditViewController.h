//
//  EditViewController.h
//  静态列表——编辑资料
//
//  Created by Rannie on 13-9-4.
//  Copyright (c) 2013年 Rannie. All rights reserved./Users/tongho/Documents/ios约束版/ios约束版/静态列表——编辑资料/EditViewController.m
//

#import <UIKit/UIKit.h>

@class Person;

@protocol EditViewControllerDelegate <NSObject>

@optional
- (void)sendAddPerson:(Person *)person;
- (void)sendEditPerson:(Person *)ePerson;

@end

@interface EditViewController : UITableViewController

- (IBAction)savePerson:(id)sender;
- (IBAction)chooseHeader;

@property (weak, nonatomic) id<EditViewControllerDelegate> editDelegate;
@property (strong, nonatomic) Person *editPerson;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *qqField;
@property (weak, nonatomic) IBOutlet UITextField *sexField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayField;
@property (weak, nonatomic) IBOutlet UITextView *signatureField;

@end
