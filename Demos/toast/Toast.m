//
//  Toast.m
//  CameraDemo
//
//  Created by 姜波 on 2020/9/12.
//  Copyright © 2020 HaoHuoBan. All rights reserved.
//

#import "Toast.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define VIEW_WIDTH 80.0    // toast背景view宽度
#define FONT_SIZE 16.0
#define MARGIN 25 //toast背景view的margin
#define INDICATOR_HEIGHT 30
#define DEFAULTSHOWTIME 3 //默认toast 秒
#define DEFAULTLOADINGTIME 5 //默认loading 秒

static UIView *loadingView;
static UILabel *msgLabel;
static UIActivityIndicatorView *indicatorView;
static NSString *message;

@implementation Toast

+ (void)show:(NSString *)msg time:(int)time {
  
  if (!msg || msg.length == 0) {
    return;
  }
  [self hide];
  message = msg;
  
  loadingView = [self makeToastView];
  loadingView.hidden = NO;
  
  msgLabel = [self makeMsgLabel];
  CGSize size = [self calculatMessageSize];
  CGFloat viewW = size.width + MARGIN * 2;
  CGFloat viewH = size.height + MARGIN * 2;
  
  loadingView.frame = CGRectMake(SCREEN_WIDTH/2 - viewW/2, SCREEN_HEIGHT/2 - viewH/2, viewW, viewH);
  
  msgLabel.bounds = CGRectMake(0, 0, size.width, size.height);
  msgLabel.center = CGPointMake(viewW/2, viewH/2);
  msgLabel.text = message;

  [self handleShowTime:time isLoading:NO];
}

+ (void)handleShowTime:(int)time isLoading:(BOOL)isLoading {
  int defaultTime = isLoading ? DEFAULTLOADINGTIME : DEFAULTSHOWTIME;
  int showTime = time >= 1 ? time : defaultTime;
  showTime = showTime <= 30 ? showTime : defaultTime;
  [self handleShowTime:showTime];
}

+ (void)handleShowTime:(int)time {
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self hide];
  });
}

+ (void)loadng:(NSString *)msg time:(int)time {
  [self hide];
  message = msg;
  loadingView = [self makeToastView];
  loadingView.hidden = NO;
  
  indicatorView = [self makeIndicatorView];
  [indicatorView startAnimating];
  
  if (msg && msg.length > 0) {
    msgLabel = [self makeMsgLabel];
    [self handleMsgLabel];
  } else {
    loadingView.frame = CGRectMake(SCREEN_WIDTH/2 - VIEW_WIDTH/2, SCREEN_HEIGHT/2 - VIEW_WIDTH/2, VIEW_WIDTH, VIEW_WIDTH);
    indicatorView.center = CGPointMake(VIEW_WIDTH/2, VIEW_WIDTH/2);
  }
  
  [self handleShowTime:time isLoading:YES];
  
}

+ (void)hide {
  if (loadingView && !loadingView.hidden) {
    loadingView.hidden = YES;
  }
  if (indicatorView) {
    [indicatorView stopAnimating];
  }
  if (msgLabel) {
    msgLabel.text = @"";
  }
  message = @"";
}

+ (void)handleMsgLabel {
  CGSize toastSize = [self calculatLoadingViewSize];
  CGSize textSize = [self calculatMessageSize];
  loadingView.frame = CGRectMake(SCREEN_WIDTH/2 - toastSize.width/2, SCREEN_HEIGHT/2 - toastSize.height/2, toastSize.width, toastSize.height);
  indicatorView.center = CGPointMake(toastSize.width/2, MARGIN + INDICATOR_HEIGHT/2);
  msgLabel.frame = CGRectMake(MARGIN, CGRectGetMaxY(indicatorView.frame)+MARGIN/2, textSize.width+5, textSize.height+5);
  msgLabel.text = message;
  if (!msgLabel.superview) {
    [loadingView addSubview:msgLabel];
  }
}

+ (UIWindow *)currentWindow {
  UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
  
  if (!window) {
    NSLog(@"出现了不能预料的错误：window = nil");
    return window;
  }
  
  return window;
}

+ (UIView *)makeToastView {
  if (loadingView) {
    if (!loadingView.superview) {
      [[self currentWindow] addSubview:loadingView];
    }
    return loadingView;
  }
  UIView *view = [[UIView alloc] init];
  view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:150.0/255.0];
  view.layer.masksToBounds = YES;
  view.layer.cornerRadius = 8.0;
  [[self currentWindow] addSubview:view];
  return view;
}

+(UIActivityIndicatorView *)makeIndicatorView {
  if (indicatorView) {
    if (!indicatorView.superview) {
      [loadingView addSubview:indicatorView];
    }
    return indicatorView;
  }
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
  [indicator startAnimating];
  if (!loadingView) {
    NSLog(@"出错了：loadingView === null");
    return indicator;
  }
  [loadingView addSubview:indicator];
  return indicator;
}

+ (UILabel *)makeMsgLabel {
  if (msgLabel) {
    if (!msgLabel.superview) {
      [loadingView addSubview:msgLabel];
    }
    return msgLabel;
  }
  UILabel *label = [[UILabel alloc] init];
  label.numberOfLines = 0;
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont systemFontOfSize:FONT_SIZE weight:UIFontWeightBold];
  label.textColor = [UIColor whiteColor];
  if (!loadingView) {
    NSLog(@"出错了：loadingView === null");
    return label;
  }
  [loadingView addSubview:label];
  return label;
}

+ (CGSize)calculatMessageSize {
  if (!message || message.length == 0) {
    return CGSizeZero;
  }
  CGFloat maxHeight = SCREEN_WIDTH * 0.8;
  CGFloat maxWidth = SCREEN_WIDTH * 0.8;
  UIFont *font = [UIFont systemFontOfSize:FONT_SIZE weight:UIFontWeightBold];
  NSMutableDictionary *attr = [NSMutableDictionary dictionary];
  attr[NSFontAttributeName] = font;
  CGRect size = [message boundingRectWithSize:CGSizeMake(maxWidth, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
  return size.size;
}

+ (CGSize)calculatLoadingViewSize {
  CGSize size = [self calculatMessageSize];
  CGFloat tempW = size.width + MARGIN*2;
  CGFloat w = MAX(VIEW_WIDTH, tempW);
  CGFloat indicatorHeight = INDICATOR_HEIGHT;
  CGFloat tempH = size.height + indicatorHeight + MARGIN*2 + MARGIN/2;
  CGFloat h = MAX(VIEW_WIDTH, tempH);
  return CGSizeMake(w, h);
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
