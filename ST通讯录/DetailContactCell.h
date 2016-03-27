//
//  DetailContactCell.h
//  ST通讯录
//
//  Created by chen_ryao on 16/1/12.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailContactCell : UITableViewCell
typedef enum{
    ContactStyleTel = 0,
    ContactStyleQQ
}ContactStyle;

- (void)setCellContentWithNumber:(NSNumber *)tel andStyle:(ContactStyle)contactStyle;
@end
