//
//  ChatViewController.m

//  Created by tongho on 16/7/12.
//  Copyright © 2016年 im. All rights reserved.
//

#import "ChatViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MBProgressHUD+NJ.h"
//#import "MyViewController.h"

#import "NJMessageModel.h"
#import "NJMessageCell.h"
#import "NJMessageFrameModel.h"
#import "TextCell.h"
#import "ToolView.h"
#import "VoiceCellTableViewCell.h"
#import "heImageCell.h"
#import "MyImageCell.h"
#import "ImageViewController.h"
#import "chatInfoModel.h"   //会话消息模型
#import "sChatDb.h"//消息表操作模型
#import "ImdbModel.h"//我的好友数据表
#import "HfDbModel.h" //会话数据表
#import "TimeConvert.h" //时间显示转换器
#import "GetFolder.h"   //获取当前目录
#import "Person.h"
#import "historyHf.h"
#import "IMMessageEntity.h"
#import "MessageModule.h"
#import "VideoPlayViewController.h"
#import "SelectFileViewController.h"
#import "FileCell.h"
#import "MyGroupDB.h"
#import "GviewController.h"
#import "GroupMemeberDb.h"
#import "gChatDb.h"
#import "GroupMemeberModel.h"
//#import "ContactModule.h"
#import "IMConstant.h"
//#import <XMPPMessageArchiving_Message_CoreDataObject.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ImageViewController.h"




//枚举Cell类型
typedef enum : NSUInteger {
    SendText,
    SendImage,
    SendVoice

} MySendContentType;

/*
 //枚举用户类型
  typedef enum : NSUInteger {
      MySelf,
      MyFriend
  } UserType;
*/
@interface ChatViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *messages;  //消息数组
//工具栏
//- (NSString *)getDocumentsPath;
@property (nonatomic,strong) ToolView *toolView;


//音量图片
@property (strong, nonatomic) UIImageView *volumeImageView;
//存放所有cell中的内容
@property (strong, nonatomic) NSMutableArray *dataSource;
//工具栏的高约束，用于当输入文字过多时改变工具栏的约束
@property (strong, nonatomic) NSLayoutConstraint *tooViewConstraintHeight;
//storyBoard上的控件
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

//从相册获取图片
@property (strong, nonatomic) UIImagePickerController *imagePiceker;
@property (strong, nonatomic) GviewController *groupMessage;

//发送类型
@property (assign, nonatomic)MySendContentType sentType;

@property (strong, nonatomic) TimeConvert *timeconvert;
@property (assign, nonatomic) int maxId;
@property (assign, nonatomic) int nowId;
@property (strong, nonatomic) sChatDb *cahtDb;
@property (strong, nonatomic) gChatDb *gchatDb;
@property (strong, nonatomic) GetFolder *getFolder;
@property (strong, nonatomic) GroupMemeberDb *groupMemberDb;

@property (strong, nonatomic) ImageViewController *showImageview;
//显示在tableView上
//@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;

@property (assign,nonatomic)BOOL isFirst;  //初次进入时，显示到最后一行

@property (assign,nonatomic)int loadState;   //下载的状况

//刷新
@property (assign,nonatomic)BOOL isRefresh;
@property (strong,nonatomic)UIActivityIndicatorView *activity;   //小圆圈
@property (assign,nonatomic) BOOL showTime;
@property (copy,nonatomic) NSString * strUrl;
@property (strong ,nonatomic) UIImage *myIcon;
@property (strong, nonatomic) UIImage *heIcon;

//用户类型
@property (assign, nonatomic) UserType userType;

@property (strong, nonatomic)UIImage * messageImage;

- (void)loadMore;
-(void) scrollBottom;
-(UIImage *)getMyicon;
-(UIImage *)getHeiconWithid:(int)senderId;
- (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath;
//-(void) playSendVideo :(NSString *)filePath;
-(void) playSendVideo :(NSString *)filePath  wihFlag:(BOOL) isFinished;
-(UIImage *)getThumbnailImage:(NSString *)videoURL;
-(NSString*)transVideoStyle:(NSString *)videoPath;

@end



@implementation ChatViewController

/*
 
 
 //进入聊天框前，先计算，数据库中最后一条消息的自增长的id号，然后读取十八条数据，第一次的时候，自动滚到最后一条，之后的load more不再滚动
 至最后一条，     在聊天界面里时，在加载界面时，设置监听消息，   新消息到来时，读取数据库最后一条信息，加入数组，刷新
 
 自己发送的消息 直接加到数组的后面  ，再存入数据库，就不用再读了数据库（没有消息反馈）
 
*/





- (void)viewDidLoad
{
    [super viewDidLoad];
 //   [self getDocumentsPath];
    
    
    self.title = self.temTitle;  //设置标题为用户备注
    
    
    
    
    
    // 设置隐藏分割线
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置隐藏垂直的滚动条
    self.myTableView.showsVerticalScrollIndicator = NO;
    
    // 设置tableview的背景颜色
    self.myTableView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    
    // 设置cell不可以被选中
    self.myTableView.allowsSelection = NO;
    
    
    self.navigationItem.title = _temTitle;
  //获取我的头像
     _myIcon = [self getMyicon];

   _groupMemberDb = [[GroupMemeberDb alloc]init];
    
    //TableView的回调
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    //初始化相片
    self.imagePiceker = [[UIImagePickerController alloc] init];
    self.imagePiceker.allowsEditing = YES;
    self.imagePiceker.delegate = self;
    
    // Do any additional setup after loading the view.

    //添加基本的子视图
    [self addMySubView];
    
    //给子视图添加约束
    [self addConstaint];
    
    //设置工具栏的回调
    [self setToolViewBlock];
    
     self.messages = [[NSMutableArray alloc]init];    
    //获取通知中心
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //注册为被通知者
    [notificationCenter addObserver:self selector:@selector(keyChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //设置监听：
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh1)
                                                 name:IMNotificationReceiveMessage   //会话消息
                                               object:nil];
    
   // UIApplication *app = [UIApplication sharedApplication];
    
    [[NSNotificationCenter defaultCenter]
     
     addObserver:self
     
     selector:@selector(applicationWillResignActive:)
     
     name:UIApplicationWillResignActiveNotification
     
     object:nil];
    

    
    
    
    
    
    
    //获取聊天数据中，最大的ID数
    
  //添加判断，是群聊还是单聊
    if (YES == _isGroupStyle) {
        _gchatDb = [[gChatDb alloc]init];
        [_gchatDb createTableWithGroupId:_hhId];
        _maxId = [_gchatDb maxId];
    } else {//单聊
        _cahtDb = [[sChatDb alloc]init];
        [_cahtDb createTableWithContacterId:_hhId];//创表
        _maxId = [_cahtDb maxId];

    }
    
    
    _isRefresh = NO;  //初始化
    _isFirst = YES;
    _timeconvert = [[TimeConvert alloc]init];
    _getFolder = [[GetFolder alloc]init];
    
     _strUrl = [_getFolder getFolder];
    //初始化data,需要从数据库中取出聊天记录
    [self loadMore];  //初始化数据
    
   //在此处判断是群聊还是单聊。如果是单聊将不显示群组相信信息图标
    
    // 监听键盘send按钮的点击
    //  self.inputTextField.delegate = self;
}


- (void)loadMore         //WHERE pk > %d limit 10    WHERE pk < %d  order by pk desc limit 18  下拉加载
{
    
   
     _nowId = _maxId;
    if ( _nowId > 0) {     //数据表中有数据
        
        if(NO == _isFirst) {
        self.myTableView.tableHeaderView.hidden = NO;
        [self.activity startAnimating];
            self.isRefresh = YES; }
         [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];  //延时0.8s
        
    }
   
}

    
- (void)delayMethod {
    
    NSMutableArray *arry =[[NSMutableArray alloc]init];
    if (YES == _isGroupStyle) {
        arry = (NSMutableArray *)[_gchatDb queryPartWith:_nowId];
    } else {
        arry = (NSMutableArray *)[_cahtDb queryPartWith:_nowId];
    }
  
    [arry addObjectsFromArray:(NSArray *)_messages];       //将旧的附加到新的末尾
    _messages = arry;
    if(_maxId > -20){
        _maxId -= 18;  //将最大值减18
    }
    [self.myTableView reloadData];
    
    [self.activity stopAnimating];
    self.myTableView.tableHeaderView.hidden = YES;
    self.isRefresh = NO;
    if (YES == _isFirst) {
         [self scrollBottom];  //初始化时直接下拉到最后一行
        _isFirst = !_isFirst;
    }
}
    



-(UIImage *)getMyicon {

    // 1.获得Documents的全路径
    NSString *nowDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *nowPath = [nowDoc stringByAppendingPathComponent:@"nowUser.data"]; //扩展名可以自己定义
    
    // 3.从文件中读取MJStudent对象，将nsdata转成对象
    Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];
    
    
    
    
    // 1.获得Documents的全路径
    NSString *filename = [NSString stringWithFormat:@"%@.data",nowUser.userName];//用户名.data
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:filename];
    
    // 3.从文件中读取Person对象
    Person *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (nil == user.headerImage) {
        return  [UIImage imageNamed:@"tn.9.png"];
    }
    else
       return  user.headerImage;
}

-(UIImage *)getHeiconWithid:(int)senderId {   //qun聊时获取头像的方法
    
    NSArray *arry;
   BOOL creat = [_groupMemberDb createTableWithGroupId:_hhId];
    if (creat) {
        arry =  [_groupMemberDb search:senderId];
    }
    
     return [UIImage imageWithData:((GroupMemeberModel *)arry[0]).icon];
    
}


/*

-(void)initXmpp
{
    UIApplication * app = [UIApplication sharedApplication];
    id delegate = [app delegate];
    //获取xmpp的上下文，用于获取消息记录
    self.xmppManagedObjectContext = [delegate xmppManagedObjectContext];
    //获取xmppStream
    self.xmppStream = [delegate xmppStream];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    //通过实体获取request()
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass([XMPPMessageArchiving_Message_CoreDataObject class])];
    NSSortDescriptor * sortD = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    [request setSortDescriptors:@[sortD]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"bareJidStr=='%@'",self.jidStr]];
    [request setPredicate:predicate];
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.xmppManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    self.fetchedResultsController.delegate = self;
    
    NSError * error;
    ;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"%s  %@",__FUNCTION__,[error localizedDescription]);
    }

}

*/

-(void) addMySubView
{
   
    
    
    
    //imageView实例化
    self.volumeImageView = [[UIImageView alloc] init];
    self.volumeImageView.hidden = YES;
    self.volumeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.volumeImageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
    [self.view addSubview:self.volumeImageView];
    
    
    //工具栏
    _toolView = [[ToolView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_toolView];

    
    
    self.automaticallyAdjustsScrollViewInsets = false;  //第一个cell和顶部有留白，scrollerview遗留下来的，用来取消它
    //刷新控件
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activity.frame = CGRectMake(headerView.frame.size.width/2, 0, 20, 20);;
    [headerView addSubview:self.activity];
    self.myTableView.tableHeaderView = headerView;
    headerView.hidden = YES;
    
    
    
    
    
    //判断是否是群组消息
    
    if (YES == _isGroupStyle) {      //是群组消息
       
        //添加右边的按钮
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
        Button.frame = CGRectMake(0, 0, 30, 30);
        [Button setBackgroundImage:[UIImage imageNamed:@"zq.png"] forState:UIControlStateNormal];
        [Button addTarget:self action:@selector(groupMessage:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:Button];
        self.navigationItem.rightBarButtonItem = ButtonItem;
    } else {                    //不是群组消息
        //添加右边的按钮
        /*
        UIButton *Button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        Button1.frame = CGRectMake(0, 0, 30, 30);
        [Button1 setBackgroundImage:[UIImage imageNamed:@"avl.png"] forState:UIControlStateNormal];
        [Button1 addTarget:self action:@selector(friendMessage:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:Button1];
        self.navigationItem.rightBarButtonItem = ButtonItem;
         */
    }
    
    
    //如果不是群组，那么将显示另一个按钮
    
    
}





-(void)groupMessage:(id)sender{

//进入群组详细信息界面
    
    
    
//    if (self.groupMessage.view.tag == 1) {
//        [self.groupMessage.view removeFromSuperview];
//        self.groupMessage.view.tag = 0;
//        
//    }
//    else{
    
     self.groupMessage = [[GviewController alloc]init];
        self.groupMessage.groupId = _hhId;
        self.groupMessage.groupName = _temTitle;
//        [self.view addSubview:self.groupMessage.view];
//        self.groupMessage.view.tag = 1;
      //[self.window setRootViewController:_groupMessage];
       UINavigationController * navigation = [[UINavigationController alloc]initWithRootViewController:_groupMessage];
    [self presentViewController:navigation animated:YES completion:^{
        
        [self.groupMessage setrootBlock:^(int flag){
            if (flag == 1) {
                //NSLog(@"哦我我嗯我房间1");
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
            
        }];
        
    }];
    

}





-(void) addConstaint
{
    
    //给volumeImageView进行约束
    _volumeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *imageViewConstrainH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-60-[_volumeImageView]-60-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_volumeImageView)];
    [self.view addConstraints:imageViewConstrainH];
    
    NSArray *imageViewConstaintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[_volumeImageView(150)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_volumeImageView)];
    [self.view addConstraints:imageViewConstaintV];
    
    
    //toolView的约束
    _toolView.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *toolViewContraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_toolView)];
    [self.view addConstraints:toolViewContraintH];
    
    NSArray * tooViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolView(44)]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_toolView)];
    [self.view addConstraints:tooViewConstraintV];
    self.tooViewConstraintHeight = tooViewConstraintV[0];
}
/*
- (void)addMessage:(NSString *)content1 type:(NJMessageModelType)type
{
    // 1.修改模型(创建模型, 并且将模型保存到数组中)
    
    // 获取上一次的message
    NJMessageModel *previousMessage = ( NJMessageModel *)[[self.messages lastObject] message];
    
    NJMessageModel *message = [[NJMessageModel alloc] init];
    message.time = @"17:17";
    message.content = content1;
    message.type = type;
    message.hiddenTime = [message.time isEqualToString:previousMessage.time];
    
    //根据message模型创建frame模型
    NJMessageFrameModel *mf = [[NJMessageFrameModel alloc] init];
    mf.message = message;
    
    [self.messages addObject:mf];
}
*/
//实现工具栏的回调
-(void)setToolViewBlock
{
    __weak __block ChatViewController *copy_self = self;
    
    
    //通过block回调接收到toolView中的text
    [self.toolView setMyTextBlock:^(NSString *myText) {
      
        
        //[copy_self sendMessage:SendText Content:myText];
       
        [copy_self sendMessage:1 Content:myText];  //发送文本
           }];
    
    
    //回调输入框的contentSize,改变工具栏的高度
    [self.toolView setContentSizeBlock:^(CGSize contentSize) {
         [copy_self updateHeight:contentSize];
    }];
    
    
    //获取录音声量，用于声音音量的提示
    [self.toolView setAudioVolumeBlock:^(CGFloat volume) {
        
        copy_self.volumeImageView.hidden = NO;
        int index = (int)(volume*100)%6+1;
        [copy_self.volumeImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"record_animate_%02d.png",index]]];
    }];
    
    //获取录音文件名（用于录音播放方法）
    [self.toolView setAudioURLBlock:^(NSString *audioURL) {     //此处其实还是字符串    voice/文件名
        copy_self.volumeImageView.hidden = YES;
        
      //  [copy_self sendMessage:SendVoice Content:audioURL];
        [copy_self sendMessage:3 Content:audioURL];   //发送语音
        
        
    }];
    
    //录音取消（录音取消后，把音量图片进行隐藏）
    [self.toolView setCancelRecordBlock:^(int flag) {
        if (flag == 1) {
            copy_self.volumeImageView.hidden = YES;
        }
    }];
    
    
    
    
    
    //扩展功能回调
    [self.toolView setExtendFunctionBlock:^(int buttonTag) {
        switch (buttonTag) {
            case 1:
                //从相册获取
            {  copy_self.imagePiceker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                 copy_self.imagePiceker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                [copy_self presentViewController:copy_self.imagePiceker animated:YES completion:^{
                    
                }];}
                break;
            case 2:
                //拍照
            {    copy_self.imagePiceker.sourceType = UIImagePickerControllerSourceTypeCamera;
                copy_self.imagePiceker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                [copy_self presentViewController:copy_self.imagePiceker animated:YES completion:^{
                    
                }];}
                break;
                
            case 3://本地视频
            {
                copy_self.imagePiceker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                copy_self.imagePiceker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                [copy_self presentViewController:copy_self.imagePiceker animated:YES completion:^{
                    
                }];

            }
                break;
              
            case 4://摄像机
            {
                copy_self.imagePiceker.sourceType = UIImagePickerControllerSourceTypeCamera;
                copy_self.imagePiceker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                [copy_self presentViewController:copy_self.imagePiceker animated:YES completion:^{
                    
                }];
                
            }
                break;
    
            case 5://文件
            {
               //进入文件选择器
                SelectFileViewController *selc = [[SelectFileViewController alloc]init];
                
                //在此处执行文件block的回传
                
                
                [selc setMyFileBlock:^(NSString *fileName){
                
                       //发送send
                    NSString *fileName1 = [NSString stringWithFormat:@"File/%@",fileName];
                    
                    [copy_self sendMessage:5 Content:fileName1];
                
                
                }];
                
                [copy_self.navigationController pushViewController:selc animated:YES];
            
            
            
            
            }
                
            default:
                break;
        }
    }];
}


#pragma mark - UITableViewDataSource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
     __weak __block ChatViewController *copy_self = self;
    int contentType = ((chatInfoModel *)_messages[indexPath.row]).messageStyle;  //此处消息类型为int
    NSTimeInterval nowcell = [((chatInfoModel *)_messages[indexPath.row]).date timeIntervalSince1970];    //当前cell的时间
    
    
        /*    [newImage setfullPicBlock:^(int newContent){
     
     //((chatInfoModel *)_messages[indexPath.row]).isFinished = YES;
     // ((chatInfoModel *)_messages[indexPath.row]).content = newContent;
     
     }];*///
    
    _showImageview = [[ImageViewController alloc]init];
    
    _showImageview.NextViewControllerBlock = ^(NSString *tfText){
        
        ((chatInfoModel *)copy_self.messages[indexPath.row]).isFinished = YES;
        ((chatInfoModel *)copy_self.messages[indexPath.row]).content = tfText;
        
    };


    
  //将当前的cell的时间，与上一个cell的时间进行比较，如果时间差小于60s，那么就隐藏当前cell的时间标题
    //如果当前的cell为第一个cell，那么就一定要显示时间  ,每十八个cell也要显示时间
    if (0 == indexPath.row || 0 == (_messages.count - indexPath.row)%18) {
        _showTime = YES;
    }
    
    else {  //如果不是第一个cell，那么一定会存在上一个cell
    
    
     NSTimeInterval lastcell = [((chatInfoModel *)_messages[indexPath.row-1]).date timeIntervalSince1970];  //上一个cell
     double distanceTime = nowcell - lastcell;
      
        if (distanceTime < 60) {
            _showTime = NO;           //如果时间间隔小于60s。那么就隐藏起当前的时间
        }
         else  _showTime = YES;
    
    }
 
     if (((chatInfoModel *)_messages[indexPath.row]).sendId != -1) {   //表示发消息的不是我
         UIImage *image;
         //如果是单聊，直接使用头像 heIcon
         if (1 == ((chatInfoModel *)_messages[indexPath.row]).style ) {
             
              image = _heImage;   //直接使用头像

         }
         
         
         //如果是群聊，根据sendid与群组ID   在我的群组成员列表中查找群成员的头像
         if (2 == ((chatInfoModel *)_messages[indexPath.row]).style ) {
             _heIcon = [self getHeiconWithid:((chatInfoModel *)_messages[indexPath.row]).sendId];
             
             image = _heIcon;
             
         }
         
     switch (contentType) {
     case 1:   //文本消息
     {
     
     
     static NSString *identifier = @"myFrendTextCell";
     TextCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
     
     if (cell == nil) {
     cell = [[TextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
     }
     
     NSMutableAttributedString *contentText = [self showFace:((chatInfoModel *)_messages[indexPath.row]).content];
     
     NSString *time = [_timeconvert chatDistanceTimeWithBeforeTime:nowcell];
    
         cell.showTime = _showTime;
         cell.heIcon = image;
         
     [cell setCellValue:contentText time:time userType:MyFriend];
     //     [cell setCellValue:contentText];
     return cell;
     }
     break;
     
     case 2:  //图片消息
     {
         
         
         
     //使用block 回调 message 的image 与   isfinishde
         
     //此处添加判断，是缩略图片，还是原图
      BOOL isFinish = ((chatInfoModel *)_messages[indexPath.row]).isFinished;
         
         
     __weak __block ChatViewController *copy_self = self;
     static NSString *identifier = @"myFriendImageCell";
     MyImageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
     
     if (cell == nil) {
     cell = [[MyImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
     }
     
         NSString *time = [_timeconvert chatDistanceTimeWithBeforeTime:nowcell];

        
         cell.showTime = _showTime;
         cell.heIcon = image;

         
     // MyImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myImageCell" ];
     //    [cell setCellValue:self.messages[indexPath.row][@"body"][@"content"]];
     
       //获取文件地址
         
         
         NSString *testPath = [_strUrl stringByAppendingPathComponent:((chatInfoModel *)_messages[indexPath.row]).content];
         
    // 此处将图片的地址转化为图片
         
         UIImage * image  = [UIImage imageWithContentsOfFile:testPath];
     
    
     
     [ cell setCellValue:image  time:time userType:MyFriend] ;
         int messageId = ((chatInfoModel *)_messages[indexPath.row]).serverMessageId;
     //传出cell中的图片
     [cell setButtonImageBlock:^(UIImage *image) {
         [copy_self displaySendImage:image withFlag:isFinish wihMessageId: messageId];     //将重写该display方法，使得点击图片后请求完整图片
     }];
         
     
     return cell;
     }
     break;
     
     case 3: //语音消息
     {
     
     static NSString *identifier = @"myFriendVoiceCell";
     VoiceCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
     
     if (cell == nil) {
     cell = [[VoiceCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
     }
     
         NSString *time = [_timeconvert chatDistanceTimeWithBeforeTime:nowcell];

         
           cell.showTime = _showTime;
         cell.heIcon = image;

        NSString *testPath = [_strUrl stringByAppendingPathComponent:((chatInfoModel *)_messages[indexPath.row]).content];
     
     [cell setCellValue:testPath time:(NSString*)time userType:MyFriend]; //如果是语音就直接传地址
     return cell;
     }
     
     break;
         case 4:   //传视频   在聊天界面显示缩略图
         {
             //此处添加判断，是缩略图片，还是原视频文件
             BOOL isFinish = ((chatInfoModel *)_messages[indexPath.row]).isFinished;
             
             
             static NSString *identifier = @"myselfVideoCell";
             MyImageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
             
             if (cell == nil) {
                 cell = [[MyImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
             }
             
             NSString *testPath = [_strUrl stringByAppendingPathComponent:((chatInfoModel *)_messages[indexPath.row]).content];
             UIImage * shotImage;
             if (NO == isFinish) {   //缩略图
                 // 此处将图片的地址转化为图片
                 shotImage  = [UIImage imageWithContentsOfFile:testPath];

             } else {    //是原视频地址
                 // 此处将视频的地址转化为缩略图片
                 shotImage = [self  getScreenShotImageFromVideoPath:testPath];
             }
             
        
             NSString *time = [_timeconvert chatDistanceTimeWithBeforeTime:nowcell];
             
             
             cell.showTime = _showTime;
             cell.heIcon = image;
             
             
             [ cell setCellValue:shotImage time:time userType:MyFriend] ;
             
             
             __weak __block ChatViewController *copy_self = self;
             
             
             //点击btn,会将视频的名字传入
             
             //传出cell中的
             [cell setButtonImageBlock:^(UIImage *image) {
                 [copy_self playSendVideo:testPath wihFlag:isFinish]; //该display方法
             }];
             
             
             return cell;
             
         }
             
             break;
             
         case 5:   //传文件
         {
             //此处添加判断，是缩略图片，还是原文件
             int isFinish = ((chatInfoModel *)_messages[indexPath.row]).isFinished;

             static NSString *identifier = @"myselfFileCell";
             FileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
             
             if (cell == nil) {
                 cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
             }
             
             NSString *time = [_timeconvert chatDistanceTimeWithBeforeTime:nowcell];
             
             
             cell.showTime = _showTime;
             cell.heIcon = image;
              cell.messageId = ((chatInfoModel *)_messages[indexPath.row]).serverMessageId;
             cell.sessionType = 1;
             if (YES == _isGroupStyle) {
                  cell.sessionType = 2;
             }
             
             [cell setflagBlock:^(int loadState){
                   //将flag的值賦给数据库isfinished
                 if (NO == _isGroupStyle) {
                     
                     sChatDb * schat = [[sChatDb alloc]init];
                     [schat createTableWithContacterId:_hhId];
                     [schat updatewihtId:cell.messageId  newFinishFlag:loadState];
                     if (0 == loadState) {
                         //显示下载按钮
                         cell.finderButton.hidden = YES;
                         cell.reloadButton.hidden = YES;
                         cell.loadButton.hidden = NO;
                         cell.loadMessage.text = @"点击下载";
                     }
                     
                     if (1 == loadState) {
                         //只显示finder按钮
                         cell.finderButton.hidden = NO;
                         cell.reloadButton.hidden = YES;
                         cell.loadButton.hidden = YES;
                         cell.loadMessage.text = @"下载完成";
                     }
                     if (2 == loadState) {
                         //只显示finder按钮
                         cell.finderButton.hidden = NO;
                         cell.reloadButton.hidden = YES;
                         cell.loadButton.hidden = YES;
                         cell.loadMessage.text = @"正在下载";
                     }
                     if (3 == loadState) {
                         //只显示finder按钮
                         cell.finderButton.hidden = YES;
                         cell.reloadButton.hidden = NO;
                         cell.loadButton.hidden = YES;
                         cell.loadMessage.text = @"下载失败";
                     }
                 } else {
                    
                     gChatDb * gchat  = [[gChatDb alloc]init];
                     [gchat createTableWithGroupId:_hhId];
                     [gchat updatewihtId:cell.messageId  newFinishFlag:loadState];
                     if (0 == loadState) {
                         //显示下载按钮
                         cell.finderButton.hidden = YES;
                         cell.reloadButton.hidden = YES;
                         cell.loadButton.hidden = NO;
                         cell.loadMessage.text = @"点击下载";
                     }
                     
                     if (1 == loadState) {
                         //只显示finder按钮
                         cell.finderButton.hidden = NO;
                         cell.reloadButton.hidden = YES;
                         cell.loadButton.hidden = YES;
                         cell.loadMessage.text = @"下载完成";
                     }
                     if (2 == loadState) {
                         //只显示finder按钮
                         cell.finderButton.hidden = NO;
                         cell.reloadButton.hidden = YES;
                         cell.loadButton.hidden = YES;
                         cell.loadMessage.text = @"正在下载";
                     }
                     if (3 == loadState) {
                         //只显示finder按钮
                         cell.finderButton.hidden = YES;
                         cell.reloadButton.hidden = NO;
                         cell.loadButton.hidden = YES;
                         cell.loadMessage.text = @"下载失败";
                     }
                 }

                 
                 
                   //更新界面的数据源
                 ((chatInfoModel *)_messages[indexPath.row]).isFinished = loadState;
                 
                 
             }];
             
             if (0 == isFinish) {
                 //显示下载按钮
                 cell.finderButton.hidden = YES;
                 cell.reloadButton.hidden = YES;
                 cell.loadButton.hidden = NO;
                 cell.loadMessage.text = @"点击下载";
             }
             
             if (1 == isFinish) {
                 //只显示finder按钮
                 cell.finderButton.hidden = NO;
                 cell.reloadButton.hidden = YES;
                 cell.loadButton.hidden = YES;
                 cell.loadMessage.text = @"下载完成";
             }
             if (2 == isFinish) {
                 //只显示finder按钮
                 cell.finderButton.hidden = NO;
                 cell.reloadButton.hidden = YES;
                 cell.loadButton.hidden = YES;
                 cell.loadMessage.text = @"正在下载";
             }
             if (3 == isFinish) {
                 //只显示finder按钮
                 cell.finderButton.hidden = YES;
                 cell.reloadButton.hidden = NO;
                 cell.loadButton.hidden = YES;
                 cell.loadMessage.text = @"下载失败";
             }
            
             
             
             [cell setfinderBlock:^(void) {
                 
                 //此处跳转入文件界面
                 //进入文件选择器
                 SelectFileViewController *selc = [[SelectFileViewController alloc]init];

                 [copy_self.navigationController pushViewController:selc animated:YES];
                 
             }];
             
             NSString *testPath = [_strUrl stringByAppendingPathComponent:((chatInfoModel *)_messages[indexPath.row]).content];
              NSString *filename = [testPath lastPathComponent];
             
             [cell setCellValue:filename time:(NSString*)time  userType:MyFriend];
             
             return cell;
             
             
             
         }
             
             
     
     default:
     break;
     }
     
     }
     
     
     
 if (((chatInfoModel *)_messages[indexPath.row]).sendId == -1) {      //如果发消息的是当前用户
     
     switch (contentType) {
     case 1:    //文本消息
     {
     
     
     //使cell可以复用；
     
     static NSString *identifier = @"myselfTextCell";
         
     TextCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
     
     if (cell == nil) {
     cell = [[TextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
     }
     
     
     NSMutableAttributedString *contentText = [self showFace:((chatInfoModel *)_messages[indexPath.row]).content];
     
 //    while ([cell.contentView.subviews lastObject]!= nil) {
 //    [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
 //    }
     
         NSString *time = [_timeconvert chatDistanceTimeWithBeforeTime:nowcell];

         
         
           cell.showTime = _showTime;
          cell.myIcon = _myIcon;

     
    [cell setCellValue:contentText time:time userType:MySelf];
    
    return cell;
}
break;

case 2:  //传图片
{
    //此处添加判断，是缩略图片，还是原图
    BOOL isFinish = ((chatInfoModel *)_messages[indexPath.row]).isFinished;
    
    
    static NSString *identifier = @"myselfImageCell";
    MyImageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    
    if (cell == nil) {
        cell = [[MyImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
     NSString *testPath = [_strUrl stringByAppendingPathComponent:((chatInfoModel *)_messages[indexPath.row]).content];
    
     // 此处将图片的地址转化为图片
     UIImage * image  = [UIImage imageWithContentsOfFile: testPath];
    
    NSString *time = [_timeconvert chatDistanceTimeWithBeforeTime:nowcell];

    
      cell.showTime = _showTime;
     cell.myIcon = _myIcon;

    
    [ cell setCellValue:image time:time userType:MySelf] ;
    
    
    __weak __block ChatViewController *copy_self = self;
    
    //传出cell中的图片
    [cell setButtonImageBlock:^(UIImage *image) {
       
        [copy_self displaySendImage:image withFlag:isFinish wihMessageId:0]; //对于自己发的消息，不用修改
    }];
    
    
    return cell;
}
break;

case 3:   //传语音
{
    
    static NSString *identifier = @"myselfVoiceCell";
    VoiceCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    
    if (cell == nil) {
        cell = [[VoiceCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString *time = [_timeconvert chatDistanceTimeWithBeforeTime:nowcell];

    
      cell.showTime = _showTime;
      cell.myIcon = _myIcon;

     NSString *testPath = [_strUrl stringByAppendingPathComponent:((chatInfoModel *)_messages[indexPath.row]).content];
    
    [cell setCellValue:testPath time:(NSString*)time  userType:MySelf];
    
    return cell;
}

break;

 case 4:   //传视频   在聊天界面显示缩略图
 {
     
     static NSString *identifier = @"myselfVideoCell";
     MyImageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
     
     if (cell == nil) {
         cell = [[MyImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
     }
     
     NSString *testPath = [_strUrl stringByAppendingPathComponent:((chatInfoModel *)_messages[indexPath.row]).content];
     
     // 此处将视频的地址转化为缩略图片
    //UIImage * shotImage = [self  getScreenShotImageFromVideoPath:testPath];
     
     // 1、获取媒体资源地址
     //    NSString *path = [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"宣传资料.mp4"];
     

     UIImage  *shotImage = [self getThumbnailImage:testPath];
     
   //  MPMoviePlayerController *player = [[MPMoviePlayerControlleralloc]initWithContentURL:videoURL] ;
   //   UIImage  *shotImage = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
     
     NSString *time = [_timeconvert chatDistanceTimeWithBeforeTime:nowcell];
     
     
     cell.showTime = _showTime;
     cell.myIcon = _myIcon;
     
     
     [ cell setCellValue:shotImage time:time userType:MySelf] ;
     
     
     __weak __block ChatViewController *copy_self = self;
     
     
     //点击btn,会将视频的名字传入
     
     //传出cell中的
     [cell setButtonImageBlock:^(UIImage *image) {
         [copy_self playSendVideo:testPath wihFlag:YES]; //该display方法
     }];
     
     
     return cell;

 }
     
     break;
     
 case 5:   //传文件
  {
         
      static NSString *identifier = @"myselfFileCell";
      FileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
      
      if (cell == nil) {
          cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
      }
      
      NSString *time = [_timeconvert chatDistanceTimeWithBeforeTime:nowcell];
      
      
      cell.showTime = _showTime;
      cell.myIcon = _myIcon;
      
      //只显示finder按钮
      cell.finderButton.hidden = NO;
      cell.reloadButton.hidden = YES;
      cell.loadButton.hidden = YES;
       cell.loadMessage.text = @"点击打开";
      
      [cell setfinderBlock:^(void) {
      
      //此处跳转入文件界面
          //此处跳转入文件界面
          //进入文件选择器
          SelectFileViewController *selc = [[SelectFileViewController alloc]init];
          
          [copy_self.navigationController pushViewController:selc animated:YES];
      
      
      }];
      
      NSString *testPath = [_strUrl stringByAppendingPathComponent:((chatInfoModel *)_messages[indexPath.row]).content];
      NSString *filename = [testPath lastPathComponent];
      
      [cell setCellValue:filename time:(NSString*)time  userType:MySelf];
      
      return cell;
         
         
         
}
             
             
default:
break;
}
}


UITableViewCell *cell;
return cell;
}





//将相册的mov格式转换为mp4

-(NSString*)transVideoStyle:(NSString *)videoPath{
    
      NSURL *sourceUrl = [NSURL fileURLWithPath:videoPath];

    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
  //  NSLog(@"%@",compatiblePresets);
    NSString * resultPath;
    
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        
        NSString *testPath = [_getFolder getFolder];
        NSString * fileName = [NSString stringWithFormat:@"Video/%ld.mp4", (long)[[NSDate date] timeIntervalSince1970]];//以记录时间为文件名
       resultPath = [testPath stringByAppendingPathComponent:fileName];
        

     //   NSLog(@"resultPath = %@",resultPath);
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
             
             switch (exportSession.status) {
                     
                 case AVAssetExportSessionStatusUnknown:
                     
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                     
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     
                     break;
                     
                 case AVAssetExportSessionStatusFailed:
                     
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     
                     break;
                 case AVAssetExportSessionStatusCancelled:
                     
                     //                     NSLog(@"AVAssetExportSessionStatusFailed");
                     NSLog(@"视频格式转换出错Cancelled");
                     
                     break;
                     
             }
             
         }];
        
    }


    return resultPath;

}




//获取视频截图

-(UIImage *)getThumbnailImage:(NSString *)videoURL

{
   //  NSString *path=[[NSBundle mainBundle] pathForResource:@"Miniature" ofType:@"mp4"];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;//按正确方向对视频进行截图,关键点是将AVAssetImageGrnerator对象的appliesPreferredTrackTransform属性设置为YES。
    
    CMTime time = CMTimeMakeWithSeconds(1.0, 10);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}



//获取图片与视频后要做的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage *pickerImage = info[UIImagePickerControllerEditedImage];
        
        //保存进沙盒，得到nsurl，保存
        
        NSString *testPath = [_getFolder getFolder];
        
        NSString * fileName = [NSString stringWithFormat:@"Image/%ld.png", (long)[[NSDate date] timeIntervalSince1970]];//以记录时间为文件名
        NSString *imageURL = [testPath stringByAppendingPathComponent:fileName];
        
        [UIImagePNGRepresentation(pickerImage) writeToFile:imageURL atomically:YES];
        
        
        //发送图片
        [self sendMessage:2 Content:fileName];   //传文件名

    } else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]) {
        
             NSString *testPath = [_getFolder getFolder];

        
            NSString *videoPath = [info[UIImagePickerControllerMediaURL] absoluteString];
            NSString *temVideo = [videoPath lastPathComponent];
             NSString *tmpDir = NSTemporaryDirectory();
            NSString *temVideoURL2 = [tmpDir stringByAppendingPathComponent:temVideo];
         //将mov格式转化为mp4
            NSString *newPath = [self transVideoStyle:temVideoURL2];
        
        
        // 从路径中获得完整的文件名（带后缀）
           NSString * exestr = [newPath lastPathComponent];
            NSLog(@"%@",exestr);
            
            //保存进沙盒，得到nsurl，保存
            
        
            NSString * fileName = [NSString stringWithFormat:@"Video/%@",exestr];
            NSString *videoURL = [testPath stringByAppendingPathComponent:fileName];
        //将视频存入自定义文件夹
            NSData *videoData = [NSData dataWithContentsOfFile:temVideoURL2];
        
            [videoData writeToFile:videoURL atomically:YES];
        
        
            //发送视频
            [self sendMessage:4 Content:fileName];   //传视频
        
        
    }
   
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //在ImagePickerView中点击取消时回到原来的界面
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}


//显示表情,用属性字符串显示表情
-(NSMutableAttributedString *)showFace:(NSString *)str
{
    if (str != nil) {
        //加载plist文件中的数据
        NSBundle *bundle = [NSBundle mainBundle];
        //寻找资源的路径
        NSString *path = [bundle pathForResource:@"emoticons" ofType:@"plist"];
        //获取plist中的数据
        NSArray *face = [[NSArray alloc] initWithContentsOfFile:path];
        
        //创建一个可变的属性字符串
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
        
        UIFont *baseFont = [UIFont systemFontOfSize:17];
        [attributeString addAttribute:NSFontAttributeName value:baseFont
                                range:NSMakeRange(0, str.length)];
        
        //正则匹配要替换的文字的范围
        //正则表达式
        NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        
        if (!re) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        //通过正则表达式来匹配字符串
        NSArray *resultArray = [re matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        
        
        //用来存放字典，字典中存储的是图片和图片对应的位置
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
        
        //根据匹配范围来用图片进行相应的替换
        for(NSTextCheckingResult *match in resultArray) {
            //获取数组元素中得到range
            NSRange range = [match range];
            
            //获取原字符串中对应的值
            NSString *subStr = [str substringWithRange:range];
            
            for (int i = 0; i < face.count; i ++)
            {
                if ([face[i][@"chs"] isEqualToString:subStr])
                {
                    
                    //face[i][@"gif"]就是我们要加载的图片
                    //新建文字附件来存放我们的图片
                    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                    
                    //给附件添加图片
                    textAttachment.image = [UIImage imageNamed:face[i][@"png"]];
                    
                    //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                    
                    //把图片和图片对应的位置存入字典中
                    NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                    [imageDic setObject:imageStr forKey:@"image"];
                    [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                    
                    //把字典存入数组中
                    [imageArray addObject:imageDic];
                    
                }
            }
        }
        
        if (imageArray.count > 0) {
            //从后往前替换
            for (int i = (int)imageArray.count -1; i >= 0; i--)
            {
                NSRange range;
                [imageArray[i][@"range"] getValue:&range];
                //进行替换
                [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
                
            }

        }
        
        return  attributeString;
        
    }
    
    return nil;

}


 //更新toolView的高度约束
 -(void)updateHeight:(CGSize)contentSize
 {
 float height = contentSize.height + 18;
 if (height <= 80) {
 [self.view removeConstraint:self.tooViewConstraintHeight];
 
 NSString *string = [NSString stringWithFormat:@"V:[_toolView(%f)]", height];
 
 NSArray * tooViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:string options:0 metrics:0 views:NSDictionaryOfVariableBindings(_toolView)];
 self.tooViewConstraintHeight = tooViewConstraintV[0];
 [self.view addConstraint:self.tooViewConstraintHeight];
 }
 }
 


//



 
//发送消息
 //发送消息，把聊天工具栏中返回的内容显示在tableView中，代码如下：


 
 -(void)sendMessage:(int)sendType Content:(NSString *)content   //对自己发送的消息进行操作，显示在界面，存入数据库，发送至网络，
 {
 
     chatInfoModel *chatmodel = [[chatInfoModel alloc]init];
     chatmodel.date = [NSDate date];
     chatmodel.content = content;
     chatmodel.messageStyle = sendType;
     
     
     //此处加判断，是群消息还是单聊
     chatmodel.style = 1;    //单聊类型
     if (YES ==  _isGroupStyle) {
          chatmodel.style = 2;  //是群聊
     }
     
     chatmodel.sendId = -1;  //表示发送者是自己
     chatmodel.receiverId = _hhId;
     chatmodel.isFinished = 1;  //自己发的消息都是已完成的
     chatmodel.date = [NSDate date];
     int sessionType = 1;
      if (YES == _isGroupStyle)
           sessionType = 2;
     
     //此处加判断，是哪种消息类型
 //将自己发的消息传给服务器
     if(1 == sendType)
         
     [[MessageModule instance] sendTextToUser:_hhId sessionType:sessionType text:content success: ^(NSArray *object){
     
         [_messages addObject:chatmodel];  //将模型加入结果数组中
         
         //重载tableView
         [self.myTableView  reloadData];
         // 3.让tableveiw滚动到最后一行
         NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count -1 inSection:0];
    
         [self.myTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
         HfDbModel* hfDbModel12 = [[HfDbModel alloc]init];
         //将自己发的消息存入数据库
         if (YES == _isGroupStyle ) {    //如果是群聊类型
            
                 [_gchatDb saveHistoryFriend:-1 receiverId:_hhId content:content style:chatmodel.style date:chatmodel.date messageStyle:sendType isFinished:1 serverMessageId:-1];//自己的消息
             
             
             
             //将自己发的消息存入会话表
             
             BOOL create12 = [hfDbModel12 createTable];
             if (create12) {
                 
                 _heImage = [UIImage imageNamed:@"me.png"];
                 NSData* avatarData = UIImagePNGRepresentation(_heImage);
                
                
                 [hfDbModel12 saveHistoryFriend:_temTitle lastMessage:content icon:avatarData time:[NSDate date] userId:_hhId redCount:0 style:2];
             }
            

             
         } else {
            
                 [_cahtDb saveHistoryFriend:-1 receiverId:_hhId content:content style:chatmodel.style date:chatmodel.date messageStyle:sendType isFinished:1 serverMessageId:-1];
             
             
             //将自己发的消息存入会话表
             BOOL create12 = [hfDbModel12 createTable];
             if (create12) {
                 NSData* avatarData;
                 if (UIImagePNGRepresentation(_heImage)) {
                     avatarData = UIImagePNGRepresentation(_heImage);
                 }else {
                     avatarData = UIImageJPEGRepresentation(_heImage, 1.0);
                 }
                 
                 [hfDbModel12 saveHistoryFriend:_temTitle lastMessage:content icon:avatarData time:[NSDate date] userId:_hhId redCount:0 style:1];
             }
             

             

         }
         
      
     
     }failure:^(void){
     
         [MBProgressHUD hideHUD];

         [MBProgressHUD showError:@"发送失败！"];
      
     /*    [_messages addObject:chatmodel];  //将模型加入结果数组中
         
         //重载tableView
         [self.myTableView  reloadData];
         // 3.让tableveiw滚动到最后一行
         NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count -1 inSection:0];
         
         
         // AtIndexPath: 要滚动到哪一行
         // atScrollPosition:滚动到哪一行的什么位置
         // animated:是否需要滚动动画
         
         [self.myTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
         
         //将自己发的消息存入数据库
         BOOL creat2 = [_cahtDb createTableWithContacterId:_hhId];
         if (creat2) {
             [_cahtDb saveHistoryFriend:-1 receiverId:_hhId content:content style:chatmodel.style date:chatmodel.date messageStyle:sendType isFinished:1 serverMessageId:-1];
         }  
         
         
       */

     
     }];
     
     
     if(2 == sendType){
         
         NSString *testPath = [_strUrl stringByAppendingPathComponent:content];
         
         // 此处将图片的地址转化为图片
         
         UIImage * image  = [UIImage imageWithContentsOfFile:testPath];
         
         NSString * PicName = [NSString stringWithFormat:@"%ld.png", (long)[[NSDate date] timeIntervalSince1970]];
         [[MessageModule instance]sendPictureToUser:_hhId sessionType:sessionType pictureName:PicName picture:image success:^(NSArray *object){
             
             [_messages addObject:chatmodel];  //将模型加入结果数组中
             
             //重载tableView
             [self.myTableView  reloadData];
             // 3.让tableveiw滚动到最后一行
             NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count -1 inSection:0];
             
             [self.myTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
             
             //将自己发的消息存入数据库
             if (YES == _isGroupStyle) {    //如果是群聊类型
                 
                 [_gchatDb saveHistoryFriend:-1 receiverId:_hhId content:content style:chatmodel.style date:chatmodel.date messageStyle:sendType isFinished:1 serverMessageId:-1];//自己的消息
                 
                 
                 
                 //将自己发的消息存入会话表
                 HfDbModel* hfDbModel12 = [[HfDbModel alloc]init];
                 BOOL create12 = [hfDbModel12 createTable];
                 if (create12) {
                     _heImage = [UIImage imageNamed:@"me.png"];
                     NSData* avatarData = UIImagePNGRepresentation(_heImage);
                     
                     [hfDbModel12 saveHistoryFriend:_temTitle lastMessage:@"[图片]" icon:avatarData time:[NSDate date] userId:_hhId redCount:0 style:2];
                 }
                 
                 
                 
             } else {
                 
                 [_cahtDb saveHistoryFriend:-1 receiverId:_hhId content:content style:chatmodel.style date:chatmodel.date messageStyle:sendType isFinished:1 serverMessageId:-1];
                 
                 
                 //将自己发的消息存入会话表
                 HfDbModel* hfDbModel12 = [[HfDbModel alloc]init];
                 BOOL create12 = [hfDbModel12 createTable];
                 if (create12) {
                     NSData* avatarData;
                     if (UIImagePNGRepresentation(_heImage)) {
                         avatarData = UIImagePNGRepresentation(_heImage);
                     }else {
                         avatarData = UIImageJPEGRepresentation(_heImage, 1.0);
                     }
                     
                     [hfDbModel12 saveHistoryFriend:_temTitle lastMessage:@"[图片]" icon:avatarData time:[NSDate date] userId:_hhId redCount:0 style:1];
                 }
                 
                 
                 
                 
             }
             

             
             
             
         } failure:^(){
             
             [MBProgressHUD hideHUD];
             
             [MBProgressHUD showError:@"发送失败！"];
         }];

     }
     
     
     
     if (3 == sendType) {  //语音
       
           NSString *testPath = [_strUrl stringByAppendingPathComponent:content];
         
         
         [[MessageModule instance] sendSoundToUser:_hhId sessionType:sessionType soundPath:testPath success:^(NSArray *object){
             
             [_messages addObject:chatmodel];  //将模型加入结果数组中
             
             //重载tableView
             [self.myTableView  reloadData];
             // 3.让tableveiw滚动到最后一行
             NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count -1 inSection:0];
             
             [self.myTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
             
             //将自己发的消息存入数据库
             if (YES == _isGroupStyle) {    //如果是群聊类型
                 
                 [_gchatDb saveHistoryFriend:-1 receiverId:_hhId content:content style:chatmodel.style date:chatmodel.date messageStyle:sendType isFinished:1 serverMessageId:-1];//自己的消息
                 
                 
                 
                 //将自己发的消息存入会话表
                 HfDbModel* hfDbModel12 = [[HfDbModel alloc]init];
                 BOOL create12 = [hfDbModel12 createTable];
                 if (create12) {
                     _heImage = [UIImage imageNamed:@"me.png"];
                     NSData* avatarData = UIImagePNGRepresentation(_heImage);
                     
                     [hfDbModel12 saveHistoryFriend:_temTitle lastMessage:@"[语音]" icon:avatarData time:[NSDate date] userId:_hhId redCount:0 style:2];
                 }
                 
                 
                 
             } else {
                 
                 [_cahtDb saveHistoryFriend:-1 receiverId:_hhId content:content style:chatmodel.style date:chatmodel.date messageStyle:sendType isFinished:1 serverMessageId:-1];
                 
                 
                 //将自己发的消息存入会话表
                 HfDbModel* hfDbModel12 = [[HfDbModel alloc]init];
                 BOOL create12 = [hfDbModel12 createTable];
                 if (create12) {
                     NSData* avatarData;
                     if (UIImagePNGRepresentation(_heImage)) {
                         avatarData = UIImagePNGRepresentation(_heImage);
                     }else {
                         avatarData = UIImageJPEGRepresentation(_heImage, 1.0);
                     }
                     
                     [hfDbModel12 saveHistoryFriend:_temTitle lastMessage:@"[语音]" icon:avatarData time:[NSDate date] userId:_hhId redCount:0 style:1];
                 }
                 
                 
                 
                 
             }
             
             

             
             
             
         } failure:^(){
             
             [MBProgressHUD hideHUD];
             
             [MBProgressHUD showError:@"发送失败！"];
             
         }];
     }
     
  
     
     if (4 == sendType) {
          NSString *testPath = [_strUrl stringByAppendingPathComponent:content];
         [[MessageModule instance] sendVadioToUser:_hhId sessionType:sessionType vadioPath:testPath success:^(NSArray *object){
             
             [_messages addObject:chatmodel];  //将模型加入结果数组中
             
             //重载tableView
             [self.myTableView  reloadData];
             // 3.让tableveiw滚动到最后一行
             NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count -1 inSection:0];
             
             [self.myTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
             
             //将自己发的消息存入数据库
             if (YES == _isGroupStyle) {    //如果是群聊类型
                 
                 [_gchatDb saveHistoryFriend:-1 receiverId:_hhId content:content style:chatmodel.style date:chatmodel.date messageStyle:sendType isFinished:1 serverMessageId:-1];//自己的消息
                 
                 
                 
                 //将自己发的消息存入会话表
                 HfDbModel* hfDbModel12 = [[HfDbModel alloc]init];
                 BOOL create12 = [hfDbModel12 createTable];
                 if (create12) {
                     _heImage = [UIImage imageNamed:@"me.png"];
                     NSData* avatarData = UIImagePNGRepresentation(_heImage);
                     
                     [hfDbModel12 saveHistoryFriend:_temTitle lastMessage:@"[视频]" icon:avatarData time:[NSDate date] userId:_hhId redCount:0 style:2];
                 }
                 
                 
                 
             } else {
                 
                 [_cahtDb saveHistoryFriend:-1 receiverId:_hhId content:content style:chatmodel.style date:chatmodel.date messageStyle:sendType isFinished:1 serverMessageId:-1];
                 
                 
                 //将自己发的消息存入会话表
                 HfDbModel* hfDbModel12 = [[HfDbModel alloc]init];
                 BOOL create12 = [hfDbModel12 createTable];
                 if (create12) {
                     NSData* avatarData;
                     if (UIImagePNGRepresentation(_heImage)) {
                         avatarData = UIImagePNGRepresentation(_heImage);
                     }else {
                         avatarData = UIImageJPEGRepresentation(_heImage, 1.0);
                     }
                     
                     [hfDbModel12 saveHistoryFriend:_temTitle lastMessage:@"[视频]" icon:avatarData time:[NSDate date] userId:_hhId redCount:0 style:1];
                 }
                 
                 
                 
                 
             }

             
         } failure:^(){
             
             
             [MBProgressHUD hideHUD];
             
             [MBProgressHUD showError:@"发送失败！"];
         }];
         
         
         
     }
     if(5 == sendType){
     
     NSString *testPath = [_strUrl stringByAppendingPathComponent:content];
      NSString *exestr = [testPath lastPathComponent];
         [[MessageModule instance] sendFileToUser:_hhId sessionType:sessionType fileName:exestr filePath:testPath success:^(NSArray *object){
             
             [_messages addObject:chatmodel];  //将模型加入结果数组中
             
             //重载tableView
             [self.myTableView  reloadData];
             // 3.让tableveiw滚动到最后一行
             NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count -1 inSection:0];
             
             [self.myTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
             
             //将自己发的消息存入数据库
             if (YES == _isGroupStyle) {    //如果是群聊类型
                 
                 [_gchatDb saveHistoryFriend:-1 receiverId:_hhId content:content style:chatmodel.style date:chatmodel.date messageStyle:sendType isFinished:1 serverMessageId:-1];//自己的消息
                 
                 
                 
                 //将自己发的消息存入会话表
                 HfDbModel* hfDbModel12 = [[HfDbModel alloc]init];
                 BOOL create12 = [hfDbModel12 createTable];
                 if (create12) {
                     _heImage = [UIImage imageNamed:@"me.png"];
                     NSData* avatarData = UIImagePNGRepresentation(_heImage);
                     [hfDbModel12 saveHistoryFriend:_temTitle lastMessage:@"[文件]" icon:avatarData time:[NSDate date] userId:_hhId redCount:0 style:2];
                 }
                 
                 
                 
             } else {
                 
                 [_cahtDb saveHistoryFriend:-1 receiverId:_hhId content:content style:chatmodel.style date:chatmodel.date messageStyle:sendType isFinished:1 serverMessageId:-1];
                 
                 
                 //将自己发的消息存入会话表
                 HfDbModel* hfDbModel12 = [[HfDbModel alloc]init];
                 BOOL create12 = [hfDbModel12 createTable];
                 if (create12) {
                     NSData* avatarData;
                     if (UIImagePNGRepresentation(_heImage)) {
                         avatarData = UIImagePNGRepresentation(_heImage);
                     }else {
                         avatarData = UIImageJPEGRepresentation(_heImage, 1.0);
                     }
                     
                     [hfDbModel12 saveHistoryFriend:_temTitle lastMessage:@"[文件]" icon:avatarData time:[NSDate date] userId:_hhId redCount:0 style:1];
                 }
                 
                 
                 
                 
             }
             
             
             

             
         } failure:^(){
             
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:@"发送失败！"];

             
         }];
     
     
     
     
     
     
     
     
     
     }

 }






//收消息
/*

-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
 
    //重载tableView
    [self.myTableView  reloadData];
 

}

*/

//根据ToolView中回调接口，获取工具栏中textView的ContentSize,通过ContentSize来调整ToolView的高度约束


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSTimeInterval nowcell = [((chatInfoModel *)_messages[indexPath.row]).date timeIntervalSince1970];    //当前cell的时间
    
    if (0 == indexPath.row || 0 == (_messages.count - indexPath.row)%18) {
        _showTime = YES;
    }
    
    else {  //如果不是第一个cell，那么一定会存在上一个cell
        
        
        NSTimeInterval lastcell = [((chatInfoModel *)_messages[indexPath.row-1]).date timeIntervalSince1970];  //上一个cell
        double distanceTime = nowcell - lastcell;
        
        if (distanceTime < 60) {
            _showTime = NO;           //如果时间间隔小于60s。那么就隐藏起当前的时间
        }
        else  _showTime = YES;
        
    }
    
    
    
       //根据文字计算cell的高度
       if (1 == ((chatInfoModel *)_messages[indexPath.row]).messageStyle) {
           
           
           
           int exheight = 80;
           if (NO == _showTime) {
               exheight = 50;
           }
           
                 NSMutableAttributedString *contentText = [self showFace:((chatInfoModel *)_messages[indexPath.row]).content];
        
                 CGRect textBound = [contentText boundingRectWithSize:CGSizeMake(150, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
                float height = textBound.size.height + exheight;
                 return height;
            }
         if (3 == ((chatInfoModel *)_messages[indexPath.row]).messageStyle)   //语音
             {
                 
                 if (NO == _showTime) {
                     return  75;
                 }
                 
                     return 105;
                 
                 }
    
         if (2 == ((chatInfoModel *)_messages[indexPath.row]).messageStyle)
             {
                 if (NO == _showTime) {
                     return  110;
                 }
                 
                 
                     return 140;
                 }
    
    if (4 == ((chatInfoModel *)_messages[indexPath.row]).messageStyle)
    {
        if (NO == _showTime) {
            return  110;
        }
        
        
        return 140;
    }

    
    
    
    
    if (NO == _showTime) {
        return  105;
    }
    
    
        return 135;
   }
  


#pragma mark - UITableViewDataSource





//滚动隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - 隐藏状态了
/*
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
*/
//发送图片的放大
-(void) displaySendImage : (UIImage*)image  withFlag:(BOOL)isFinished wihMessageId:(int)messageId        //(NSURL *)imageURL
{
    
    
    
    
    //把照片传到放大的controller中
  /*  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    ImageViewController *imageController = [storyboard instantiateViewControllerWithIdentifier:@"imageController"];
    [imageController setValue:imageURL forKeyPath:@"imageURL"];*/
    
    _showImageview.image = image;
    _showImageview.isFinished = isFinished;
    _showImageview.isGruopChat = _isGroupStyle;
    _showImageview.chatId = _hhId;
    _showImageview.messageId = messageId;
   [self.navigationController pushViewController:_showImageview animated:YES];
    

}

//播放视频
-(void) playSendVideo :(NSString *)filePath  wihFlag:(BOOL) isFinished        //(NSURL *)imageURL
{
    
    VideoPlayViewController *showImageview = [[VideoPlayViewController alloc]init];
    showImageview.videoPath = filePath;
    showImageview.isFinished = isFinished;
    [self.navigationController pushViewController:showImageview animated:YES];
    
    
}




//屏幕旋转改变toolView的表情键盘的高度
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //纵屏
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        [self.toolView changeFunctionHeight:216];
        //self.moreView.frame = frame;
        
    }
    //横屏
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [self.toolView changeFunctionHeight:150];
       
        //self.moreView.frame = frame;
        
    }
}

#pragma mark - UITableViewDelegate





//键盘出来的时候调整toolView的位置
-(void) keyChange:(NSNotification *) notify
{
    [self scrollBottom];
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
      
        self.view.transform = CGAffineTransformMakeTranslation(0, translationY);
    
        
    } completion:^(BOOL finished) {
        // 动画执行完毕执行的代码
    }];
}


-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMNotificationReceiveMessage object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
   // self.hidesBottomBarWhenPushed=YES;
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
     [view setHidden:YES];
  //  [self.view endEditing:YES];
    
    [self.myTableView  reloadData];
   

    

//  
    
    
    

 //   view.frame=CGRectMake(0, 480, 0, 0);
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    NSArray *array=self.tabBarController.view.subviews;
    
    NSLog(@"%@",array);
    
    UIView *view=array[2];
    
    [view setHidden:NO];
    [self.view endEditing:YES];
   
    //当即将退出该聊天界面时，将该聊天对应的会话cell的气泡数清零
    
    HfDbModel *hfdb = [[HfDbModel alloc]init];
      [hfdb createTable];
    int style = 1;
    if (YES == _isGroupStyle) {
        style = 2;
    }
    [hfdb setRedzeroWithuserId:_hhId style:style];
    
    

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0  && _isRefresh==NO)
    {
        [self loadMore];
    }
}



//滚动到最后一行
-(void) scrollBottom
{
    if ([self.messages count]) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
        [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}


/**
 *  获取视频的缩略图方法
 *
 *  @param filePath 视频的本地路径
 *
 *  @return 视频截图
 */

- (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath{
    
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return shotImage;
    
}


-(void) refresh1 {
//刷新模型，刷新界面，滚动至最后一行
    NSArray * temarry = [NSArray array];
     //将最新的一条消息加入到模型数组最后一行
    if (YES == _isGroupStyle) {
        temarry = [_gchatDb querryLast];
    } else {
       temarry = [_cahtDb querryLast];
    }
    
    [_messages addObject:temarry[0]];
    //重载tableView
    [self.myTableView  reloadData];
    // 3.让tableveiw滚动到最后一行
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count -1 inSection:0];
    
    [self.myTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}

//当按下home键时通知执行此方法
- (void)applicationWillResignActive:(NSNotification *)notification

{
    [self.view endEditing:YES];
}



@end
