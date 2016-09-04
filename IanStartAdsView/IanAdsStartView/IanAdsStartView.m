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
#import "GetLaunchImage.h"

@interface IanAdsStartView()

@property (nonatomic, strong) UIImageView *bgImageViewDefault;
@property (nonatomic, strong) IanClickImageView *bgImageView;
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic) BOOL isImageDownloaded;
@property (nonatomic, copy) void(^imageClickAction)();
@property (nonatomic, copy) void(^adsViewCompletion)(IanAdsStartView *ianStartView);
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSUInteger timeNum;

@end

@implementation IanAdsStartView


#pragma mark - private method

- (instancetype)initWithBgImage:(NSString *)imageUrl withClickImageAction:(void(^)())action
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {

        _isImageDownloaded = NO;
        _imageClickAction = action;
        
        _bgImageViewDefault = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgImageViewDefault.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_bgImageViewDefault];
        _bgImageViewDefault.image = [GetLaunchImage getTheLaunchImage];
        
        _bgImageView = [[IanClickImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgImageView.alpha = 0.0;
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
        [_bgImageView addTarget:self action:@selector(_ImageClick:)];
        [self addSubview:_bgImageView];
        
        _timeButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 13 - 52, 20, 52, 25)];
        _timeButton.layer.cornerRadius = 25/2.0f;
        [_timeButton setClipsToBounds:YES];
        _timeButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _timeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_timeButton addTarget:self action:@selector(jumpClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgImageView addSubview:_timeButton];

        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        BOOL cachedBool = [manager cachedImageExistsForURL:[NSURL URLWithString:imageUrl]]; // 将需要缓存的图片加载进来
        BOOL diskBool = [manager diskImageExistsForURL:[NSURL URLWithString:imageUrl]];
        if (cachedBool || diskBool) {
            _timeButton.hidden = NO;
            [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[GetLaunchImage getTheLaunchImage]];
            _isImageDownloaded = YES;
        } else {
            _timeButton.hidden = YES;
            self.bgImageView.image = [GetLaunchImage getTheLaunchImage];
            [manager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
            }];
            _isImageDownloaded = NO;
        }
        
        
    }
    return self;
}

- (void)removeMyAdsView
{
    if (_timer.isValid) {
        [_timer invalidate];
    }
    _timer = nil;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.bgImageView.alpha = 0.0;
        [strongSelf.bgImageView setFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width/20, -[UIScreen mainScreen].bounds.size.height/20, 1.1*[UIScreen mainScreen].bounds.size.width, 1.1*[UIScreen mainScreen].bounds.size.height)];
        strongSelf.alpha = 0.0;
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf removeFromSuperview];
        if (_adsViewCompletion) {
            _adsViewCompletion(strongSelf);
        }
    }];
}


#pragma mark - interface method

+ (instancetype)startAdsViewWithBgImageUrl:(NSString *)imageUrl withClickImageAction:(void(^)())action
{
    return [[self alloc] initWithBgImage:imageUrl withClickImageAction:action];
}


- (void)startAnimationTime:(NSUInteger)time WithCompletionBlock:(void(^)(IanAdsStartView *ianStartView))completionHandler
{
    _timeNum = time;
    _adsViewCompletion = completionHandler;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    [UIView animateWithDuration:0.5 animations:^{
        _bgImageView.alpha = 1;
    }];
    
    [_timeButton setTitle:[NSString stringWithFormat:@"跳过%zd",_timeNum] forState:UIControlStateNormal];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
}

+ (void)downloadStartImage:(NSString *)imageUrl
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    BOOL cachedBool = [manager cachedImageExistsForURL:[NSURL URLWithString:imageUrl]];
    BOOL diskBool = [manager diskImageExistsForURL:[NSURL URLWithString:imageUrl]];
    if (cachedBool || diskBool) {
    } else {
        
        [manager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
        }];
        
    }
    
}

#pragma mark - action method

- (void)_ImageClick:(UIImageView *)sender
{
    if (self.imageClickAction && _isImageDownloaded) {
        self.imageClickAction();
        [self removeMyAdsView];
    }
}

- (void)jumpClick:(id)sender
{
    [self removeMyAdsView];
}

- (void)timerAction:(NSTimer *)timer
{
    if (_timeNum == 0) {
        [self removeMyAdsView];
        return;
    }
    _timeNum --;
    if (_isImageDownloaded) {
        [_timeButton setTitle:[NSString stringWithFormat:@"跳过%zd",_timeNum] forState:UIControlStateNormal];
    }
}


@end

