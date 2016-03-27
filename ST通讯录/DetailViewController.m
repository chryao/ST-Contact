//
//  DetailViewController.m
//  ST通讯录
//
//  Created by chen_ryao on 16/1/12.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailContactCell.h"
#import "ViewController.h"
#import "pinyin.h"
#import "UIView+Extension.h"
@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    UIView *_bgView;
    UIImageView *_imageView;
    UILabel *_nameLabel;
    BOOL viewCanExit;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [self createUI];
    self.navigationController.delegate = self;
    [super viewDidLoad];
}


- (void)createUI{
    viewCanExit = NO;
    CGFloat imageW = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageH = imageW * 0.7;
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageW,[UIScreen mainScreen].bounds.size.height - 64)];
    [_bgView setAlpha:0];
    [_bgView setBackgroundColor:[UIColor blackColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissDetailView)];
    [_bgView addGestureRecognizer:tap];

    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageW, imageH)];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageW, imageH)];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _imageView.height - 45, 175, 25)];
    [_nameLabel setFont:[UIFont systemFontOfSize:35]];
    [_nameLabel setTextColor:[UIColor whiteColor]];
    
    [headView addSubview:_imageView];
    [headView addSubview:_nameLabel];

    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.height, imageW, self.view.height - 80) style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageW, _tableView.height-imageH-88)];
    [footView setBackgroundColor:[UIColor whiteColor]];
    
    [_tableView setTableHeaderView:headView];
    [_tableView setTableFooterView:footView];
    
    
    [self.view addSubview:_bgView];
    [self.view addSubview:_tableView];
//    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
//    [self.view addSubview:_imageView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showdetailViewInView:(UIView *)view{
    [view addSubview:self.view];
    [UIView animateWithDuration:0.5 animations:^{
        [_bgView setAlpha:0.5];
        _tableView.y = 80;
    }];
    
    NSString *name = [_dataDic objectForKey:@"name"];
    _nameLabel.text =  name;
    NSString *firstLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([name characterAtIndex:0])]uppercaseString];
    _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"wide_%@",firstLetter]];
}

- (void)dismissDetailView{
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.y = self.view.height;
        [_bgView setAlpha:0];
    }completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];

}
#pragma mark - UITableViewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if (indexPath.row) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"tel"]];
        cell.detailTextLabel.text = @"重庆";
    }else{
        NSNumber *classNum = [_dataDic objectForKey:@"class"];
        NSNumber *seasonNum = [_dataDic objectForKey:@"season"];
        if (classNum == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@期项目开发中心",seasonNum];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@期项目%@部",seasonNum,classNum];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[_dataDic objectForKey:@"tel"]]]];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y >60) {
        CGPoint p;
        p.x = 0;
        p.y = 60;
        scrollView.contentOffset = p;
    }
    if (scrollView.contentOffset.y <-80) {
        viewCanExit = YES;
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (viewCanExit) {
        [self dismissDetailView];
        viewCanExit = NO;
    }
}
@end
