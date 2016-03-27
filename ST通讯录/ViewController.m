//
//  ViewController.m
//  ST通讯录
//
//  Created by chen_ryao on 16/1/11.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//

#import "ViewController.h"
#import <BmobSDK/Bmob.h>
#import "DetailViewController.h"
#import "pinyin.h"
#import "ChineseString.h"
#import "MBProgressHUD.h"
#import "UIView+Extension.h"
#import "MenuViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UISearchBarDelegate,UISearchResultsUpdating,MenuViewDelegate>
//- (IBAction)leftMenuClick:(UIBarButtonItem *)sender;
/**
 *  顶部菜单
 */

@property (nonatomic,strong) NSDictionary *dataSource;
/**
 *  所有姓名  数组
 */
@property (nonatomic,strong) NSArray *nameArr;
@property (nonatomic,strong) NSDictionary *nameList;
//@property (nonatomic,strong) MBProgressHUD *HUD;

@property (nonatomic,strong) NSArray *sectionTitleArr;
@property (nonatomic,strong)     MBProgressHUD *HUD;

/**
 *  表格部分
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSDictionary *nameDicWithKeyOfPinyin;

@property (nonatomic,strong) NSMutableArray *searchList;





@property (nonatomic,strong) DetailViewController *DVC;
@property (nonatomic,strong) MenuViewController *MVC;




@end

@implementation ViewController

- (void)viewDidLoad {
    
    [self createUI];
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

- (void)loadDataSource{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSLog(@"%@",docPath);
    NSString *dataSourcePath = [docPath stringByAppendingString:@"/contact.plist"];
    _dataSource = [NSDictionary dictionaryWithContentsOfFile:dataSourcePath];
    if (_nameList == nil){
        NSString *nameListPath = [docPath stringByAppendingString:@"/nameList.plist"];
        _nameList = [NSDictionary dictionaryWithContentsOfFile:nameListPath];
    }
    if (_sectionTitleArr.count == 0) {
        NSString *sectionTitleArrPath = [docPath stringByAppendingString:@"/sectionTitleArr.plist"];
        _sectionTitleArr = [NSArray arrayWithContentsOfFile:sectionTitleArrPath];
    }
}
#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_searchController.active) {
        return 1;
    }else{
        if (tableView == _tableView) {
            return _sectionTitleArr.count;
        }else return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
    if (tableView == _tableView) {
        NSArray *arr = [_nameList objectForKey:_sectionTitleArr[section]];
        return arr.count;
    }else return 2;
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
        NSArray *arr = [_nameList objectForKey:_sectionTitleArr[indexPath.section]];
        NSString *name = arr[indexPath.row];
        
        NSDictionary *dic = [_dataSource objectForKey:name];
        NSString *tel = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tel"]];
        cell.textLabel.text = name;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.text = tel;
        NSString *sectionTitle = [_sectionTitleArr objectAtIndex:indexPath.section];
        cell.imageView.image = [UIImage imageNamed:sectionTitle];
        [cell.imageView.layer setCornerRadius:cell.imageView.width/2];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
        }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    传数据到DetailViewController
    NSArray *arrInSection = [_nameList objectForKey:[_sectionTitleArr objectAtIndex:indexPath.section]];
    NSString *name = @"";
    if (_searchController.active) {
        name =  [_nameDicWithKeyOfPinyin objectForKey:_searchList[indexPath.row]];
    }else{
        name = [arrInSection objectAtIndex:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_searchController setActive:NO];
    
    _DVC = [[DetailViewController alloc]init];
    _DVC.view.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    _DVC.dataDic = [_dataSource objectForKey:name];

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
        if (tableView == _tableView) {
            return _sectionTitleArr[section];
        }else
        return nil;
    }
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    _DVC = segue.destinationViewController;
}

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
    BmobQuery *query = [BmobQuery queryWithClassName:@"contact"];
    [query orderByAscending:@"name"];
    query.limit = 200;
    NSNumber *classNum = [NSNumber numberWithInt:10];
    [query whereKey:@"season" equalTo:classNum];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSMutableDictionary *contactsDic = [NSMutableDictionary dictionary];
        for (BmobObject *bo in array) {
            [bo objectForKey:@"name"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[bo objectForKey:@"name"] forKey:@"name"];
            [dic setObject:[bo objectForKey:@"tel"] forKey:@"tel"];
            [dic setObject:[bo objectForKey:@"info"] forKey:@"info"];
            [dic setObject:[bo objectForKey:@"class"] forKey:@"class"];
            [dic setObject:[bo objectForKey:@"season"] forKey:@"season"];
            [dic setObject:[bo objectForKey:@"objectId"] forKey:@"objectId"];
            [contactsDic setObject:dic forKey:[dic objectForKey:@"name"]];
        }

        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *path = [docPath stringByAppendingString:@"/contact.plist"];
        [contactsDic writeToFile:path atomically:YES];
        _nameArr = [contactsDic allKeys];
        [self gettingSortedNameArr:YES];
        [self loadDataSource];
//        [_HUD hide:YES]
        
    }];
    
}

- (void)gettingSortedNameArr:(BOOL)shouldSort{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *path = [docPath stringByAppendingString:@"/nameList.plist"];
    NSMutableArray *nameArrSorted = [NSMutableArray array];
    if (shouldSort) {
        for (NSString *name in _nameArr) {
            ChineseString *nameString = [[ChineseString alloc]init];
            nameString.string = [NSString stringWithString:name];
            
            if(nameString.string==nil){
                nameString.string=@"";
            }
            
            if(![nameString.string isEqualToString:@""]){
                NSString *pinYinResult=[NSString string];
                for(int j=0;j<nameString.string.length;j++){
                    NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([nameString.string characterAtIndex:j])]uppercaseString];
                    
                    pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                nameString.pinYin=pinYinResult;
            }else{
                nameString.pinYin=@"";
            }
            [nameArrSorted addObject:nameString];
        }
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
        [nameArrSorted sortUsingDescriptors:sortDescriptors];
        NSMutableDictionary *nameList = [NSMutableDictionary dictionary];
        NSMutableArray *arr = [NSMutableArray array];

        NSMutableArray *sTA = [NSMutableArray array];
        for (int i = 0; i < nameArrSorted.count ;i ++) {
            ChineseString *thiscs = nameArrSorted[i];
            if (thiscs == [nameArrSorted firstObject]) {
                [sTA addObject:[[NSString stringWithFormat:@"%c",pinyinFirstLetter([thiscs.string characterAtIndex:0])]uppercaseString]];
                [arr addObject:thiscs.string];
            }else{
                ChineseString *lastcs = nameArrSorted[i-1];
                if (pinyinFirstLetter([lastcs.string characterAtIndex:0])!=pinyinFirstLetter([thiscs.string characterAtIndex:0])) {
                    [sTA addObject:[[NSString stringWithFormat:@"%c",pinyinFirstLetter([thiscs.string characterAtIndex:0])]uppercaseString]];
                    
                    [nameList setObject:arr forKey:[[NSString stringWithFormat:@"%c",pinyinFirstLetter([lastcs.string characterAtIndex:0])]uppercaseString]];
                    arr = [NSMutableArray arrayWithObject:thiscs.string];
                    
                }else {
                    [arr addObject:thiscs.string];
                    if (thiscs == [nameArrSorted lastObject]) {
                        [nameList setObject:arr forKey:[[NSString stringWithFormat:@"%c",pinyinFirstLetter([thiscs.string characterAtIndex:0])] uppercaseString]];
                    }
                }
            }
        }
        _sectionTitleArr = [sTA copy];
        [_sectionTitleArr writeToFile:[docPath stringByAppendingString:@"/sectionTitleArr.plist"] atomically:YES];
        _nameList = nameList;
        [nameList writeToFile:path atomically:YES];
    }
    NSMutableDictionary *nameDicWithKeyOfPinyin = [NSMutableDictionary dictionary];
    for (NSString *name in _nameArr) {
        NSString *pinyin = @"";
        for (int i = 0; i < name.length; i++) {
            pinyin = [pinyin stringByAppendingString:[[NSString stringWithFormat:@"%c",pinyinFirstLetter([name characterAtIndex:i])]uppercaseString]] ;
        }
        [nameDicWithKeyOfPinyin setValue:name  forKey:pinyin];
    }
    
    [nameDicWithKeyOfPinyin writeToFile:[docPath stringByAppendingString:@"/nameDicWithKeyOfPinyin.plist"] atomically:YES];
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
        NSString *path = [docPath stringByAppendingString:@"/nameDicWithKeyOfPinyin.plist"];
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
    NSLog(@"点击了目录(%ld)选项",(long)tag);
}


#pragma mark - 关于我们Alert
- (void)showAlert{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"双体通讯录感谢您的使用" message:@"本软件由双体系项目开发中心独立开发和设计,仅供内部学习交流使用\n设计:严一鑫/开发: 蒋朝任(Android)、陈荣耀(IOS)\n如果你对本软件(IOS端)有任何的意见或建议请联系\n\n电话18883942294 \nE-mail chen798136658@live.cn\n\n\n©开发中心官网http://www.stxdev.com\n©开发中心博客http://blog.stxdev.com" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
