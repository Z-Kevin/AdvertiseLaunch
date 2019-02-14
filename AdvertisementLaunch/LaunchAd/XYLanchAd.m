//
//  XYLanchAd.m
//  JinRongArticle
//
//  Created by ZXY on 2019/1/28.
//  Copyright © 2019年 91JinRong. All rights reserved.
//

#import "XYLanchAd.h"
#import "XYLaunchImageView.h"
#import "XYAdButton.h"
#import "XYAdConst.h"

static NSInteger defaultWaitDataDuration = 3;
static  SourceType _sourceType = SourceTypeLaunchImage;
@interface XYLanchAd ()
@property(nonatomic, assign) NSInteger waitDataDuration;
@property(nonatomic, strong) UIWindow *window;
@property(nonatomic, strong) XYAdButton *skipButton;
@property(nonatomic, copy) dispatch_source_t waitDataTimer;
@property(nonatomic, copy) dispatch_source_t skipTimer;
@property(nonatomic, assign) CGPoint clickPoint;
@end


@implementation XYLanchAd
+(void)setLaunchSourceType:(SourceType)sourceType{
    _sourceType = sourceType;
}
+ (void)setWaitDataDuration:(NSInteger )waitDataDuration{
    XYLanchAd *launchAd = [XYLanchAd shareLaunchAd];
    launchAd.waitDataDuration = waitDataDuration;
}
+(XYLanchAd *)imageAdWithImageAdConfiguration:(XYImageAdConfiguration *)imageAdconfiguration delegate:(id)delegate{
    XYLanchAd *launchAd = [XYLanchAd shareLaunchAd];
    if(delegate) {
       launchAd.delegate = delegate;
    }
    
    launchAd.imageAdConfiguration = imageAdconfiguration;
    
    return launchAd;
}
+ (XYLanchAd *)shareLaunchAd {
    static XYLanchAd *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[XYLanchAd alloc] init];
    });
    return instance;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupLaunchAd];
    }
    return self;
}
- (void)setupLaunchAd {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;
    window.windowLevel = UIWindowLevelStatusBar + 1;
    window.hidden = NO;
    window.alpha = 1;
    _window = window;
    /** 添加launchImageView */
    [_window addSubview:[[XYLaunchImageView alloc] initWithSourceType:_sourceType]];
}
#pragma mark - set
-(void)setWaitDataDuration:(NSInteger)waitDataDuration{
    _waitDataDuration = waitDataDuration;
    /** 数据等待 */
    [self startWaitDataDispathTiemr];
}
- (void)setImageAdConfiguration:(XYImageAdConfiguration *)imageAdConfiguration{
    _imageAdConfiguration = imageAdConfiguration;
    [self setupImageAdForConfiguration:imageAdConfiguration];
}
/**图片*/
-(void)setupImageAdForConfiguration:(XYImageAdConfiguration *)configuration{
    if(_window == nil) return;
    [self removeSubViewsExceptLaunchAdImageView];
    XYLaunchAdImageView  *adImageView = [[XYLaunchAdImageView alloc] init];
    [_window addSubview:adImageView];
//    /** frame */
    if(configuration.frame.size.width>0 && configuration.frame.size.height>0) adImageView.frame = configuration.frame;
    if(configuration.contentMode) adImageView.contentMode = configuration.contentMode;
//    [adImageView sd_setImageWithURL:[NSURL URLWithString:configuration.imageNameOrURLString] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        adImageView.image = image;
//    }];
    /** skipButton */
    [self addSkipButtonForConfiguration:configuration];
    [self startSkipDispathTimer];
    /** customView */
//    if(configuration.subViews.count>0)  [self addSubViews:configuration.subViews];
    WEAKSELF
    adImageView.click = ^(CGPoint point) {
        [weakSelf clickAndPoint:point];
    };
}
-(void)clickAndPoint:(CGPoint)point{
    self.clickPoint = point;
    XYAdConfiguration *configuration = _imageAdConfiguration;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored"-Wdeprecated-declarations"
//    if ([self.delegate respondsToSelector:@selector(xhLaunchAd:clickAndOpenURLString:)] && configuration.openURLString.length) {
//        [self.delegate xhLaunchAd:self clickAndOpenURLString:configuration.openURLString];
//        [self removeAndAnimateDefault];
//    }
//    if ([self.delegate respondsToSelector:@selector(xhLaunchAd:clickAndOpenURLString:clickPoint:)] && configuration.openURLString.length) {
//        [self.delegate xhLaunchAd:self clickAndOpenURLString:configuration.openURLString clickPoint:point];
//        [self removeAndAnimateDefault];
//    }
//#pragma clang diagnostic pop
    if ([self.delegate respondsToSelector:@selector(XYLaunchAd:clickAndOpenModel:clickPoint:)] && configuration.openModel) {
        [self.delegate XYLaunchAd:self clickAndOpenModel:configuration.openModel clickPoint:point];
        [self removeAndAnimateDefault];
    }
}

-(void)addSkipButtonForConfiguration:(XYAdConfiguration *)configuration{
    if(!configuration.duration) configuration.duration = 5;
    if(!configuration.skipButtonType) configuration.skipButtonType = SkipTypeTimeText;
    
    if(_skipButton == nil){
        _skipButton = [[XYAdButton alloc] initWithSkipType:configuration.skipButtonType];
        _skipButton.hidden = YES;
        [_skipButton addTarget:self action:@selector(skipButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    [_window addSubview:_skipButton];
    [_skipButton setTitleWithSkipType:configuration.skipButtonType duration:configuration.duration];
}
-(void)startWaitDataDispathTiemr{
    __block NSInteger duration = defaultWaitDataDuration;
    if(_waitDataDuration){
       duration = _waitDataDuration;
    }
    WEAKSELF
    _waitDataTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    NSTimeInterval period = 1.0;
    dispatch_source_set_timer(_waitDataTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_waitDataTimer, ^{
        if(duration == 0){
            DISPATCH_SOURCE_CANCEL_SAFE(weakSelf.waitDataTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"倒计时完成通知" object:nil];
                [self remove];
                return ;
            });
        }
        duration--;
    });
    dispatch_resume(_waitDataTimer);
}

-(void)startSkipDispathTimer{
    XYAdConfiguration *configuration = _imageAdConfiguration;
    DISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer);
    if(!configuration.skipButtonType){
        configuration.skipButtonType = SkipTypeTimeText;//默认
    }
    __block NSInteger duration = 5;//默认
    if(configuration.duration) duration = configuration.duration;
    if(configuration.skipButtonType == SkipTypeRoundProgressTime || configuration.skipButtonType == SkipTypeRoundProgressText){
        [_skipButton startRoundDispathTimerWithDuration:duration];
    }
    NSTimeInterval period = 1.0;
    WEAKSELF
    _skipTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_skipTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_skipTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.skipButton setTitleWithSkipType:configuration.skipButtonType duration:duration];
            if(duration == 0 ){
                DISPATCH_SOURCE_CANCEL_SAFE(weakSelf.skipTimer);
                [weakSelf removeAndAnimate];
                return ;
            }
            duration--;
        });
    });
    dispatch_resume(_skipTimer);
}

#pragma mark - Action
-(void)skipButtonClick{
    [self removeAndAnimated:YES];
}

-(void)removeAndAnimated:(BOOL)animated{
    if(animated){
        [self removeAndAnimate];
    }else{
        [self remove];
    }
}

- (void)removeAndAnimate {
    
    XYAdConfiguration *configuration = _imageAdConfiguration;
    CGFloat duration = showFinishAnimateTimeDefault;
    if(configuration.showFinishAnimateTime > 0) duration = configuration.showFinishAnimateTime;
    WEAKSELF
    switch ( configuration.showFinishAnimate ) {
        case ShowFinishAnimateNone:{
            [self remove];
        }
            break;
        case ShowFinishAnimateFadein:{
            [self removeAndAnimateDefault];
        }
            break;
        case ShowFinishAnimateLite:{
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.window.transform = CGAffineTransformMakeScale(1.5, 1.5);
                weakSelf.window.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        case ShowFinishAnimateFlipFromLeft:{
            
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                weakSelf.window.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        case ShowFinishAnimateFlipFromBottom:{
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                weakSelf.window.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        case ShowFinishAnimateCurlUp:{
            
            [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionCurlUp animations:^{
                weakSelf.window.alpha = 0;
            } completion:^(BOOL finished) {
                [self remove];
            }];
        }
            break;
        default:{
            [self removeAndAnimateDefault];
        }
            break;
    }
}
-(void)removeAndAnimateDefault{
    XYAdConfiguration *configuration = _imageAdConfiguration;
    CGFloat duration = showFinishAnimateTimeDefault;
    if( configuration.showFinishAnimateTime > 0)
        duration = configuration.showFinishAnimateTime;
    WEAKSELF
    [UIView transitionWithView:_window duration:duration options:UIViewAnimationOptionTransitionNone animations:^{
        weakSelf.window.alpha = 0;
    } completion:^(BOOL finished) {
        [self remove];
    }];
}

-(void)removeSubViewsExceptLaunchAdImageView{
    [_window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![obj isKindOfClass:[XYLaunchImageView class]]){
            REMOVE_FROM_SUPERVIEW_SAFE(obj)
        }
    }];
}
-(void)remove{
    DISPATCH_SOURCE_CANCEL_SAFE(_waitDataTimer)
    DISPATCH_SOURCE_CANCEL_SAFE(_skipTimer)
    REMOVE_FROM_SUPERVIEW_SAFE(_skipButton)
    [_window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        REMOVE_FROM_SUPERVIEW_SAFE(obj)
    }];
    _window.hidden = YES;
    _window = nil;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored"-Wdeprecated-declarations"
//    if ([self.delegate respondsToSelector:@selector(xhLaunchShowFinish:)]) {
//        [self.delegate xhLaunchShowFinish:self];
//    }
//#pragma clang diagnostic pop
    if ([self.delegate respondsToSelector:@selector(XYLaunchAdShowFinish:)]) {
        [self.delegate XYLaunchAdShowFinish:self];
    }
}

@end
