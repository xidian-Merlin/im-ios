//
//  ReceivePictureAPI.m
//  ImAddition
//
//  Created by tongho on 16/8/11.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "ReceivePictureAPI.h"
#import "IMTcpProtocolHeader.h"
#import "DataInputStream.h"
#import "IMMessageEntity.h"
#import "IMAPIUnrequestScheduleProtocol.h"
#import "UIKit/UIKit.h"
#import "Person.h"

@implementation ReceivePictureAPI
- (int)responseCommandID
{
    return IM_MESSAGE;
}

- (int)responseSubcommandID
{
    return IM_MESS_RECEIVE_PIC;
}

- (UnrequestAPIAnalysis)unrequestAnalysis
{
    UnrequestAPIAnalysis analysis = (id)^(NSData *data)
    {
        DataInputStream *datain = [[DataInputStream alloc] init];
        datain = [DataInputStream dataInputStreamWithData:data];
        long msgID = [datain readLong];
        NSLog(@"消息ID：%ld",msgID);
        long time = [datain readLong];
        NSLog(@"中转时间：%ld",time);
        int sessionType = [datain readInt];
        int fromUserID = [datain readInt];
        int toUserID = [datain readInt];
    
        int imgLength = [datain readInt];
        NSLog(@"图片长度：%d",imgLength);
        //NSData *img = [datain readLeftData];
        NSData *img = [datain readDataWithLength:imgLength];

        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [docPaths lastObject];
        
        //获取cache，存自建文件
        NSString *nowCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];

        
        NSString *nowPath = [filePath stringByAppendingPathComponent:@"nowUser.data"];
        Person *nowUser = [NSKeyedUnarchiver unarchiveObjectWithFile:nowPath];
        
        NSString *imgPath = [nowCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/Image/%ld.jpg",nowUser.userName,(long)[[NSDate date] timeIntervalSince1970]]];
        NSLog(@"图片地址：%@",imgPath);
        NSString *msgpath = [NSString stringWithFormat:@"Image/%ld.jpg",(long)[[NSDate date] timeIntervalSince1970]];
        UIImage *image = [UIImage imageWithData:img]; // 取得图片
//        NSString * fileName = [NSString stringWithFormat:@"%@/Image/%ld.png",nowUser.userName,(long)[[NSDate date] timeIntervalSince1970]];//以记录时间为文件名
//        NSString *imageURL = [filePath stringByAppendingPathComponent:fileName];
//        NSLog(@"图片地址:%@",imageURL);
//        [UIImagePNGRepresentation(image) writeToFile:imageURL atomically:YES];
        
//        UIImage *image = [UIImage imageWithData:img]; // 取得图片
        // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
        BOOL success = [UIImageJPEGRepresentation(image, 1) writeToFile:imgPath atomically:YES];
        if (success){
            NSLog(@"写入本地成功");
        }else{
            NSLog(@"写入失败！！！");
        }
        
        IMMessageEntity *msg = [[IMMessageEntity alloc]initWithMsgID:msgID msgTime:time SessionType:sessionType senderID:fromUserID toUserID:toUserID IMMessageContentType:IMMessageTypeImage msgContent:msgpath];
        return msg;
    };
    return analysis;
}
@end
