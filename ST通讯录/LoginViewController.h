//
//  LoginViewController.h
//  ST通讯录
//
//  Created by chen_ryao on 16/3/7.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
- (IBAction)resignBnt;
- (IBAction)cancelBtn;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengmaTF;
@property (weak, nonatomic) IBOutlet UIButton *getYanZhengBtn;
- (IBAction)getYanzhengBtnClick;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnClick;

@end
