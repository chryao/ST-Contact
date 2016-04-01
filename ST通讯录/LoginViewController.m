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
@end
