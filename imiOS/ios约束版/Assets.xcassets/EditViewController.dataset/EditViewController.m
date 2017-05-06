//
//  EditViewController.m
//  静态列表——编辑资料
//
//  Created by Rannie on 13-9-4.
//  Copyright (c) 2013年 Rannie. All rights reserved.
//

#import "EditViewController.h"
#import "Person.h"

#define rSexComponentCount 1
#define rSexRowCount 2

@interface EditViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL isEdit;
}

@end

@implementation EditViewController

#pragma mark -
#pragma mark Initialize

- (void)initSubViews
{
    _qqField.keyboardType = UIKeyboardTypeNumberPad;
    
    UIPickerView *sexPicker = [[UIPickerView alloc] init];
    sexPicker.showsSelectionIndicator = YES;
    sexPicker.delegate = self;
    sexPicker.dataSource = self;
    _sexField.inputView = sexPicker;
    _sexField.text = @"男";
    
    UIDatePicker *birthPicker = [[UIDatePicker alloc] init];
    birthPicker.datePickerMode = UIDatePickerModeDate;
    birthPicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stdDate = @"1990-01-01";
    birthPicker.date = [formatter dateFromString:stdDate];
    [birthPicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    _birthdayField.inputView = birthPicker;
    
    isEdit = NO;
}

- (void)setupEditPerson
{
    if (_editPerson)
    {
        [_headerButton setImage:_editPerson.headerImage forState:UIControlStateNormal];
        _nameField.text = _editPerson.name;
        _qqField.text = _editPerson.tel;
        _sexField.text = _editPerson.sex;
        _birthdayField.text = _editPerson.birthday;
        _signatureField.text = _editPerson.signature;
      //  isEdit = YES;
    }
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSubViews];
    [self setupEditPerson];
}

#pragma mark -
#pragma mark Actions

- (void)chooseDate:(UIDatePicker *)datePicker
{
    NSDate *date = datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    _birthdayField.text = dateString;
}

- (IBAction)savePerson:(id)sender
{
    if ([_nameField.text isEqualToString:@""])
    {
        _nameField.text = @"昵称不能为空!";
        [_nameField becomeFirstResponder];
        return;
    }
        
    
    if (!isEdit)
    {
        _editPerson = [self personOnSubViews];
        [_editDelegate sendEditPerson:_editPerson];
        _editPerson = nil;
    }
    if (isEdit)
    {
      //  Person *person = [self personOnSubViews];
        
      //  [_editDelegate sendAddPerson:person];
    }
 
    [self.navigationController popViewControllerAnimated:YES];
}

- (Person *)personOnSubViews
{
    Person *person = [[Person alloc] init];
    person.name = _nameField.text;
    person.headerImage = _headerButton.imageView.image;
    person.tel = _qqField.text;
    person.sex = _sexField.text;
    person.birthday = _birthdayField.text;
    person.signature = _signatureField.text;
    
    return person;
}

- (IBAction)chooseHeader
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -
#pragma mark PickerView DelegateMethod

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return rSexComponentCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return rSexRowCount;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (0 == row)
    {
        return @"男";
    }
    else
    {
        return @"女";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (0 == row)
    {
        _sexField.text = @"男";
    }
    else
    {
        _sexField.text = @"女";
    }
}

#pragma mark -
#pragma mark ImagePicker DelegateMethod

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    const NSString *ImageIdentifier = @"UIImagePickerControllerEditedImage";
    UIImage *image = info[ImageIdentifier];
    [_headerButton setImage:image forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:YES];
    //   view.frame=CGRectMake(0, 480, 0, 0);
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:NO];
}


@end
