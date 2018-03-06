//
//  ConvertServerFeedback.m
//  ios约束版
//
//  Created by tongho on 2017/3/9.
//  Copyright © 2017年 tongho. All rights reserved.
//

#import "ServerFeedbackConverter.h"

@implementation ServerFeedbackConverter



+ (NSString *)convertServerFeedbackWithResultCode:(short)resultCode
{
    switch(resultCode) {
        case 0x0000 :
            return  @"成功";
            break;
        case 0x0108 :
            return  @"不存在";
            break;
        case 0x0109 :
            return  @"参数设置错误";
            break;
        case 0x0110 :
            return  @"已存在";
            break;
        case 0x0201 :
            return  @"数据库操作出错";
            break;
        case 0x0302 :
            return  @"明文长度错误";
            break;
        case 0x0303 :
            return  @"具有相同用户名和密码的用户有多个";
            break;
        case 0x0304 :
            return  @"用户名与密码不匹配";
            break;
        case 0x0305 :
            return  @"套接字溢出";
            break;
        case 0x0306 :
            return  @"套接字号为零";
            break;
        case 0x0307 :
            return  @"权限不够";
            break;
        case 0x0308 :
            return  @"群用户名不合法";
            break;
        case 0x0311 :
            return  @"用户名不存在";
            break;
        case 0x0312 :
            return  @"用户名已存在";
            break;
        case 0x0313 :
            return  @"用户名长度超出阈值";
            break;
        case 0x0314 :
            return  @"昵称格式不合法";
            break;
        case 0x0315 :
            return  @"用户名格式不合法";
            break;
        case 0x0316 :
            return  @"头像长度超出";
            break;
        case 0x0317 :
            return  @"昵称长度超出阈值";
            break;
        case 0x0318 :
            return  @"电话号码格式不合法";
            break;
        case 0x0319 :
            return  @"邮箱长度超出阈值";
            break;
        case 0x0320 :
            return  @"邮箱格式不合法";
            break;
        case 0x0321 :
            return  @"目标已经是好友";
            break;
        case 0x0322 :
            return  @"用户ID不存在";
            break;
        case 0x0323 :
            return  @"用户ID有多个";
            break;
        case 0x0324 :
            return  @"添加的人数超出上限";
            break;
        case 0x0325 :
            return  @"群成员重复添加";
            break;
        case 0x0326 :
            return  @"好友关系不存在";
            break;
        case 0x0327 :
            return  @"群ID不存在";
            break;
        case 0x0328 :
            return  @"群名称长度超过阈值";
            break;
        case 0x0329 :
            return  @"群ID已经存在";
            break;
        case 0x0330 :
            return  @"注册时昵称为空";
            break;
        case 0x0331 :
            return  @"昵称长度超出阈值";
            break;
        case 0x0332 :
            return  @"群成员过多";
            break;
        case 0x0333 :
            return  @"文件名长度过长";
            break;
        case 0x0334 :
            return  @"文件操作出错";
            break;
        case 0x0335 :
            return  @"文件大小超出阈值";
            break;
        case 0x0336 :
            return  @"重复登录";
            break;
        case 0x0337 :
            return  @"文件不存在";
            break;
        case 0x0338 :
            return  @"存在多个文件";
            break;
        case 0x0339 :
            return  @"注册类型错误";
            break;
        case 0x0340 :
            return  @"找不到对应注册信息";
            break;
        case 0x0341 :
            return  @"输入为空";
            break;
        default:
            return  @"unknown";
    }
}

+ (short)converResultCodetWithServerFeedback:(NSString*)feedback
{
    if ([feedback  isEqual: @"成功"])
        return  0x0000;
    if ([feedback  isEqual: @"不存在"])
        return  0x0108;
    if ([feedback  isEqual: @"参数设置错误"])
        return  0x0109;
    if ([feedback  isEqual: @"已存在"])
        return  0x0110;
    if ([feedback  isEqual: @"数据库操作出错"])
        return  0x0201;
    if ([feedback  isEqual: @"明文长度错误"])
        return  0x0302;
    if ([feedback  isEqual: @"具有相同用户名和密码的用户有多个"])
        return  0x0303;
    if ([feedback  isEqual: @"用户名与密码不匹配"])
        return  0x0304;
    if ([feedback  isEqual: @"套接字溢出"])
        return  0x0305;
    if ([feedback  isEqual: @"套接字号为零"])
        return  0x0306;
    if ([feedback  isEqual: @"权限不够"])
        return  0x0307;
    if ([feedback  isEqual: @"群用户名不合法"])
        return  0x0308;
    if ([feedback  isEqual: @"用户名不存在"])
        return  0x0311;
    if ([feedback  isEqual: @"用户名已存在"])
        return  0x0312;
    if ([feedback  isEqual: @"用户名长度超出阈值"])
        return  0x0313;
    if ([feedback  isEqual: @"昵称格式不合法"])
        return  0x0314;
    if ([feedback  isEqual: @"用户名格式不合法"])
        return  0x0315;
    if ([feedback  isEqual: @"头像长度超出"])
        return  0x0316;
    if ([feedback  isEqual: @"昵称长度超出阈值"])
        return  0x0317;
    if ([feedback  isEqual: @"电话号码格式不合法"])
        return  0x0318;
    if ([feedback  isEqual: @"邮箱长度超出阈值"])
        return  0x0319;
    if ([feedback  isEqual: @"邮箱格式不合法"])
        return  0x0320;
    if ([feedback  isEqual: @"目标已经是好友"])
        return  0x0321;
    if ([feedback  isEqual: @"用户ID不存在"])
        return  0x0322;
    if ([feedback  isEqual: @"用户ID有多个"])
        return  0x0323;
    if ([feedback  isEqual: @"添加的人数超出上限"])
        return  0x0324;
    if ([feedback  isEqual: @"群成员重复添加"])
        return  0x0325;
    if ([feedback  isEqual: @"好友关系不存在"])
        return  0x0326;
    if ([feedback  isEqual: @"群ID不存在"])
        return  0x0327;
    if ([feedback  isEqual: @"群名称长度超过阈值"])
        return  0x0328;
    if ([feedback  isEqual: @"群ID已经存在"])
        return  0x0329;
    if ([feedback  isEqual: @"注册时昵称为空"])
        return  0x0330;
    if ([feedback  isEqual: @"昵称长度超出阈值"])
        return  0x0331;
    if ([feedback  isEqual: @"群成员过多"])
        return  0x0332;
    if ([feedback  isEqual: @"文件名长度过长"])
        return  0x0333;
    if ([feedback  isEqual: @"文件操作出错"])
        return  0x0334;
    if ([feedback  isEqual: @"文件大小超出阈值"])
        return  0x0335;
    if ([feedback  isEqual: @"重复登录"])
        return  0x0336;
    if ([feedback  isEqual: @"文件不存在"])
        return  0x0337;
    if ([feedback  isEqual: @"存在多个文件"])
        return  0x0338;
    if ([feedback  isEqual: @"注册类型错误"])
        return  0x0339;
    if ([feedback  isEqual: @"找不到对应注册信息"])
        return  0x0340;
    if ([feedback  isEqual: @"输入为空"])
        return  0x0341;
    
    return  0x0000;
}
@end
