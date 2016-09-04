//
//  IanAdsStartView.h
//  IanStartAdsView
//
//  Created by ian on 15/3/11.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IanClickImageView.h"

@interface IanAdsStartView : UIView

+ (instancetype)startAdsViewWithBgImageUrl:(NSString *)imageUrl withClickImageAction:(void(^)())action;

- (void)startAnimationTime:(NSUInteger)time WithCompletionBlock:(void(^)(IanAdsStartView *ianStartView))completionHandler;

+ (void)downloadStartImage:(NSString *)imageUrl;

@end
