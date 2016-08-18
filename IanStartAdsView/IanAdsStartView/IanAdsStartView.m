//
//  IanAdsStartView.m
//  IanStartAdsView
//
//  Created by ian on 15/3/11.
//  Copyright (c) 2015年 ian. All rights reserved.
//

#import "IanAdsStartView.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface IanAdsStartView()

@property (strong, nonatomic) IanClickImageView *bgImageView;

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
        _bgImageView = [[IanClickImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgImageView.alpha = 0.0;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_bgImageView addTarget:self action:@selector(_ImageClick:)];
        [self addSubview:_bgImageView];

        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        BOOL cachedBool = [manager cachedImageExistsForURL:[NSURL URLWithString:imageUrl]]; // 将需要缓存的图片加载进来
        BOOL diskBool = [manager diskImageExistsForURL:[NSURL URLWithString:imageUrl]];
        if (cachedBool || diskBool) {
            [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"LaunchImage-700-568h"]];
        } else {

            self.bgImageView.image = [UIImage imageNamed:@"LaunchImage-700-568h"];
           [manager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
               
           } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
               
           }];
        }
        
        
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
    
    
    if (time == 0) {
        [self removeFromSuperview];
    }else{
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
    
}

- (void)_ImageClick:(UIImageView *)sender
{
    if (self.adsStartViewAction) {
        self.adsStartViewAction();
    }
}
@end

