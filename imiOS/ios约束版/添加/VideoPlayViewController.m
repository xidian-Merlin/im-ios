//
//  VideoPlayViewController.m
//  ios约束版
//
//  Created by tongho on 16/8/13.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "VideoPlayViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

enum {
    DirectPlayBtnTag = 10,
    FullScreenPlayBtnTag
};

@interface VideoPlayViewController () <AVPlayerViewControllerDelegate> {
    AVPlayer *_player; /**< 媒体播放器 */
    AVPlayerViewController *_playerViewController; /**< 媒体播放控制器 */
    
}

@property (nonatomic, strong) UIButton *directPlayBtn;     /**< 直接播放按钮 */
@property (nonatomic, strong) UIButton *fullscreenPlayBtn; /**< 全屏播放 */

@property (nonatomic, strong) AVPlayer *player; /**< 媒体播放器 */
@property (nonatomic, strong) AVPlayerViewController *playerViewController; /**< 媒体播放控制器 */

- (void)initializeUserInterface; /**< 初始化用户界面 */

@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
   // _videoPath=[[NSBundle mainBundle] pathForResource:@"Miniature" ofType:@"mp4"];
    if (NO == _isFinished) {
        
        //在此处向服务器发送请求，请求成功，将播放地址賦新值，更新数据库内容，
        
      
    }
    
    
    
}

#pragma mark *** Initialize methods ***

- (void)initializeUserInterface {
    self.title = @"视频播放器";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 加载视图
    [self.view addSubview:self.directPlayBtn];
    [self.view addSubview:self.fullscreenPlayBtn];
}

#pragma mark *** Events ***
- (void)respondsToButton:(UIButton *)sender {
    switch (sender.tag) {
            // 直接播放
        case DirectPlayBtnTag: {
            
            if (_player) {
                [_player pause];
                _player = nil;
            }
            
            if (_playerViewController) {
                [_playerViewController removeFromParentViewController];
                [_playerViewController.view removeFromSuperview];
                _playerViewController = nil;
            }
            
            // 1、获取媒体资源地址
        //    NSString *path = [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"宣传资料.mp4"];
            NSURL *sourceMovieURL = [NSURL fileURLWithPath:_videoPath];
            
            // 2、创建AVPlayerItem
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:sourceMovieURL];
            // 3、根据AVPlayerItem创建媒体播放器
            _player = [AVPlayer playerWithPlayerItem:playerItem];
            // 4、创建AVPlayerLayer，用于呈现视频
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
            // 5、设置显示大小和位置
            playerLayer.bounds = CGRectMake(0, 0, 350, 300);
            playerLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), 64 + CGRectGetMidY(playerLayer.bounds) + 30);
            // 6、设置拉伸模式
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            // 7、获取播放持续时间
            NSLog(@"%lld", playerItem.duration.value);
            [_player play];
            [self.view.layer addSublayer:playerLayer];
        }
            break;
            // 全屏播放
        case FullScreenPlayBtnTag: {
            
            if (_player) {
                [_player pause];
                _player = nil;
            }
            
            // 初始化URL资源地址
            
            // 获取网络资源地址
            // + (nullable instancetype)URLWithString:(NSString *)URLString;
            
            // 1、获取本地资源地址
          //  NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"宣传资料.mp4"]];
            NSURL *url = [NSURL fileURLWithPath:_videoPath];
            // 2、初始化媒体播放控制器
            if (_playerViewController) {
                _playerViewController = nil;
            }
            // 3、配置媒体播放控制器
            _playerViewController = [[AVPlayerViewController alloc]  init];
            // 设置媒体源数据
            _playerViewController.player = [AVPlayer playerWithURL:url];
            // 设置拉伸模式
            _playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
            // 设置是否显示媒体播放组件
            _playerViewController.showsPlaybackControls = YES;
            // 设置大力
            _playerViewController.delegate = self;
            // 播放视频
            [_playerViewController.player play];
            // 设置媒体播放器视图大小
            _playerViewController.view.bounds = CGRectMake(0, 0, 350, 300);
            _playerViewController.view.center = CGPointMake(CGRectGetMidX(self.view.bounds), 64 + CGRectGetMidY(_playerViewController.view.bounds) + 30);
            // 4、推送播放
            // 推送至媒体播放器进行播放
            // [self presentViewController:_playerViewController animated:YES completion:nil];
            // 直接在本视图控制器播放
            [self addChildViewController:_playerViewController];
            [self.view addSubview:_playerViewController.view];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark *** AVPlayerViewControllerDelegate ***
- (void)playerViewControllerWillStartPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)playerViewControllerDidStartPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)playerViewControllerWillStopPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)playerViewControllerDidStopPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)playerViewController:(AVPlayerViewController *)playerViewController failedToStartPictureInPictureWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
#pragma mark *** Getters ***
- (UIButton *)directPlayBtn {
    if (!_directPlayBtn) {
        _directPlayBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _directPlayBtn.bounds = CGRectMake(0, 0, 100, 40);
        _directPlayBtn.center = CGPointMake(CGRectGetMidX(self.view.bounds) - CGRectGetMidX(_directPlayBtn.bounds), CGRectGetMidY(self.view.bounds) + 100);
        _directPlayBtn.tag = DirectPlayBtnTag;
        [_directPlayBtn setTitle:@"直接播放" forState:UIControlStateNormal];
        [_directPlayBtn addTarget:self action:@selector(respondsToButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _directPlayBtn;
}

- (UIButton *)fullscreenPlayBtn {
    if (!_fullscreenPlayBtn) {
        _fullscreenPlayBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _fullscreenPlayBtn.bounds = CGRectMake(0, 0, 100, 30);
        _fullscreenPlayBtn.center = CGPointMake(CGRectGetMidX(self.view.bounds) + CGRectGetMidX(_fullscreenPlayBtn.bounds), CGRectGetMidY(self.view.bounds) + 100);
        _fullscreenPlayBtn.tag = FullScreenPlayBtnTag;
        [_fullscreenPlayBtn setTitle:@"全屏播放" forState:UIControlStateNormal];
        [_fullscreenPlayBtn addTarget:self action:@selector(respondsToButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _fullscreenPlayBtn;
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
@end