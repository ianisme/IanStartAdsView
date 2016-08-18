//
//  IanAdsStartView.h
//  IanStartAdsView
//
//  Created by ian on 15/3/11.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IanClickImageView.h"

typedef void (^AdsStartViewAction)();

@interface IanAdsStartView : UIView

@property (nonatomic, copy) AdsStartViewAction adsStartViewAction; // 点击事件

+ (instancetype)startAdsViewWithBgImageUrl:(NSString *)imageUrl;

- (void)startAnimationTime:(double)time WithCompletionBlock:(void(^)(IanAdsStartView *ianStartView))completionHandler;// 单位秒（s）

- (void)startAnimationTime:(double)time isDisplayTime:(BOOL)isDisPlay WithCompletionBlock:(void(^)(IanAdsStartView *ianStartView))completionHandler; // 是否显示时间

@end
