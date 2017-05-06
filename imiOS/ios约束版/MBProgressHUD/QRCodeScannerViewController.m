//
//  QRCodeScannerViewController.m
//  QRCodeDemo
//
//  Created by yuhui wang on 2016/10/21.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "QRCodeScannerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ShadowView.h"
#import "ContactModule.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+NJ.h"
#import "ShowMessageTableViewController.h"
#import "IMUserEntity.h"
#import "ImdbModel.h"
#import "HfDbModel.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define customShowSize CGSizeMake(200, 200);

@interface QRCodeScannerViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** 输入数据源 */
@property (nonatomic, strong) AVCaptureDeviceInput *input;
/** 输出数据源 */
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
/** 输入输出的中间桥梁 负责把捕获的音视频数据输出到输出设备中 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 相机拍摄预览图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layerView;
/** 预览图层尺寸 */
@property (nonatomic, assign) CGSize layerViewSize;
/** 有效扫码范围 */
@property (nonatomic, assign) CGSize showSize;

@property (nonatomic, strong) ShadowView *shadowView;

@property (nonatomic, strong) ImdbModel *imdbModel;


@end

@implementation QRCodeScannerViewController

-(void)creatScanQR{
    
    /** 创建输入数据源 */
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];  //获取摄像设备
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];  //创建输出流
    
    /** 创建输出数据源 */
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];  //设置代理 在主线程里刷新
    
    /** Session设置 */
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];   //高质量采集
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    //设置扫码支持的编码格式
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    /** 扫码视图 */
    //扫描框的位置和大小
    self.layerView = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.layerView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.layerView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    // 将扫描框大小定义为属行, 下面会有调用
    self.layerViewSize = CGSizeMake(_layerView.frame.size.width, _layerView.frame.size.height);
    
}

#pragma mark - 实现代理方法, 完成二维码扫描
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count > 0) {
        
        [self.shadowView stopTimer];
        
        //停止扫描
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        // 扫描成功后利用UserID获取详细信息，并跳转至详细信息页面
        [MBProgressHUD showMessage:@"正在加载..."];
        [[ContactModule instance]GetUserInfo:[metadataObject.stringValue intValue] success:^(IMUserEntity *user){   //搜索网络，获取当前的联系人资料
            [MBProgressHUD hideHUD];
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
            ShowMessageTableViewController * test2obj = [secondStoryBoard           instantiateViewControllerWithIdentifier:@"showMessageController"];
            
            test2obj.userId = [metadataObject.stringValue intValue];
            test2obj.userName = user.name;
            test2obj.nickName = user.nick;
            test2obj.nickkName2 =  user.nick;
            test2obj.icon = user.avatar;
            [self.navigationController pushViewController:test2obj animated:YES];
            //网络搜索成功，将联系人的表与会话表更新
            
            
            
            
            
            UIImage * avatar = user.avatar;
            if (nil == user.avatar) {
                avatar = [UIImage imageNamed:@"tn.9.png"];
            }
            
            NSData *avatarData;
            if (UIImagePNGRepresentation(avatar)) {
                avatarData = UIImagePNGRepresentation(avatar);
            }else {
                avatarData = UIImageJPEGRepresentation(avatar, 1.0);
            }
            
            //跟新联系人界面
            _imdbModel = [[ImdbModel alloc]init];
            [_imdbModel setIcon:avatarData withUserId:[metadataObject.stringValue intValue]];   //更新头像
            
             //如果原昵称与备注一样，则说明没有备注,将备注变为新昵称
            [_imdbModel set:user.nick withUserId:[metadataObject.stringValue intValue]];
           
            //否则，有定义备注，则备注不用更新
            
            //跟新会话界面
            HfDbModel* hfDbModel1 = [[HfDbModel alloc] init];
            
            BOOL create1 = [hfDbModel1 createTable];
            if (create1) {
                
                [hfDbModel1 setIcon:avatarData withUserId:[metadataObject.stringValue intValue] style:1];
            }
            
            
            [hfDbModel1 set:user.nick withUserId:[metadataObject.stringValue intValue] style:1];
           
            //否则，有定义备注，则备注不用更新
            
            
            
        } failure:^(NSString* error){       //如果网络搜索失败，那么使用本地的用户信息
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"加载失败"];
            
        }];//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", metadataObject.stringValue] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //显示范围
    self.showSize = customShowSize;
    //调用
    [self creatScanQR];
    //添加拍摄图层
    [self.view.layer addSublayer:self.layerView];
    //开始二维码
    [self.session startRunning];
    //设置可用扫码范围
    [self allowScanRect];
    
    //添加上层阴影视图
    self.shadowView = [[ShadowView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 64)];
    [self.view addSubview:self.shadowView];
    self.shadowView.showSize = self.showSize;
    
    
    //添加扫码相册按钮
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册中选" style:UIBarButtonItemStylePlain target:self action:@selector(takeQRCodeFromPic:)];
    
    // Do any additional setup after loading the view.
}

/** 配置扫码范围 */
-(void)allowScanRect{
    
    
    /** 扫描是默认是横屏, 原点在[右上角]
     *  rectOfInterest = CGRectMake(0, 0, 1, 1);
     *  AVCaptureSessionPresetHigh = 1920×1080   摄像头分辨率
     *  需要转换坐标 将屏幕与 分辨率统一
     */
    
    //剪切出需要的大小位置
    CGRect shearRect = CGRectMake((self.layerViewSize.width - self.showSize.width) / 2,
                                  (self.layerViewSize.height - self.showSize.height) / 2,
                                  self.showSize.height,
                                  self.showSize.height);
    
    
    CGFloat deviceProportion = 1920.0 / 1080.0;
    CGFloat screenProportion = self.layerViewSize.height / self.layerViewSize.width;
    
    //分辨率比> 屏幕比 ( 相当于屏幕的高不够)
    if (deviceProportion > screenProportion) {
        //换算出 分辨率比 对应的 屏幕高
        CGFloat finalHeight = self.layerViewSize.width * deviceProportion;
        // 得到 偏差值
        CGFloat addNum = (finalHeight - self.layerViewSize.height) / 2;
        
        // (对应的实际位置 + 偏差值)  /  换算后的屏幕高
        self.output.rectOfInterest = CGRectMake((shearRect.origin.y + addNum) / finalHeight,
                                                shearRect.origin.x / self.layerViewSize.width,
                                                shearRect.size.height/ finalHeight,
                                                shearRect.size.width/ self.layerViewSize.width);
        
    }else{
        
        CGFloat finalWidth = self.layerViewSize.height / deviceProportion;
        
        CGFloat addNum = (finalWidth - self.layerViewSize.width) / 2;
        
        self.output.rectOfInterest = CGRectMake(shearRect.origin.y / self.layerViewSize.height,
                                                (shearRect.origin.x + addNum) / finalWidth,
                                                shearRect.size.height / self.layerViewSize.height,
                                                shearRect.size.width / finalWidth);
    }
    
}

#pragma mark - 相册中读取二维码
/* navi按钮实现 */
-(void)takeQRCodeFromPic:(UIBarButtonItem *)leftBar{
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请更新系统至8.0以上!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            
            UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
            pickerC.delegate = self;
            
            pickerC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;  //来自相册
            
            [self presentViewController:pickerC animated:YES completion:NULL];
            
        }else{
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    //2.初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        //监测到的结果数组  放置识别完之后的数据
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        //判断是否有数据（即是否是二维码）
        if (features.count >=1) {
            /**结果对象 */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            
            // 扫描成功后利用UserID获取详细信息，并跳转至详细信息页面
            [MBProgressHUD showMessage:@"正在加载..."];
            
            [[ContactModule instance]GetUserInfo:[scannedResult intValue] success:^(IMUserEntity *user){   //搜索网络，获取当前的联系人资料
                [MBProgressHUD hideHUD];
                UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
                ShowMessageTableViewController * test2obj = [secondStoryBoard           instantiateViewControllerWithIdentifier:@"showMessageController"];
                
                test2obj.userId = [scannedResult intValue];
                test2obj.userName = user.name;
                test2obj.nickName = user.nick;
                test2obj.nickkName2 =  user.nick;
                test2obj.icon = user.avatar;
                [self.navigationController pushViewController:test2obj animated:YES];
                //网络搜索成功，将联系人的表与会话表更新
                
                
                
                
                
                UIImage * avatar = user.avatar;
                if (nil == user.avatar) {
                    avatar = [UIImage imageNamed:@"tn.9.png"];
                }
                
                NSData *avatarData;
                if (UIImagePNGRepresentation(avatar)) {
                    avatarData = UIImagePNGRepresentation(avatar);
                }else {
                    avatarData = UIImageJPEGRepresentation(avatar, 1.0);
                }
                
                //跟新联系人界面
                _imdbModel = [[ImdbModel alloc]init];
                [_imdbModel setIcon:avatarData withUserId:[scannedResult intValue]];   //更新头像
                
                //如果原昵称与备注一样，则说明没有备注,将备注变为新昵称
                [_imdbModel set:user.nick withUserId:[scannedResult intValue]];
                
                //否则，有定义备注，则备注不用更新
                
                //跟新会话界面
                HfDbModel* hfDbModel1 = [[HfDbModel alloc] init];
                
                BOOL create1 = [hfDbModel1 createTable];
                if (create1) {
                    
                    [hfDbModel1 setIcon:avatarData withUserId:[scannedResult intValue] style:1];
                }
                
                
                [hfDbModel1 set:user.nick withUserId:[scannedResult intValue] style:1];
                
                //否则，有定义备注，则备注不用更新
                
                
                
            } failure:^(NSString* error){       //如果网络搜索失败，那么使用本地的用户信息
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"加载失败"];
                
            }];//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", metadataObject.stringValue] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //        [alert show];

            
            
            
            
            
            
           // UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:scannedResult delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
          //  [alertView show];
            
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated{
    
    // self.hidesBottomBarWhenPushed=YES;
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:YES];
    
    
    //  self.result =  [_imdbModel  queryAll];
    // [self.tableView reloadData];              //界面即将出现时刷新界面
    self.navigationController.navigationBarHidden = NO;
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:NO];
    
    // self.navigationController.navigationBarHidden = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
