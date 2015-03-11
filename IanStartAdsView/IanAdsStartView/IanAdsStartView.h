//
//  IanAdsStartView.h
//  IanStartAdsView
//
//  Created by ian on 15/3/11.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IanAdsStartView : UIView
+ (instancetype)startAdsViewWithBgImageUrl:(NSString *)imageUrl;
- (void)startAnimationTime:(double)time WithCompletionBlock:(void(^)(IanAdsStartView *ianStartView))completionHandler;// 单位秒（s）
@end
