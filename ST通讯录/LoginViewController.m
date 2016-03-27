//
//  LoginViewController.m
//  ST通讯录
//
//  Created by chen_ryao on 16/3/7.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//
#import "LoginViewController.h"
#import <BmobMessageSDK/Bmob.h>
@interface LoginViewController ()<UITextFieldDelegate>
{
    NSString *phoneNumber;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)createUI{
//    _getYanzhengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    CGFloat getYZBtnWidth = 150;
//    CGFloat getYZBtnHeight = 30;
//    _getYanzhengBtn.frame = CGRectMake(self.view.center.x - getYZBtnWidth/2, _phoneNumberTF.frame.origin.y + 74, getYZBtnWidth, getYZBtnHeight);
//    _getYanzhengBtn.titleLabel.textColor = [UIColor colorWithRed:4.f/255 green:169.f/255 blue:244.f/255 alpha:1];
//    _getYanzhengBtn.titleLabel.font = [UIFont systemFontOfSize:30];
//    [_getYanzhengBtn addTarget:self action:@selector(getYanzhengBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:_getYanzhengBtn];

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
        if (self.phoneNumberTF.text.length == 10) {
            [self.getYanZhengBtn setEnabled:YES];
        }else{
            [self.getYanZhengBtn setEnabled:NO];
        }
    [self.loginBtn setEnabled:(self.yanzhengmaTF.text.length == 5)];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneNumberTF endEditing:YES];
    if (self.phoneNumberTF.text.length == 11) {
        [self.getYanZhengBtn setEnabled:YES];
    } else{
        [self.getYanZhengBtn setEnabled:NO];
    }
    [self.loginBtn setEnabled:(self.yanzhengmaTF.text.length == 6)];

}

- (IBAction)resignBnt {
    
}

- (IBAction)cancelBtn {
}
- (IBAction)getYanzhengBtnClick {
    phoneNumber = self.phoneNumberTF.text;
    [self.getYanZhengBtn setHidden:YES];
    [self.yanzhengmaTF setHidden:NO];
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:phoneNumber andTemplate:@"双体通讯录" resultBlock:^(int number, NSError *error) {
        NSLog(@"%@",phoneNumber);
        if (error) {
            NSLog(@"%@",error);
        } else {
            //获得smsID
            NSLog(@"sms ID：%d",number);
        }
    }];
    
}
- (IBAction)loginBtnClick {
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:phoneNumber andSMSCode:self.yanzhengmaTF.text resultBlock:^(BOOL isSuccessful, NSError *error) {
          if (isSuccessful) {
            NSLog(@"%@",@"验证成功，可执行用户请求的操作");
        } else {
            NSLog(@"%@",error);
        }
    }];
}
@end
