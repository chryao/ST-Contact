//
//  DetailContactCell.m
//  ST通讯录
//
//  Created by chen_ryao on 16/1/12.
//  Copyright © 2016年 chen_ryao. All rights reserved.
//

#import "DetailContactCell.h"
@interface DetailContactCell()
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *styleImage;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@end
@implementation DetailContactCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellContentWithNumber:(NSNumber *)tel andStyle:(ContactStyle)contactStyle{
    self.telLabel.text = [NSString stringWithFormat:@"%@",tel];
    if (contactStyle == ContactStyleQQ) {
        self.styleImage.image = [UIImage imageNamed:@"QQ"];
        self.styleLabel.text = @"QQ";
    }else {
        self.styleImage.image = [UIImage imageNamed:@"cellphone"];
        self.styleLabel.text = @"Mobile";
    }
}
@end
