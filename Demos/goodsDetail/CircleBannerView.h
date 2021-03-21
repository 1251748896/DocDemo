//
//  CircleBannerView.h
//  xinhaosiIOT
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleBannerViewDelegate<NSObject>

- (void)mainBannerClickIndex:(NSInteger)btnIndx indx:(NSInteger)indxxx;
@end

@interface CircleBannerView : UIScrollView

@property (nonatomic) NSArray *imageArray;//接收数据
@property (nonatomic) NSArray *titleArr;//标题数组

@property (nonatomic, assign) NSTimeInterval timerInterval;
@property (nonatomic) UIColor *pageControlNormalColor;//默认为：白色
@property (nonatomic) UIColor *pageControlSelectedColor;//默认为：海蓝色
@property (nonatomic) NSTimer *timer;
@property (nonatomic, weak) id<CircleBannerViewDelegate>banneDdelegate;
- (instancetype)init;

- (void)startTimer;
- (void)pauseTimer;
- (void)stopTimer;

@end
