//
//  PrivacyProvisionsController.m
//  ios约束版
//
//  Created by 文博黄 on 2017/1/16.
//  Copyright © 2017年 tongho. All rights reserved.
//

#import "PrivacyProvisionsController.h"

@interface PrivacyProvisionsController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *Clausetext;

@end

@implementation PrivacyProvisionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.Clausetext.textColor
    = [UIColor blackColor];//设置textview里面的字体颜色
    
    self.Clausetext.font
    = [UIFont fontWithName:@"Arial"size:18.0];//设置字体名字和字体大小
    
    self.Clausetext.delegate
    = self;//设置它的委托方法
    
    self.Clausetext.backgroundColor
    = [UIColor whiteColor];//设置它的背景颜色
    
    self.Clausetext.text
    = @"APP免责声明及使用条款\n1、一切移动客户端用户在下载并浏览本应用时均被视为已经仔细阅读本条款并完全同意。凡以任何方式登陆本APP，或直接、间接使用本APP资料者，均被视为自愿接受本网站相关声明和用户服务协议的约束。\n2、本应用中发送的内容并不代表开发者之意见及观点，也不意味着开发者赞同其观点或证实其内容的真实性。\n3、本应用中发送的文字、图片、音视频等资料均由本APP用户提供，其真实性、准确性和合法性由信息发布人负责。开发者不提供任何保证，并不承担任何法律责任。\n4、本应用所发送的文字、图片、音视频等资料，如果侵犯了第三方的知识产权或其他权利，责任由作者或转载者本人承担，本APP对此不承担责任。\n5、本应用不保证为向用户提供便利而设置的外部链接的准确性和完整性，同时，对于该外部链接指向的不由开发者实际控制的任何网页上的内容，本应用不承担任何责任。\n6、用户明确并同意使用网络服务所存在的风险将完全由其本人承担；因其使用本应用网络服务而产生的一切后果也由其本人承担，本应用对此不承担任何责任。\n7、除注明之服务条款外，其它因不当使用本应用而导致的任何意外、疏忽、合约毁坏、诽谤、版权或其他知识产权侵犯及其所造成的任何损失，本应用概不负责，亦不承担任何法律责任。\n8、对于因不可抗力或因黑客攻击、通讯线路中断等不能控制的原因造成的网络服务中断或其他缺陷，导致用户不能正常使用本应用，本应用不承担任何责任，但将尽力减少因此给用户造成的损失或影响。\n9、本声明未涉及的问题请参见国家有关法律法规，当本声明与国家有关法律法规冲突时，以国家法律法规为准。\n10、本应用相关声明版权及其修改权、更新权和最终解释权均属本应用所有。\n\n隐私声明\n适用范围\n●您注册秘密信使（秘密信使网站和移动应用，统称为秘密信使）时，根据要求提供的个人信息；\n●在您使用秘密信使服务、参加活动、或访问网页时，秘密信使自动接收并记录的您浏览器上的服务器数据，包括但不限于IP地址、网站Cookie中的资料及您要求取用的网页记录；\n信息使用\n●秘密信使不会向任何人出售或出借您的个人信息，除非事先得到您的许可。\n●为服务用户的目的，秘密信使可能通过使用您的个人信息，向您提供服务，包括但不限于向您发出活动和服务信息等。    ●秘密信使承诺：非经法律程序或经您的许可不会泄露您的个人信息（如昵称、肖像、区域、健康信息等）。\n●如果您需要将三方共有的病情咨询设置为隐私内容，可向医生提出申请，医生同意后方可由秘密信使管理员设为隐私。\n会员须做到\n●用户名和昵称的注册与使用应符合网络道德，遵守中华人民共和国的相关法律法规。\n●用户名和昵称中不能含有威胁、淫秽、漫骂、非法、侵害他人权益等有争议性的文字。\n●注册成功后，会员必须保护好自己的帐号和密码，因会员本人泄露而造成的任何损失由会员本人负责。\n●不得盗用他人帐号，由此行为造成的后果自负。\n政策修改\n秘密信使保留对本政策作出不定时修改的权利。\n本隐私声明是您与秘密信使签署的注册协议的组成部分之一，请您仔细阅读";//设置它显示的内容
    
    self.Clausetext.scrollEnabled
    = YES;//是否可以拖动
    
    self.Clausetext.editable
    =NO;//禁止编辑
    
    self.Clausetext.autoresizingMask
    = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    [self.view
     addSubview: self.Clausetext];//加入到整个页面中
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backregistview:(id)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];
}

@end
