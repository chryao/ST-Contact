//
//  PersonalViewController.m
//  ST通讯录
//
//  Created by chen_ryao on 16/3/7.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//

#import "PersonalViewController.h"
#import "UIView+Extension.h"
@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate>
{
    UIImageView *_image;
    UITableView *_tableView;
    UILabel *_nameLabel;
    CGFloat *_lastY;
    NSArray *_className;
}
@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [self createUI];
    [super viewDidLoad];
}

- (void)createUI{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, self.view.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenW/2)];
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenW/2)];
    _image.image = [UIImage imageNamed:@"headImageInPersonal"];
    
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, headView.height - 50, screenW, 30)];
    [_nameLabel setFont:[UIFont systemFontOfSize:35]];
    _nameLabel.text = @"敖日格勒";
    [_nameLabel setTextColor:[UIColor whiteColor]];
    [_nameLabel setTextAlignment:NSTextAlignmentCenter];

    
    CGFloat iconW = 70;
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(screenW/2-iconW/2, _nameLabel.y - 10 - iconW, iconW, iconW)];
    icon.image = [UIImage imageNamed:@"A"];
    [icon.layer setCornerRadius:iconW/2];
    [icon.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [icon.layer setBorderWidth:2];
    
    
    [headView addSubview:_image];
    [headView addSubview:icon];
    [headView addSubview:_nameLabel];
    
    [_tableView setTableHeaderView:headView];
    [self.view addSubview:_tableView];
    
    
    
    //初始化数据
    _className = [NSArray arrayWithObjects:@"项目开发中心",@"项目一部",@"项目二部",@"项目三部", nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setText:[_className objectAtIndex:indexPath.row]];
    }
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"十期";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [tableView cellForRowAtIndexPath:indexPath];
    }
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }else{
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
