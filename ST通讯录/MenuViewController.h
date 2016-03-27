//
//  MenuViewController.h
//  ST通讯录
//
//  Created by chen_ryao on 16/3/12.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MenuViewDelegate<NSObject>
@optional
- (void)menuViewDidClicked:(NSInteger)tag;
@end
@interface MenuViewController : UIViewController

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) id<MenuViewDelegate> delegate;

- (void)showMenuViewInView:(UIView *)view withRecognizer:(UIPanGestureRecognizer *)recognizer;
- (void)menuShouldShow;
- (void)menuShouldDismiss;
@end
