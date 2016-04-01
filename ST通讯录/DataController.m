//
//  DataController.m
//  ST通讯录
//
//  Created by chen_ryao on 16/3/27.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//

#import "DataController.h"
#import <BmobSDK/Bmob.h>
#import "Contact.h"
#import "ChineseString.h"
#import "pinyin.h"

@interface DataController()

@end

@implementation DataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self coreData];
    }
    return self;
}
/**
 *  创建coreData
 */
- (void)coreData{
    //上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //上下文关联数据库model
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlPath = [docPath stringByAppendingPathComponent:@"contacts.sqlite"];
    NSLog(@"%@",sqlPath);
    
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlPath] options:nil error:nil];
    
    [context setPersistentStoreCoordinator:store];
    _context = context;
}
/**
 *  从云端拉取数据
 */
- (void)fetchDataFromCloud{
    BmobQuery *query = [BmobQuery queryWithClassName:@"contact"];
    [query orderByAscending:@"name"];
    query.limit = 1000;
    NSNumber *classNum = [NSNumber numberWithInt:10];
    [query whereKey:@"season" equalTo:classNum];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *bo in array) {
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"objectId = %@",[bo objectForKey:@"objectId"]];
            [request setPredicate:pre];
            NSArray *arr = [_context executeFetchRequest:request error:nil];
            if (arr.count) {
                Contact *c = [arr lastObject];
                c.name = [bo objectForKey:@"name"];
                c.tel = [bo objectForKey:@"tel"];
                c.info = [bo objectForKey:@"info"];
                c.season = [bo objectForKey:@"season"];
                c.classNum = [bo objectForKey:@"class"];
                c.objectId = [bo objectForKey:@"objectId"];
                [_context save:nil];
            }else{
                Contact *c = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:_context];
                c.name = [bo objectForKey:@"name"];
                c.tel = [bo objectForKey:@"tel"];
                c.info = [bo objectForKey:@"info"];
                c.season = [bo objectForKey:@"season"];
                c.classNum = [bo objectForKey:@"class"];
                c.objectId = [bo objectForKey:@"objectId"];
                [_context save:nil];
            }
        }
    }];
    [self catchSortedNameArray];
}

- (NSDictionary *)catchSortedNameArray{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    NSArray *modelArr = [_context executeFetchRequest:request error:nil];;
    NSMutableArray *nameArr = [NSMutableArray array];
    for (Contact *c in modelArr) {
        [nameArr addObject:c.name];
    }
    NSMutableArray *nameArrSorted = [NSMutableArray array];
    
    //转换成拼音首字母形式
    for (NSString *name in nameArr) {
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
    //排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [nameArrSorted sortUsingDescriptors:sortDescriptors];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    
//    for (ChineseString *c in nameArrSorted) {
//        [arr addObject:c.string];
//    }
    //得到拼音数组
    NSMutableArray *sTA = [NSMutableArray array];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < nameArrSorted.count ;i ++) {
        ChineseString *thiscs = nameArrSorted[i];
        if ([thiscs isEqual:[nameArrSorted firstObject]] ) {
            [sTA addObject:[[NSString stringWithFormat:@"%c",pinyinFirstLetter([thiscs.string characterAtIndex:0])]uppercaseString]];
        }
        else{
            ChineseString *lastcs = nameArrSorted[i-1];
            if (pinyinFirstLetter([lastcs.string characterAtIndex:0])!=pinyinFirstLetter([thiscs.string characterAtIndex:0])) {
                [dic setObject:arr forKey:[sTA lastObject]];
                [sTA addObject:[[NSString stringWithFormat:@"%c",pinyinFirstLetter([thiscs.string characterAtIndex:0])]uppercaseString]];
                arr = [NSMutableArray array];
            }
            if ([thiscs isEqual:[nameArrSorted lastObject]]) {
                [dic setObject:arr forKey:[sTA lastObject]];
            }
        }
        [arr addObject:thiscs.string];
    }
    //得到以拼音key字典
    NSMutableDictionary *nameDicWithKeyOfPinyin = [NSMutableDictionary dictionary];
    for (ChineseString *cs in nameArrSorted) {
        [nameDicWithKeyOfPinyin setObject:cs.string forKey:cs.pinYin];
    }
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dicPath = [docPath stringByAppendingPathComponent:@"nameDicWithKeyOfPinyin.plist"];
    [nameDicWithKeyOfPinyin writeToFile:dicPath atomically:YES];
    //计算所有数据总量
    _dataCount = 0;
    for (NSString *s in [dic allKeys]) {
        NSArray *sa = [dic objectForKey:s];
        _dataCount += sa.count;
    }
    _sectionTitleArr = [sTA copy];
    return dic;
}

@end
