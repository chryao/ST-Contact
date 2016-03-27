//
//  DetailViewController.h
//  ST通讯录
//
//  Created by chen_ryao on 16/1/12.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController


@property (nonatomic,strong) NSDictionary *dataDic;
- (void)showdetailViewInView:(UIView *)view;
@end
