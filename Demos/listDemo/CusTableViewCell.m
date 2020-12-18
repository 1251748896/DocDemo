//
//  CusTableViewCell.m
//  Demos
//
//  Created by 姜波 on 2020/12/17.
//  Copyright © 2020 姜波. All rights reserved.
//

#import "CusTableViewCell.h"

@implementation CusTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    UILabel *name = [[UILabel alloc] init];
    name.frame = CGRectMake(0, 0, 200, 30);
    name.text = @"上岛咖啡你完全克服你看能";
    [self.contentView addSubview:name];
    self.nameLabel = name;
    UILabel *content = [[UILabel alloc] init];
    content.frame = CGRectMake(0, 35, 200, 30);
    content.text = @"------上岛咖啡你完全克服你看能----";
    [self.contentView addSubview:content];
    self.contentLabel = content;
}

- (void)setInfo:(NSDictionary *)dict {
    self.nameLabel.text = dict[@"feedBackSpeed_Text"];
    self.contentLabel.text = dict[@"operTime"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
