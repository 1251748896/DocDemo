//
//  ExcelCell.h
//  Demos
//
//  Created by 姜波 on 2020/6/15.
//  Copyright © 2020 姜波. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExcelCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property (nonatomic) UILabel *danwei;
@property (nonatomic) UILabel *gangwei;
@property (nonatomic) UILabel *bianma;
@property (nonatomic) UILabel *renshu;

@property (nonatomic) UILabel *label;

@end

NS_ASSUME_NONNULL_END
