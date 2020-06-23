//
//  ExcelCell.m
//  Demos
//
//  Created by 姜波 on 2020/6/15.
//  Copyright © 2020 姜波. All rights reserved.
//

#import "ExcelCell.h"
#import "Masonry.h"
@implementation ExcelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self oneLabel];
    }
    return self;
}

- (void)oneLabel {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    [self.contentView addSubview:label];
    self.label = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

- (void)fourLabel {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    //        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
            
            _danwei = [[UILabel alloc] init];
            _danwei.frame = CGRectMake(10, 15, screenWidth-20, 20);
            [self.contentView addSubview:_danwei];
            
            _gangwei = [[UILabel alloc] init];
            _gangwei.frame = CGRectMake(10, CGRectGetMaxY(_danwei.frame) + 5, screenWidth-20, 20);
            [self.contentView addSubview:_gangwei];
            
            _bianma = [[UILabel alloc] init];
            _bianma.frame = CGRectMake(10, CGRectGetMaxY(_gangwei.frame) + 5, screenWidth-20, 20);
            [self.contentView addSubview:_bianma];
            
            _renshu = [[UILabel alloc] init];
            _renshu.frame = CGRectMake(10, CGRectGetMaxY(_bianma.frame) + 5, screenWidth-20, 20);
            [self.contentView addSubview:_renshu];
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
