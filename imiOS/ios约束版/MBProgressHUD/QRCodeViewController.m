//
//  ViewController.m
//  QRCodeDemo
//
//  Created by tongho on 2016/10/20.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "QRCodeViewController.h"
#import "QRCodeFactory.h"

@interface QRCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *QRCode; 

@end

@implementation QRCodeViewController
- (IBAction)creatQRCode:(id)sender {
    _QRCode.image = [QRCodeFactory qrImageForIntNumber:1024 imageSize:(CGFloat)200 logoImageSize:50];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _QRCode.image = [UIImage imageNamed:@"网信院徽128×128"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStylePlain target:self action:@selector(changeToScanner)];
}

- (void)changeToScanner
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
    
    UIViewController * test = [mainStoryBoard instantiateViewControllerWithIdentifier:@"scanner"];
    
    [self.navigationController pushViewController:test animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
