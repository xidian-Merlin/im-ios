//
//  TimeConvert.m
//  ios约束版
//
//  Created by tongho on 16/8/1.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import "TimeConvert.h"

@implementation TimeConvert

- (NSString *)distanceTimeWithBeforeTime:(double)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];   //将时间转化为字符串时，会根据时区自动调整时间，此处是自动增加8小时
    NSString * lastDay = [df stringFromDate:beDate];
    
    [df setDateFormat:@"yyyy"];
    NSString * nowYear = [df stringFromDate:[NSDate date]];
    NSString * lastYear = [df stringFromDate:beDate];
    
    [df setDateFormat:@"EEE"];
    NSString * nowWeek = [df stringFromDate:[NSDate date]];
    NSString * lastWeek = [df stringFromDate:beDate];

    
    if (distanceTime < 60) {//小于一分钟
      //  distanceStr = @"刚刚";
        distanceStr = [NSString stringWithFormat:@"%@",timeStr];
    }
    else if (distanceTime <60*60) {//时间小于一个小时
       // distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
         distanceStr = [NSString stringWithFormat:@"%@",timeStr];
    }
    else if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天且与当前时间在同一日 预防不同月
        distanceStr = [NSString stringWithFormat:@"%@",timeStr];      //今天
    }
    else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){//时间差小于两天且不同日的情况下
        //当前日期比它大一天 或者当前日期是1号，比它小
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天"];
        }//不是昨天，那么显示日期,
        //判断是否是本周
        else if (0 != [self.class getOneDay:nowWeek])  //不是周一就显示
        {
            distanceStr = lastWeek;
        
        }
        else if([nowYear integerValue] != [lastYear integerValue]){ //如果当前是周一，那就不用显示它是周几了,是否是今年
            [df setDateFormat:@"yyyy"];
            distanceStr = [df stringFromDate:beDate];
        }//是今年
        else{
            [df setDateFormat:@"MM-dd"];
            distanceStr = [df stringFromDate:beDate];
        }
        
    }
    else if (distanceTime <24*60*60*7 && ([self.class getOneDay:lastWeek] < [self.class getOneDay:nowWeek])){
        //间隔时间小于7天且它比当前时间的周几的数要小，那么该时间就是本周
        
        distanceStr = lastWeek; //直接显示为周几
        
        
    }
    else if(distanceTime <24*60*60*365 && [nowYear integerValue] == [lastYear integerValue]){  //如果时间差小于一年，且年分相同
        [df setDateFormat:@"MM-dd"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"yyyy"];        //如果不是今年  那么就直接显示年份
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}



- (NSString *)chatDistanceTimeWithBeforeTime:(double)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    
    [df setDateFormat:@"yyyy"];
    NSString * nowYear = [df stringFromDate:[NSDate date]];
    NSString * lastYear = [df stringFromDate:beDate];
    
    [df setDateFormat:@"EEE"];
    NSString * nowWeek = [df stringFromDate:[NSDate date]];
    NSString * lastWeek = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        //  distanceStr = @"刚刚";
        distanceStr = [NSString stringWithFormat:@"%@",timeStr];
    }
    else if (distanceTime <60*60) {//时间小于一个小时
        // distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
        distanceStr = [NSString stringWithFormat:@"%@",timeStr];
    }
    else if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天且与当前时间在同一日 预防不同月
        distanceStr = [NSString stringWithFormat:@"%@",timeStr];
    }
    else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }//不是昨天，那么显示日期,
        //判断是否是今年 本周
        //判断是否是本周
        else if (0 != [self.class getOneDay:nowWeek])  //不是周一就显示
        {
           // distanceStr = lastWeek;
            distanceStr = [NSString stringWithFormat:@"%@ %@",lastWeek,timeStr];
        }
        
        else if([nowYear integerValue] != [lastYear integerValue]){
            [df setDateFormat:@"yyyy"];
            distanceStr = [df stringFromDate:beDate];
        }
        else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
        
    }
    
    else if (distanceTime <24*60*60*7 && ([self.class getOneDay:lastWeek] < [self.class getOneDay:nowWeek])){
        //间隔时间小于7天且它比当前时间的周几的数要小，那么该时间就是本周
        
        distanceStr = [NSString stringWithFormat:@"%@ %@",lastWeek,timeStr];
        
        
    }
    
    else if(distanceTime <24*60*60*365 && [nowYear integerValue] == [lastYear integerValue]){  //今年
        [df setDateFormat:@"MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}





//判断时间是否是本周

+ (int)getOneDay:(NSString *) weekString{
    
    int day ;
    
if ([weekString  isEqual: @"周一"]) {
    day = 0; //
} else if ([weekString isEqual:@"周二"]) {
    day = 1;
} else if ([weekString isEqual:@"周三"]) {
    day = 2;
} else if ([weekString isEqual:@"周四"]) {
    day = 3;
} else if ([weekString isEqual:@"周五"]) {
    day = 4;
} else if ([weekString isEqual:@"周六"]) {
    day = 5;
} else if ([weekString isEqual:@"周日"]) {
    day = 6;
}
    return day;
}



@end
