//
//  IanAdsStartView.m
//  IanStartAdsView
//
//  Created by ian on 15/3/11.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "IanAdsStartView.h"
#import "UIImageView+WebCache.h"
@interface IanAdsStartView()
@property (strong, nonatomic) UIImageView *bgImageView;
@end
@implementation IanAdsStartView

+ (instancetype)startAdsViewWithBgImageUrl:(NSString *)imageUrl
{
    return [[self alloc] initWithBgImage:imageUrl];
}

- (instancetype)initWithBgImage:(NSString *)imageUrl
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _bgImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgImageView.alpha = 0.0;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_bgImageView];
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"LaunchImage-700-568h"]];
    }
    return self;
}

- (void)startAnimationTime:(double)time WithCompletionBlock:(void(^)(IanAdsStartView *ianStartView))completionHandler
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    _bgImageView.alpha = 1.0;
    self.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    
    UILabel *tempLabel = [UILabel new];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.alpha = 1.0f;
    [self addSubview:tempLabel]; // 辅助延迟
    
    [UIView animateWithDuration:0 delay:time options:UIViewAnimationOptionAllowUserInteraction animations:^{
        tempLabel.alpha = 0;
    } completion:^(BOOL finished){
        self.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.bgImageView.alpha = 0.0;
            [strongSelf.bgImageView setFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width/20, -[UIScreen mainScreen].bounds.size.height/20, 1.1*[UIScreen mainScreen].bounds.size.width, 1.1*[UIScreen mainScreen].bounds.size.height)];
            strongSelf.alpha = 0.0;
        } completion:^(BOOL finished) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf removeFromSuperview];
            if (completionHandler) {
                completionHandler(strongSelf);
            }
        }];
    }];
    
    
}
@end

