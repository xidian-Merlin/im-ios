//
//  EditViewController.m
//  静态列表——编辑资料
//
//  Created by Rannie on 13-9-4.
//  Copyright (c) 2013年 Rannie. All rights reserved.
//

#import "EditViewController.h"
#import "Person.h"
#import "SettingModule.h"
#import "MBProgressHUD+NJ.h"
#import "SetNickAPI.h"

#define rSexComponentCount 1
#define rSexRowCount 2

@interface EditViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL isEdit;
}
@property (weak, nonatomic) IBOutlet UILabel *alarm;
@property (assign, nonatomic) bool flag1;
@property (assign, nonatomic) bool flag2;

@end

@implementation EditViewController

#pragma mark -
#pragma mark Initialize

- (void)initSubViews
{
    _qqField.keyboardType = UIKeyboardTypeDefault;
    
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
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //注册为被通知者
    [notificationCenter addObserver:self selector:@selector(keyChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self addDone];
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
     [self.view endEditing:YES];
    if ([_nameField.text isEqualToString:@""])
    {
        _alarm.textColor = [UIColor redColor] ;
        _alarm.text = @"非空!";
        
      //  [_nameField becomeFirstResponder];
        return;
    }
        
    
    if (!isEdit)                                      //表示的其实是如果已经编辑
    {
        
        
      //  UIImage* avatar = [UIImage imageNamed:@"083.png"];
        
         [MBProgressHUD showMessage:@"正在拼命加载ing...."];        
        
        [[SettingModule instance]setNick: _nameField.text success:^(){
            NSLog(@"昵称修改成功！");
            _flag2 = 1;
            _editPerson = [self personOnSubViews];
            [_editDelegate sendEditPerson:_editPerson];
            _editPerson = nil;
            
            [MBProgressHUD hideHUD];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(){
            NSLog(@"main设置失败！");
            _flag2 = 0;
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"修改昵称失败!"];
        }];
    }

    
    if (isEdit)
    {
      //  Person *person = [self personOnSubViews];
        
      //  [_editDelegate sendAddPerson:person];
    }
 
   // [self.navigationController popViewControllerAnimated:YES];
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
    
    
    [[SettingModule instance] setAvatar:image success:^(){
        //此处添加发送包的指令，如果成功就执行以下代
        [_headerButton setImage:image forState:UIControlStateNormal];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        _flag1 = 1;
        
        _editPerson = [self personOnSubViews];
        [_editDelegate sendEditPerson:_editPerson];
        _editPerson = nil;

        
        NSLog(@"修改头像成功！");
    } failure:^(NSString* error){
        _flag1 = 0;
         [picker dismissViewControllerAnimated:YES completion:nil];
         [MBProgressHUD showError:@"修改头像失败!"];
    }];
    
    
   
}


-(void)viewWillAppear:(BOOL)animated{
    
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:YES];
    
    self.navigationController.navigationBarHidden = NO;
    //   view.frame=CGRectMake(0, 480, 0, 0);
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:NO];
    self.navigationController.navigationBarHidden = YES;    
}

//键盘出来的时候调整toolView的位置
-(void) keyChange:(NSNotification *) notify
{
    
    
    if ([_signatureField  isFirstResponder]) {
        
    
    NSDictionary *dict  = notify.userInfo;
    CGRect keyboardFrame = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardFrame.origin.y;
    // 获取动画执行时间
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    // 2.计算需要移动的距离
    CGFloat translationY = keyboardY - self.view.frame.size.height;
    // 通过动画移动view
    /*
     [UIView animateWithDuration:duration animations:^{
     self.view.transform = CGAffineTransformMakeTranslation(0, translationY);
     }];
     */
    /*
     输入框和键盘之间会由一条黑色的线条, 产生线条的原因是键盘弹出时执行动画的节奏和我们让控制器view移动的动画的节奏不一致导致
     */
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        // 需要执行动画的代码
        self.view.transform = CGAffineTransformMakeTranslation(0, translationY);
    } completion:^(BOOL finished) {
        // 动画执行完毕执行的代码
    }];
}
}

-(void) addDone
{
    //TextView的键盘定制回收按钮
    UIToolbar * toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapDone:)];
    UIBarButtonItem * item2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * item3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = @[item2,item1,item3];
    
    _signatureField.inputAccessoryView =toolBar;
}


-(void)tapDone:(id)sender
{
    
    
    // self.textBlock(self.sendTextView.text);
    
    //  self.sendTextView.text = @"";
    [_signatureField resignFirstResponder];
    // self.sendTextView.text
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
