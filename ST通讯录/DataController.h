//
//  DataController.h
//  ST通讯录
//
//  Created by chen_ryao on 16/3/27.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/Coredata.h>

@interface DataController : NSObject
/**
 *  数据库上下文
 */
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) NSArray *sectionTitleArr;
@property (nonatomic,assign) int dataCount;

/**
 *  从云端拉取数据,并保存到数据库（初次）
 */
- (void)fetchDataFromCloud;
/**
 *  获取排序后的所有姓名
 */
- (NSDictionary *)catchSortedNameArray;


@end
