//
//  CusTableViewCell.h
//  Demos
//
//  Created by 姜波 on 2020/12/17.
//  Copyright © 2020 姜波. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CusTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;
- (void)setInfo:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
