//
//  MessageModule.m
//  ImAddition
//
//  Created by yuhui wang on 16/8/11.
//  Copyright © 2016年 yuhui wang. All rights reserved.
//

#import "MessageModule.h"
#import "SendTextAPI.h"
#import "ReceiveTextAPI.h"
#import "SendPictureAPI.h"
#import "ReceivePictureAPI.h"
#import "IMConstant.h"
#import "GetFullPictureAPI.h"
#import "SendFileAPI.h"
#import "ReceiveFileAPI.h"
#import "GetFullFileAPI.h"
#import "SendSoundAPI.h"
#import "ReceiveSoundAPI.h"
#import "SendVadioAPI.h"
#import "ReceiveVadioAPI.h"
#import "GetOfflineMessageAPI.h"
#import "sChatDb.h"
#import "gChatDb.h"
#import "HfDbModel.h"
#import "ImdbModel.h"
#import "historyHf.h"
#import "GroupMemeberDb.h"
#import "GroupMemeberModel.h"
#import "GroupModule.h"
#import "MyGroupDB.h"
#import "IMGroupMemberEntity.h"
#import "MyGroupModel.h"

@implementation MessageModule
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self registerAPI];
    }
    return self;
}

+ (instancetype)instance
{
    static MessageModule *g_MessageManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_MessageManager = [[MessageModule alloc] init];
    });
    return g_MessageManager;
}

- (void)sendTextToUser:(int)userID
           sessionType:(SessionType)sessionType
                  text:(NSString*)text
               success:(void(^)(NSArray*))success
               failure:(void(^)())failure
{
    NSLog(@"发送文本!");
    NSNumber *type = [NSNumber numberWithInt:sessionType];
    NSNumber *ID = [NSNumber numberWithInt:userID];
    NSString *msgText = text;
    NSArray *parameter =@[type,ID,msgText];
    NSLog(@"将会话类型、用户ID、文本消息传入做参数！");
    SendTextAPI *api = [[SendTextAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断文本消息发送结果！");
        if (!error)
        {
            if(response != nil){
                NSLog(@"发送成功!");
                success(response);
            }else{
                NSLog(@"发送失败!");
                failure();
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure();
        }
    }];
}

- (void)sendPictureToUser:(int)userID
              sessionType:(SessionType)sessionType
              pictureName:(NSString*)pictureName
                  picture:(UIImage*)picture
                  success:(void(^)(NSArray*))success
                  failure:(void(^)())failure
{
    NSLog(@"发送图片!");
    NSNumber *type = [NSNumber numberWithInt:sessionType];
    NSNumber *ID = [NSNumber numberWithInt:userID];
    NSArray *parameter =@[type,ID,pictureName,picture];
    SendPictureAPI *api = [[SendPictureAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断图片发送结果！");
        if (!error)
        {
            if(response != nil){
                NSLog(@"发送成功!");
                success(response);
            }else{
                NSLog(@"发送失败!");
                failure();
            }
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure();
        }
    }];
}

- (void)getFullPictureWithMsgID:(long)msgID
                    sessionType:(int)sessionType
                        success:(void(^)(IMMessageEntity* msg))success
                        failure:(void(^)())failure
{
    NSLog(@"获取完整图片！");
    NSNumber* messageID = [NSNumber numberWithLong:msgID];
    NSNumber* type = [NSNumber numberWithInt:sessionType];
    NSArray *parameter = @[messageID,type];
    GetFullPictureAPI *api = [[GetFullPictureAPI alloc]init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断图片获取结果！");
        if (!error)
        {
            if(response != nil){
                NSLog(@"获取成功!");
                success(response);
            }else{
                NSLog(@"获取失败!");
                failure();
            }
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure();
        }
    }];
    
}

- (void)sendFileToUser:(int)userID
           sessionType:(SessionType)sessionType
              fileName:(NSString*)fileName
              filePath:(NSString*)filePath
               success:(void(^)(NSArray* object))success
               failure:(void(^)())failure
{
    NSLog(@"发送文件!");
    NSNumber *type = [NSNumber numberWithInt:sessionType];
    NSNumber *ID = [NSNumber numberWithInt:userID];
    NSArray *parameter =@[type,ID,fileName,filePath];
    SendFileAPI *api = [[SendFileAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断文件发送结果！");
        if (!error)
        {
            if(response != nil){
                NSLog(@"发送成功!");
                success(response);
            }else{
                NSLog(@"发送失败!");
                failure();
            }
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure();
        }
    }];
}

- (void)getFullFileWithMsgID:(long)msgID
                 sessionType:(int)sessionType
                     success:(void(^)(IMMessageEntity* msg))success
                     failure:(void(^)())failure
{
    NSLog(@"获取完整文件！");
    NSNumber *messageID = [NSNumber numberWithLong:msgID];
    NSNumber *ssType = [NSNumber numberWithInt:sessionType];
    NSArray *parameter = @[messageID,ssType];
    GetFullFileAPI *api = [[GetFullFileAPI alloc]init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断文件获取结果！");
        if (!error)
        {
            if(response != nil){
                NSLog(@"获取成功!");
                success(response);
            }else{
                NSLog(@"获取失败!");
                failure();
            }
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure();
        }
    }];
}


- (void)sendSoundToUser:(int)userID
            sessionType:(SessionType)sessionType
              soundPath:(NSString*)soundPath
                success:(void(^)(NSArray* object))success
                failure:(void(^)())failure
{
    NSLog(@"发送语音!");
    NSNumber *type = [NSNumber numberWithInt:sessionType];
    NSNumber *ID = [NSNumber numberWithInt:userID];
    NSArray *parameter =@[type,ID,soundPath];
    NSLog(@"将会话类型、用户ID、文本消息传入做参数！");
    SendSoundAPI *api = [[SendSoundAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断语音发送结果！");
        if (!error)
        {
            if(response != nil){
                NSLog(@"发送成功!");
                success(response);
            }else{
                NSLog(@"发送失败!");
                failure();
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure();
        }
    }];
}

- (void)sendVadioToUser:(int)userID
            sessionType:(SessionType)sessionType
              vadioPath:(NSString*)vadioPath
                success:(void(^)(NSArray* object))success
                failure:(void(^)())failure
{
    NSLog(@"发送语音!");
    NSNumber *type = [NSNumber numberWithInt:sessionType];
    NSNumber *ID = [NSNumber numberWithInt:userID];
    NSArray *parameter =@[type,ID,vadioPath];
    NSLog(@"将会话类型、用户ID、文本消息传入做参数！");
    SendVadioAPI *api = [[SendVadioAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断语音发送结果！");
        if (!error)
        {
            if(response != nil){
                NSLog(@"发送成功!");
                success(response);
            }else{
                NSLog(@"发送失败!");
                failure();
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure();
        }
    }];
}

- (void)getOfflineMessageSuccess:(void(^)())success
                         failure:(void(^)())failure
{
    NSLog(@"获取离线消息!");
    NSString *parameter =@"";
    GetOfflineMessageAPI *api = [[GetOfflineMessageAPI alloc] init];
    [api requestWithObject:parameter Completion:^(id response, NSError *error) {
        NSLog(@"判断请求离线消息发送结果！");
        if (!error)
        {
            if(response != nil){
                NSLog(@"发送成功!");
                success(response);
            }else{
                NSLog(@"发送失败!");
                failure();
            }
            
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
            failure();
        }
    }];
}

/**
 *  注册推送消息接口
 */
- (void)registerAPI
{
    /**
     *  接受文本消息接口
     */
    ReceiveTextAPI* receiveTextAPI = [[ReceiveTextAPI alloc] init];
    [receiveTextAPI registerAPIInAPIScheduleReceiveData:^(id object, NSError *error) {
        if (!error)
        {
            NSLog(@"处理接收文本！");
            IMMessageEntity* textMsg = (IMMessageEntity*)object;
            // 存入数据库
            NSLog(@"存入数据库！");
            if (textMsg.sessionType == SessionTypeSingle) {
                sChatDb* sChatDb1 = [[sChatDb alloc]init];
                BOOL create1 = [sChatDb1 createTableWithContacterId:textMsg.senderId];
                if (create1) {
                    [sChatDb1 saveHistoryFriend:(int)textMsg.senderId receiverId:(int)textMsg.toUserID content:(NSString *)textMsg.msgContent style:(int)textMsg.sessionType date:[NSDate dateWithTimeIntervalSince1970:(textMsg.msgTime/1000)] messageStyle:(int)1 isFinished:(int)1 serverMessageId:(int)textMsg.msgID];
                }
            } else {
                gChatDb* gChatDb1 = [[gChatDb alloc]init];
                BOOL create1 = [gChatDb1 createTableWithGroupId:textMsg.toUserID];
                if (create1) {
                    [gChatDb1 saveHistoryFriend:(int)textMsg.senderId receiverId:(int)textMsg.toUserID content:(NSString *)textMsg.msgContent style:(int)textMsg.sessionType date:[NSDate dateWithTimeIntervalSince1970:(textMsg.msgTime/1000)] messageStyle:(int)1 isFinished:(int)1 serverMessageId:(int)textMsg.msgID];
                }
            }
            NSLog(@"存入会话列表！");
            int redcount;
            HfDbModel* hfDbModel1 = [[HfDbModel alloc]init];
            BOOL create11 = [hfDbModel1 createTable];
            if (create11) {
                NSArray* array1 = [[[ImdbModel alloc]init]search:textMsg.senderId];
                int ID = (textMsg.sessionType == SessionTypeSingle) ? textMsg.senderId : textMsg.toUserID;
                NSArray* array2 = [[[HfDbModel alloc]init]search:ID style:textMsg.sessionType];
                
                if (0 == array2.count) {
                    redcount = 1;
                }else  redcount = ((historyHf*)array2[0]).redCount+1;
                
                __block NSData *avatar = ((historyHf*)array1[0]).icon;
                __block NSString *remark = ((historyHf*)array1[0]).nickName2;
                __block NSString *content = textMsg.msgContent;
                
                if (textMsg.sessionType == SessionTypeGroup){
                    
                    MyGroupDB * gldbModel = [[MyGroupDB alloc]init];
                    [gldbModel createTable];
                    NSArray *resarry =  [gldbModel search:ID];
                    if (0 == resarry.count) {
                        //获取群组信息
                        [[GroupModule alloc] getGroupInfoWithID:ID success:^(IMGroupEntity* group){
                            NSLog(@"群组ID:%ld,群组名:%@,成员数:%d",(long)((IMGroupEntity*)group).ID,((IMGroupEntity*)group).name,((IMGroupEntity*)group).memberNumber);
                            [gldbModel saveMygroup:((IMGroupEntity*)group).name groupId:(int)((IMGroupEntity*)group).ID];
                            remark = ((IMGroupEntity*)group).name;
                            
                        } failure:^(NSString *error){}];
                        
                        [[GroupModule alloc] getGroupMemberListWithID:ID success:^(NSArray *memberList) {
                            //先清空群成员列表数据库
                            GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
                            [gmdb createTableWithGroupId:ID];
                            [gmdb deleteTable];
                            //再存入群成员列表数据库
                            BOOL creat1 = [gmdb createTableWithGroupId:ID];
                            if (creat1) {  //昵称， id，，头像，权限；创建者权限为1；
                                for(int j=1;j<memberList.count;j++){
                                    UIImage * avatar = ((IMGroupMemberEntity *)memberList[j]).avatar;
                                    
                                    NSData* avatarData;
                                    if (UIImagePNGRepresentation(avatar)) {
                                        avatarData = UIImagePNGRepresentation(avatar);
                                    }else {
                                        avatarData = UIImageJPEGRepresentation(avatar, 1.0);
                                    }
                                    
                                    if (((IMGroupMemberEntity *)memberList[j]).ID == textMsg.senderId) {
                                        content = [NSString stringWithFormat:@"%@:%@",((IMGroupMemberEntity*)memberList[j]).remark,textMsg.msgContent];
                                    }
                                    
                                    [gmdb saveMygroupMember:((IMGroupMemberEntity*)memberList[j]).remark memberId:(int)((IMGroupMemberEntity *)memberList[j]).ID Icon:avatarData permit:((IMGroupMemberEntity*)memberList[j]).isManager];
                                }
                            }
            
                            avatar = UIImagePNGRepresentation([UIImage imageNamed:(@"网信院徽128×128.png")]);
                            
                            [hfDbModel1 saveHistoryFriend:remark lastMessage:content icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(textMsg.msgTime/1000)] userId:textMsg.toUserID redCount:redcount style:textMsg.sessionType];
                            
                        } failure:^(NSString *error) {}];
                    }else{
                        MyGroupDB * gldbModel = [[MyGroupDB alloc]init];
                        [gldbModel createTable];
                        NSArray *resarry =  [gldbModel search:ID];
                        remark = ((MyGroupModel*)resarry[0]).myGroupName;
                        
                        GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
                        [gmdb createTableWithGroupId:ID];
                        NSArray *memarry = [gmdb search:textMsg.senderId];
                        content = [NSString stringWithFormat:@"%@:%@",((GroupMemeberModel*)memarry[0]).memberName
                                   ,textMsg.msgContent];
                        
                        [hfDbModel1 saveHistoryFriend:remark lastMessage:content icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(textMsg.msgTime/1000)] userId:textMsg.toUserID redCount:redcount style:textMsg.sessionType];
                    }
                    
                   
                }else{
                    [hfDbModel1 saveHistoryFriend:remark lastMessage:textMsg.msgContent icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(textMsg.msgTime/1000)] userId:textMsg.senderId redCount:redcount style:textMsg.sessionType];
                }
                
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:nil];
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
        }
    }];
    
    /**
     *  接收图片消息接口
     */
    ReceivePictureAPI* receivePictureAPI = [[ReceivePictureAPI alloc] init];
    [receivePictureAPI registerAPIInAPIScheduleReceiveData:^(id object, NSError *error) {
        if (!error)
        {
            NSLog(@"处理接收图片！");
            IMMessageEntity* picMsg = (IMMessageEntity*)object;
            // 存入数据库
            NSLog(@"存入数据库！");
            if (picMsg.sessionType == SessionTypeSingle) {
                sChatDb* sChatDb1 = [[sChatDb alloc]init];
                BOOL create1 = [sChatDb1 createTableWithContacterId:picMsg.senderId];
                if (create1) {
                    [sChatDb1 saveHistoryFriend:(int)picMsg.senderId receiverId:(int)picMsg.toUserID content:(NSString *)picMsg.msgContent style:(int)picMsg.sessionType date:[NSDate dateWithTimeIntervalSince1970:(picMsg.msgTime/1000)] messageStyle:(int)2 isFinished:(int)0 serverMessageId:(int)picMsg.msgID];
                }
            } else {
                
                gChatDb* gChatDb1 = [[gChatDb alloc]init];
                BOOL create1 = [gChatDb1 createTableWithGroupId:picMsg.toUserID];
                if (create1) {
                    [gChatDb1 saveHistoryFriend:(int)picMsg.senderId receiverId:(int)picMsg.toUserID content:(NSString *)picMsg.msgContent style:(int)picMsg.sessionType date:[NSDate dateWithTimeIntervalSince1970:(picMsg.msgTime/1000)] messageStyle:(int)2 isFinished:(int)0 serverMessageId:(int)picMsg.msgID];
                }
            }
            NSLog(@"存入会话列表！");
            int redcount;
            HfDbModel* hfDbModel12 = [[HfDbModel alloc]init];
            BOOL create12 = [hfDbModel12 createTable];
            if (create12) {
                NSArray* array3 = [[[ImdbModel alloc]init]search:picMsg.senderId];
                int ID = (picMsg.sessionType == SessionTypeSingle) ? picMsg.senderId : picMsg.toUserID;
                NSArray* array4 = [[[HfDbModel alloc]init]search:ID style:picMsg.sessionType];
                
                if (0 == array4.count) {
                    redcount = 1;
                }else  redcount = ((historyHf*)array4[0]).redCount+1;
                
                NSString *appearInfo = @"[图片]";
                __block NSData *avatar = ((historyHf*)array3[0]).icon;
                __block NSString *remark = ((historyHf*)array3[0]).nickName2;
                __block NSString *content = picMsg.msgContent;
                
                if (picMsg.sessionType == SessionTypeGroup) {
                    
                    MyGroupDB * gldbModel = [[MyGroupDB alloc]init];
                    [gldbModel createTable];
                    NSArray *resarry =  [gldbModel search:ID];
                    if (0 == resarry.count) {
                        //获取群组信息
                        [[GroupModule alloc] getGroupInfoWithID:ID success:^(IMGroupEntity* group){
                            NSLog(@"群组ID:%ld,群组名:%@,成员数:%d",(long)((IMGroupEntity*)group).ID,((IMGroupEntity*)group).name,((IMGroupEntity*)group).memberNumber);
                            [gldbModel saveMygroup:((IMGroupEntity*)group).name groupId:(int)((IMGroupEntity*)group).ID];
                            remark = ((IMGroupEntity*)group).name;
                            
                        } failure:^(NSString *error){}];
                        
                        [[GroupModule alloc] getGroupMemberListWithID:ID success:^(NSArray *memberList) {
                            //先清空群成员列表数据库
                            GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
                            [gmdb createTableWithGroupId:ID];
                            [gmdb deleteTable];
                            //再存入群成员列表数据库
                            BOOL creat1 = [gmdb createTableWithGroupId:ID];
                            if (creat1) {  //昵称， id，，头像，权限；创建者权限为1；
                                for(int j=1;j<memberList.count;j++){
                                    UIImage * avatar = ((IMGroupMemberEntity *)memberList[j]).avatar;
                                    
                                    NSData* avatarData;
                                    if (UIImagePNGRepresentation(avatar)) {
                                        avatarData = UIImagePNGRepresentation(avatar);
                                    }else {
                                        avatarData = UIImageJPEGRepresentation(avatar, 1.0);
                                    }
                                    
                                    if (((IMGroupMemberEntity *)memberList[j]).ID == picMsg.senderId) {
                                        content = [NSString stringWithFormat:@"%@:%@",((IMGroupMemberEntity*)memberList[j]).remark,appearInfo];
                                    }
                                    
                                    [gmdb saveMygroupMember:((IMGroupMemberEntity*)memberList[j]).remark memberId:(int)((IMGroupMemberEntity *)memberList[j]).ID Icon:avatarData permit:((IMGroupMemberEntity*)memberList[j]).isManager];
                                }
                            }
                            
                            avatar = UIImagePNGRepresentation([UIImage imageNamed:(@"网信院徽128×128.png")]);
                            
                            [hfDbModel12 saveHistoryFriend:remark lastMessage:content icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(picMsg.msgTime/1000)] userId:picMsg.toUserID redCount:redcount style:picMsg.sessionType];
                            
                        } failure:^(NSString *error) {}];
                    }else{
                        MyGroupDB * gldbModel = [[MyGroupDB alloc]init];
                        [gldbModel createTable];
                        NSArray *resarry =  [gldbModel search:ID];
                        remark = ((MyGroupModel*)resarry[0]).myGroupName;
                        
                        GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
                        [gmdb createTableWithGroupId:ID];
                        NSArray *memarry = [gmdb search:picMsg.senderId];
                        content = [NSString stringWithFormat:@"%@:%@",((GroupMemeberModel*)memarry[0]).memberName
                                   ,appearInfo];
                        
                        [hfDbModel12 saveHistoryFriend:remark lastMessage:content icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(picMsg.msgTime/1000)] userId:picMsg.toUserID redCount:redcount style:picMsg.sessionType];
                    }
                }else{
                    [hfDbModel12 saveHistoryFriend:remark lastMessage:appearInfo icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(picMsg.msgTime/1000)] userId:picMsg.senderId redCount:redcount style:picMsg.sessionType];
                }
                
                
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:nil];
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
        }
    }];
    
    /**
     *  接收文件消息接口
     */
    ReceiveFileAPI* receiveFileAPI = [[ReceiveFileAPI alloc] init];
    [receiveFileAPI registerAPIInAPIScheduleReceiveData:^(id object, NSError *error) {
        if (!error)
        {
            NSLog(@"处理接收文件！");
            IMMessageEntity* fileMsg = (IMMessageEntity*)object;
            // 存入数据库
            NSLog(@"存入数据库！");
            if (fileMsg.sessionType == SessionTypeSingle) {
                
                sChatDb* sChatDb1 = [[sChatDb alloc]init];
                BOOL create1 = [sChatDb1 createTableWithContacterId:fileMsg.senderId];
                if (create1) {
                    [sChatDb1 saveHistoryFriend:(int)fileMsg.senderId receiverId:(int)fileMsg.toUserID content:(NSString *)fileMsg.msgContent style:(int)fileMsg.sessionType date:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] messageStyle:(int)5 isFinished:(int)0 serverMessageId:(int)fileMsg.msgID];
                }
            } else {
                gChatDb* gChatDb1 = [[gChatDb alloc]init];
                BOOL create1 = [gChatDb1 createTableWithGroupId:fileMsg.toUserID];
                if (create1) {
                    [gChatDb1 saveHistoryFriend:(int)fileMsg.senderId receiverId:(int)fileMsg.toUserID content:(NSString *)fileMsg.msgContent style:(int)fileMsg.sessionType date:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] messageStyle:(int)5 isFinished:(int)0 serverMessageId:(int)fileMsg.msgID];
                }
            }
            NSLog(@"存入会话列表！");
            int redcount;
            HfDbModel* hfDbModel13 = [[HfDbModel alloc]init];
            BOOL create13 = [hfDbModel13 createTable];
            if (create13) {
                NSArray* array5 = [[[ImdbModel alloc]init]search:fileMsg.senderId];
                int ID = (fileMsg.sessionType == SessionTypeSingle) ? fileMsg.senderId : fileMsg.toUserID;
                NSArray* array6 = [[[HfDbModel alloc]init]search:ID style:fileMsg.sessionType];
                if (0 == array6.count) {
                    redcount = 1;
                }else  redcount = ((historyHf*)array6[0]).redCount+1;
                
                NSString *appearInfo = @"[文件]";
                __block NSData *avatar = ((historyHf*)array5[0]).icon;
                __block NSString *remark = ((historyHf*)array5[0]).nickName2;
                __block NSString *content = fileMsg.msgContent;
                
                if (fileMsg.sessionType == SessionTypeGroup) {
                    
                    MyGroupDB * gldbModel = [[MyGroupDB alloc]init];
                    [gldbModel createTable];
                    NSArray *resarry =  [gldbModel search:ID];
                    if (0 == resarry.count) {
                        //获取群组信息
                        [[GroupModule alloc] getGroupInfoWithID:ID success:^(IMGroupEntity* group){
                            NSLog(@"群组ID:%ld,群组名:%@,成员数:%d",(long)((IMGroupEntity*)group).ID,((IMGroupEntity*)group).name,((IMGroupEntity*)group).memberNumber);
                            [gldbModel saveMygroup:((IMGroupEntity*)group).name groupId:(int)((IMGroupEntity*)group).ID];
                            remark = ((IMGroupEntity*)group).name;
                            
                        } failure:^(NSString *error){}];
                        
                        [[GroupModule alloc] getGroupMemberListWithID:ID success:^(NSArray *memberList) {
                            //先清空群成员列表数据库
                            GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
                            [gmdb createTableWithGroupId:ID];
                            [gmdb deleteTable];
                            //再存入群成员列表数据库
                            BOOL creat1 = [gmdb createTableWithGroupId:ID];
                            if (creat1) {  //昵称， id，，头像，权限；创建者权限为1；
                                for(int j=1;j<memberList.count;j++){
                                    UIImage * avatar = ((IMGroupMemberEntity *)memberList[j]).avatar;
                                    
                                    NSData* avatarData;
                                    if (UIImagePNGRepresentation(avatar)) {
                                        avatarData = UIImagePNGRepresentation(avatar);
                                    }else {
                                        avatarData = UIImageJPEGRepresentation(avatar, 1.0);
                                    }
                                    
                                    if (((IMGroupMemberEntity *)memberList[j]).ID == fileMsg.senderId) {
                                        content = [NSString stringWithFormat:@"%@:%@",((IMGroupMemberEntity*)memberList[j]).remark,appearInfo];
                                    }
                                    
                                    [gmdb saveMygroupMember:((IMGroupMemberEntity*)memberList[j]).remark memberId:(int)((IMGroupMemberEntity *)memberList[j]).ID Icon:avatarData permit:((IMGroupMemberEntity*)memberList[j]).isManager];
                                }
                            }
                            
                            avatar = UIImagePNGRepresentation([UIImage imageNamed:(@"网信院徽128×128.png")]);
                            
                            [hfDbModel13 saveHistoryFriend:remark lastMessage:content icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] userId:fileMsg.toUserID redCount:redcount style:fileMsg.sessionType];
                            
                        } failure:^(NSString *error) {}];
                    }else{
                        MyGroupDB * gldbModel = [[MyGroupDB alloc]init];
                        [gldbModel createTable];
                        NSArray *resarry =  [gldbModel search:ID];
                        remark = ((MyGroupModel*)resarry[0]).myGroupName;
                        
                        GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
                        [gmdb createTableWithGroupId:ID];
                        NSArray *memarry = [gmdb search:fileMsg.senderId];
                        content = [NSString stringWithFormat:@"%@:%@",((GroupMemeberModel*)memarry[0]).memberName
                                   ,appearInfo];
                        
                        [hfDbModel13 saveHistoryFriend:remark lastMessage:content icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] userId:fileMsg.toUserID redCount:redcount style:fileMsg.sessionType];
                    }
                    
                }else{
                    [hfDbModel13 saveHistoryFriend:remark lastMessage:appearInfo icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] userId:fileMsg.senderId redCount:redcount style:fileMsg.sessionType];
                }
                
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:nil];
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
        }
    }];
    
    /**
     *  接收语音消息接口
     */
    ReceiveSoundAPI* receiveSoundAPI = [[ReceiveSoundAPI alloc] init];
    [receiveSoundAPI registerAPIInAPIScheduleReceiveData:^(id object, NSError *error) {
        if (!error)
        {
            NSLog(@"处理接收语音！");
            IMMessageEntity* fileMsg = (IMMessageEntity*)object;
            // 存入数据库
            NSLog(@"存入数据库！");
            if (fileMsg.sessionType == SessionTypeSingle) {
                
                sChatDb* sChatDb1 = [[sChatDb alloc]init];
                NSLog(@"%@",(NSString *)fileMsg.msgContent);
                BOOL create1 = [sChatDb1 createTableWithContacterId:fileMsg.senderId];
                if (create1) {
                    [sChatDb1 saveHistoryFriend:(int)fileMsg.senderId receiverId:(int)fileMsg.toUserID content:(NSString *)fileMsg.msgContent style:(int)fileMsg.sessionType date:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] messageStyle:(int)3 isFinished:(int)1 serverMessageId:(int)fileMsg.msgID];
                }
            } else {
                gChatDb* gChatDb1 = [[gChatDb alloc]init];
                BOOL create1 = [gChatDb1 createTableWithGroupId:fileMsg.toUserID];
                if (create1) {
                    [gChatDb1 saveHistoryFriend:(int)fileMsg.senderId receiverId:(int)fileMsg.toUserID content:(NSString *)fileMsg.msgContent style:(int)fileMsg.sessionType date:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] messageStyle:(int)3 isFinished:(int)1 serverMessageId:(int)fileMsg.msgID];
                }
            }
            NSLog(@"存入会话列表！");
            int redcount;
            HfDbModel* hfDbModel13 = [[HfDbModel alloc]init];
            BOOL create13 = [hfDbModel13 createTable];
            if (create13) {
                NSArray* array5 = [[[ImdbModel alloc]init]search:fileMsg.senderId];
                int ID = (fileMsg.sessionType == SessionTypeSingle) ? fileMsg.senderId : fileMsg.toUserID;
                NSArray* array6 = [[[HfDbModel alloc]init]search:ID style:fileMsg.sessionType];
                if (0 == array6.count) {
                    redcount = 1;
                }else  redcount = ((historyHf*)array6[0]).redCount+1;
                
                NSString *appearInfo = @"[语音]";
                __block NSData *avatar = ((historyHf*)array5[0]).icon;
                __block NSString *remark = ((historyHf*)array5[0]).nickName2;
                __block NSString *content = fileMsg.msgContent;
                
                if (fileMsg.sessionType == SessionTypeGroup) {
                    
                    MyGroupDB * gldbModel = [[MyGroupDB alloc]init];
                    [gldbModel createTable];
                    NSArray *resarry =  [gldbModel search:ID];
                    if (0 == resarry.count) {
                        //获取群组信息
                        [[GroupModule alloc] getGroupInfoWithID:ID success:^(IMGroupEntity* group){
                            NSLog(@"群组ID:%ld,群组名:%@,成员数:%d",(long)((IMGroupEntity*)group).ID,((IMGroupEntity*)group).name,((IMGroupEntity*)group).memberNumber);
                            [gldbModel saveMygroup:((IMGroupEntity*)group).name groupId:(int)((IMGroupEntity*)group).ID];
                            remark = ((IMGroupEntity*)group).name;
                            
                        } failure:^(NSString *error){}];
                        
                        [[GroupModule alloc] getGroupMemberListWithID:ID success:^(NSArray *memberList) {
                            //先清空群成员列表数据库
                            GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
                            [gmdb createTableWithGroupId:ID];
                            [gmdb deleteTable];
                            //再存入群成员列表数据库
                            BOOL creat1 = [gmdb createTableWithGroupId:ID];
                            if (creat1) {  //昵称， id，，头像，权限；创建者权限为1；
                                for(int j=1;j<memberList.count;j++){
                                    UIImage * avatar = ((IMGroupMemberEntity *)memberList[j]).avatar;
                                    
                                    NSData* avatarData;
                                    if (UIImagePNGRepresentation(avatar)) {
                                        avatarData = UIImagePNGRepresentation(avatar);
                                    }else {
                                        avatarData = UIImageJPEGRepresentation(avatar, 1.0);
                                    }
                                    
                                    if (((IMGroupMemberEntity *)memberList[j]).ID == fileMsg.senderId) {
                                        content = [NSString stringWithFormat:@"%@:%@",((IMGroupMemberEntity*)memberList[j]).remark,appearInfo];
                                    }
                                    
                                    [gmdb saveMygroupMember:((IMGroupMemberEntity*)memberList[j]).remark memberId:(int)((IMGroupMemberEntity *)memberList[j]).ID Icon:avatarData permit:((IMGroupMemberEntity*)memberList[j]).isManager];
                                }
                            }
                            
                            avatar = UIImagePNGRepresentation([UIImage imageNamed:(@"网信院徽128×128.png")]);
                            
                            [hfDbModel13 saveHistoryFriend:remark lastMessage:content icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] userId:fileMsg.toUserID redCount:redcount style:fileMsg.sessionType];
                            
                        } failure:^(NSString *error) {}];
                    }else{
                        MyGroupDB * gldbModel = [[MyGroupDB alloc]init];
                        [gldbModel createTable];
                        NSArray *resarry =  [gldbModel search:ID];
                        remark = ((MyGroupModel*)resarry[0]).myGroupName;
                        
                        GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
                        [gmdb createTableWithGroupId:ID];
                        NSArray *memarry = [gmdb search:fileMsg.senderId];
                        content = [NSString stringWithFormat:@"%@:%@",((GroupMemeberModel*)memarry[0]).memberName
                                   ,appearInfo];
                        
                        [hfDbModel13 saveHistoryFriend:remark lastMessage:content icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] userId:fileMsg.toUserID redCount:redcount style:fileMsg.sessionType];
                    }
                    
                }else{
                    [hfDbModel13 saveHistoryFriend:remark lastMessage:appearInfo icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] userId:fileMsg.senderId redCount:redcount style:fileMsg.sessionType];
                }
                
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:nil];
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
        }
    }];
    
    /**
     *  接收短视频消息接口
     */
    ReceiveVadioAPI* receiveVadioAPI = [[ReceiveVadioAPI alloc] init];
    [receiveVadioAPI registerAPIInAPIScheduleReceiveData:^(id object, NSError *error) {
        if (!error)
        {
            NSLog(@"处理接收短视频！");
            IMMessageEntity* fileMsg = (IMMessageEntity*)object;
            // 存入数据库
            NSLog(@"存入数据库！");
            if (fileMsg.sessionType == SessionTypeSingle) {
                
                sChatDb* sChatDb1 = [[sChatDb alloc]init];
                BOOL create1 = [sChatDb1 createTableWithContacterId:fileMsg.senderId];
                if (create1) {
                    [sChatDb1 saveHistoryFriend:(int)fileMsg.senderId receiverId:(int)fileMsg.toUserID content:(NSString *)fileMsg.msgContent style:(int)fileMsg.sessionType date:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] messageStyle:(int)4 isFinished:(int)1 serverMessageId:(int)fileMsg.msgID];
                }
            } else {
                gChatDb* gChatDb1 = [[gChatDb alloc]init];
                BOOL create1 = [gChatDb1 createTableWithGroupId:fileMsg.toUserID];
                if (create1) {
                    [gChatDb1 saveHistoryFriend:(int)fileMsg.senderId receiverId:(int)fileMsg.toUserID content:(NSString *)fileMsg.msgContent style:(int)fileMsg.sessionType date:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] messageStyle:(int)4 isFinished:(int)1 serverMessageId:(int)fileMsg.msgID];
                }
            }
            NSLog(@"存入会话列表！");
            int redcount;
            HfDbModel* hfDbModel13 = [[HfDbModel alloc]init];
            BOOL create13 = [hfDbModel13 createTable];
            if (create13) {
                NSArray* array5 = [[[ImdbModel alloc]init]search:fileMsg.senderId];
                int ID = (fileMsg.sessionType == SessionTypeSingle) ? fileMsg.senderId : fileMsg.toUserID;
                NSArray* array6 = [[[HfDbModel alloc]init]search:ID style:fileMsg.sessionType];
                if (0 == array6.count) {
                    redcount = 1;
                }else  redcount = ((historyHf*)array6[0]).redCount+1;
                
                NSString *appearInfo = @"[短视频]";
                __block  NSData *avatar = ((historyHf*)array5[0]).icon;
                __block NSString *remark = ((historyHf*)array5[0]).nickName2;
                __block NSString *content = fileMsg.msgContent;
                
                if (fileMsg.sessionType == SessionTypeGroup) {
                    
                    MyGroupDB * gldbModel = [[MyGroupDB alloc]init];
                    [gldbModel createTable];
                    NSArray *resarry =  [gldbModel search:ID];
                    if (0 == resarry.count) {
                        //获取群组信息
                        [[GroupModule alloc] getGroupInfoWithID:ID success:^(IMGroupEntity* group){
                            NSLog(@"群组ID:%ld,群组名:%@,成员数:%d",(long)((IMGroupEntity*)group).ID,((IMGroupEntity*)group).name,((IMGroupEntity*)group).memberNumber);
                            [gldbModel saveMygroup:((IMGroupEntity*)group).name groupId:(int)((IMGroupEntity*)group).ID];
                            remark = ((IMGroupEntity*)group).name;
                            
                        } failure:^(NSString *error){}];
                        
                        [[GroupModule alloc] getGroupMemberListWithID:ID success:^(NSArray *memberList) {
                            //先清空群成员列表数据库
                            GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
                            [gmdb createTableWithGroupId:ID];
                            [gmdb deleteTable];
                            //再存入群成员列表数据库
                            BOOL creat1 = [gmdb createTableWithGroupId:ID];
                            if (creat1) {  //昵称， id，，头像，权限；创建者权限为1；
                                for(int j=1;j<memberList.count;j++){
                                    UIImage * avatar = ((IMGroupMemberEntity *)memberList[j]).avatar;
                                    
                                    NSData* avatarData;
                                    if (UIImagePNGRepresentation(avatar)) {
                                        avatarData = UIImagePNGRepresentation(avatar);
                                    }else {
                                        avatarData = UIImageJPEGRepresentation(avatar, 1.0);
                                    }
                                    
                                    if (((IMGroupMemberEntity *)memberList[j]).ID == fileMsg.senderId) {
                                        content = [NSString stringWithFormat:@"%@:%@",((IMGroupMemberEntity*)memberList[j]).remark,appearInfo];
                                    }
                                    
                                    [gmdb saveMygroupMember:((IMGroupMemberEntity*)memberList[j]).remark memberId:(int)((IMGroupMemberEntity *)memberList[j]).ID Icon:avatarData permit:((IMGroupMemberEntity*)memberList[j]).isManager];
                                }
                            }
                            
                            avatar = UIImagePNGRepresentation([UIImage imageNamed:(@"网信院徽128×128.png")]);
                            
                            [hfDbModel13 saveHistoryFriend:remark lastMessage:content icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] userId:fileMsg.toUserID redCount:redcount style:fileMsg.sessionType];
                            
                        } failure:^(NSString *error) {}];
                    }else{
                        MyGroupDB * gldbModel = [[MyGroupDB alloc]init];
                        [gldbModel createTable];
                        NSArray *resarry =  [gldbModel search:ID];
                        remark = ((MyGroupModel*)resarry[0]).myGroupName;
                        
                        GroupMemeberDb *gmdb = [[GroupMemeberDb alloc]init];
                        [gmdb createTableWithGroupId:ID];
                        NSArray *memarry = [gmdb search:fileMsg.senderId];
                        content = [NSString stringWithFormat:@"%@:%@",((GroupMemeberModel*)memarry[0]).memberName
                                   ,appearInfo];
                        
                        [hfDbModel13 saveHistoryFriend:remark lastMessage:content icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] userId:fileMsg.toUserID redCount:redcount style:fileMsg.sessionType];
                    }
    
                }else{
                    [hfDbModel13 saveHistoryFriend:remark lastMessage:appearInfo icon:avatar time:[NSDate dateWithTimeIntervalSince1970:(fileMsg.msgTime/1000)] userId:fileMsg.senderId redCount:redcount style:fileMsg.sessionType];
                }
                
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationReceiveMessage object:nil];
        }
        else
        {
            NSLog(@"error:%@",[error domain]);
        }
    }];
}

@end
