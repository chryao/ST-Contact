//
//  ViewController.m
//  ST通讯录
//
//  Created by chen_ryao on 16/1/11.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "UIView+Extension.h"
#import "MenuViewController.h"
#import "DataController.h"
#import "Contact.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UISearchBarDelegate,UISearchResultsUpdating,MenuViewDelegate>
{
    int dataNum;
}
/**
 *  所有姓名  数组
 */
@property (nonatomic,strong) NSDictionary *nameDic;
@property (nonatomic,strong) NSArray *sectionTitleArr;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) DataController *DC;
@property (nonatomic,strong) Contact *contact;
@property (nonatomic,strong) NSDictionary *nameDicWithKeyOfPinyin;


/**
 *  表格部分
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *searchList;

@property (nonatomic,strong) DetailViewController *DVC;
@property (nonatomic,strong) MenuViewController *MVC;




@end

@implementation ViewController

- (void)viewDidLoad {
    
    [self createUI];
    self.DC = [[DataController alloc]init];
    _nameDic = [NSMutableDictionary dictionary];
    
    
    [self loadDataSource];
    [super viewDidLoad];
}


- (void)createUI{
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionIndexColor = [UIColor colorWithRed:3.f/255 green:169.f/255 blue:244.f/255 alpha:1.0];
    
    
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(0, 44, self.tableView.size.width, 44);
    
    _searchController.searchBar.placeholder = @"搜索联系人";
    
    
    _tableView.tableHeaderView = _searchController.searchBar;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(menuDidShow:)];
    [self.view addGestureRecognizer:pan];
}

#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_searchController.active) {
        return 1;
    }else{
            return _sectionTitleArr.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        NSArray *arr = [_nameDic objectForKey:[_sectionTitleArr objectAtIndex:section]];
        return arr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if (self.searchController.active) {
        [cell.textLabel setText:[_nameDicWithKeyOfPinyin objectForKey:_searchList[indexPath.row]]];
        cell.imageView.image = nil;
        return cell;
    }else{
        NSArray *arr = [_nameDic objectForKey:[_sectionTitleArr objectAtIndex:indexPath.section]];
        cell.textLabel.text = [arr objectAtIndex:indexPath.row];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        
        //从数据库查找数据
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@",[arr objectAtIndex:indexPath.row]];
        [request setPredicate:pre];
        NSArray *data = [_DC.context executeFetchRequest:request error:nil];
        Contact *c = [data lastObject];
        cell.detailTextLabel.text = [c.tel stringValue];
    
        NSString *sectionTitle = [_sectionTitleArr objectAtIndex:indexPath.section];
        cell.imageView.image = [UIImage imageNamed:sectionTitle];
        [cell.imageView.layer setCornerRadius:cell.imageView.width/2];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        dataNum ++;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    传数据到DetailViewController
    NSArray *arrInSection = [_nameDic objectForKey:[_sectionTitleArr objectAtIndex:indexPath.section]];
    NSString *name = @"";
    if (_searchController.active) {
        name =  [_nameDicWithKeyOfPinyin objectForKey:_searchList[indexPath.row]];
    }else{
        name = [arrInSection objectAtIndex:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_searchController setActive:NO];
    if (_DVC == nil) {
        _DVC = [[DetailViewController alloc]init];
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@",name];
    [request setPredicate:pre];
    NSArray *arr = [_DC.context executeFetchRequest:request error:nil];
    _DVC.data = [arr lastObject];
    _DVC.view.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    [_DVC showdetailViewInView:self.navigationController.view];
}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    if (tableView == _tableView) {
        return _sectionTitleArr;
    }
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_searchController.active) {
        return nil;
    }else{
        return _sectionTitleArr[section];
    }
    
}



//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    _DVC = segue.destinationViewController;
//}

#pragma mark - 数据相关
/**
 *  从服务器拉取数据
 */
- (void)gettingData{
    _HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_HUD];
    _HUD.delegate = self;
    _HUD.mode = MBProgressHUDModeAnnularDeterminate;
    _HUD.labelText = @"正在和服务器撕扯...";
    _HUD.minShowTime = 1.5;
    [_HUD showWhileExecuting:@selector(animationHUD) onTarget:self withObject:nil animated:YES];
    [_DC fetchDataFromCloud];
}
/**
 *  从本地加载数据
 */
- (void)loadDataSource{
    _nameDic = [_DC catchSortedNameArray];
    _sectionTitleArr = _DC.sectionTitleArr;
    [self.tableView reloadData];
}



#pragma mark - Menu相关操作
- (void)animationHUD{
    float progress = 0.0f;
    while (progress < 1.f) {
        progress += 0.05f;
        _HUD.progress = progress;
        usleep(50000);
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    _HUD = [[MBProgressHUD alloc ]initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"complete.png"]];
    _HUD.labelText = @"加载完成！";
    [_HUD show:YES];
    [_HUD hide:YES afterDelay:1.0];
}



-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (_nameDicWithKeyOfPinyin == nil) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *path = [docPath stringByAppendingPathComponent:@"nameDicWithKeyOfPinyin.plist"];
        _nameDicWithKeyOfPinyin = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchString];
    
    if (_searchList !=nil) {
        [_searchList removeAllObjects];
    }
    
    self.searchList = [NSMutableArray arrayWithArray:[[_nameDicWithKeyOfPinyin allKeys] filteredArrayUsingPredicate:preicate]];
    [self.tableView reloadData];
}

- (void)menuDidShow:(UIPanGestureRecognizer *)pan{
    CGFloat translationX = [pan translationInView:self.view].x;
    if (translationX < self.view.width - 64) {  //避免侧边栏拉过位
        if (pan.state == UIGestureRecognizerStateBegan) {
            _MVC = [[MenuViewController alloc]init];
            _MVC.view.frame = [UIScreen mainScreen].bounds;
            _MVC.delegate = self;
            [self addChildViewController:_MVC];
        }
        [_MVC showMenuViewInView:self.view withRecognizer:pan];
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (translationX < (_MVC.view.width - 64)/2) {
            [_MVC menuShouldDismiss];
        }else{
            [_MVC menuShouldShow];
            
        }
    }
    
}
- (void)menuViewDidClicked:(NSInteger)tag{
    switch (tag) {
        case 1:
            [self gettingData];
            [self loadDataSource];
            break;
        case 2:
            [self showAlert];
            break;
        default:
            break;
    }
}


#pragma mark - 关于我们Alert
- (void)showAlert{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"双体通讯录感谢您的使用" message:@"本软件由双体系项目开发中心独立开发和设计,仅供内部学习交流使用\n设计:严一鑫/开发: 蒋朝任(Android)、陈荣耀(IOS)\n如果你对本软件(IOS端)有任何的意见或建议请联系\n\n电话18883942294 \nE-mail chen798136658@live.cn\n\n\n©开发中心官网http://www.stxdev.com\n©开发中心博客http://blog.stxdev.com" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
