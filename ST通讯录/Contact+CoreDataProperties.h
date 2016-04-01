//
//  Contact+CoreDataProperties.h
//  ST通讯录
//
//  Created by chen_ryao on 16/4/1.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Contact.h"

NS_ASSUME_NONNULL_BEGIN

@interface Contact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *tel;
@property (nullable, nonatomic, retain) NSNumber *classNum;
@property (nullable, nonatomic, retain) NSNumber *season;
@property (nullable, nonatomic, retain) NSString *info;
@property (nullable, nonatomic, retain) NSString *objectId;

@end

NS_ASSUME_NONNULL_END
