//
//  MenuViewController.m
//  ST通讯录
//
//  Created by chen_ryao on 16/3/12.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//

#import "MenuViewController.h"
#import "UIView+Extension.h"

@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_image;
    UIView *_bgView;
    NSArray *imageArr;
    NSArray *textArr;
    CGFloat menuW;
    CGFloat lastX;
    UIPanGestureRecognizer *_pan;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [self createUI];
    [super viewDidLoad];
    lastX = 0;
    
}
- (void)createUI{
    _bgView = [[UIView alloc]initWithFrame:self.view.frame];
    [_bgView setBackgroundColor:[UIColor blackColor]];
    [_bgView setAlpha:0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuShouldDismiss)];
    [_bgView addGestureRecognizer:tap];
    
    menuW = [UIScreen mainScreen].bounds.size.width - 64;
    CGFloat menuH = [UIScreen mainScreen].bounds.size.height - 64;
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, menuW, menuW * 0.7)];
    _image.image = [UIImage imageNamed:@"img-1"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(-menuW, 0, menuW, menuH)];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setScrollEnabled:NO];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setTableHeaderView:_image];
    
    
//    [self.view setFrame:CGRectMake(-menuW, 0, menuW, menuH)];
    [self.view addSubview:_bgView];
    [self.view addSubview:_tableView];
    
    
    //初始化数据
    if (imageArr == nil ||textArr == nil) {
        imageArr = [NSArray arrayWithObjects:@"home_2",@"refresh",@"development", nil];
        textArr = [NSArray arrayWithObjects:@"首页",@"更新数据",@"关于我们", nil];
    }
    
}
#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.text = [textArr objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[imageArr objectAtIndex:indexPath.row]];
    cell.imageView.width = 10;
    cell.imageView.height = 10;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate menuViewDidClicked:indexPath.row];
    [self menuShouldDismiss];
}




- (void)showMenuViewInView:(UIView *)view withRecognizer:(UIPanGestureRecognizer *)recognizer{
    if (_pan == nil) {
        _pan = recognizer;
    }
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [view addSubview:self.view];
    }
    CGFloat translationX = [recognizer translationInView:view].x;
    _tableView.transform = CGAffineTransformTranslate(_tableView.transform, translationX - lastX, 0);
    CGFloat alpha = translationX/menuW * 0.5;
    [_bgView setAlpha:alpha];
    lastX = translationX;
}


- (void)menuShouldShow{
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.x = 0;
        [_bgView setAlpha:0.5];
    }];
    [_pan setEnabled:NO];
}

- (void)menuShouldDismiss{
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.x = -menuW;
        [_bgView setAlpha:0];
    }completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];

    }];
    [_pan setEnabled:YES];
}
@end
