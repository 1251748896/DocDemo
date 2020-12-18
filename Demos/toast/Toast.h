//
//  Toast.h
//  CameraDemo
//
//  Created by 姜波 on 2020/9/12.
//  Copyright © 2020 HaoHuoBan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Toast : NSObject
+ (void)show:(NSString *)msg time:(int)time;
+(void)loadng:(NSString *)msg  time:(int)time;
+(void)hide;
@end

NS_ASSUME_NONNULL_END
