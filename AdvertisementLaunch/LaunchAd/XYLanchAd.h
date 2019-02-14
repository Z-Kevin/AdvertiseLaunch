//
//  XYLanchAd.h
//  JinRongArticle
//
//  Created by ZXY on 2019/1/28.
//  Copyright © 2019年 91JinRong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XYLaunchImageView.h"
#import "XYAdConfiguration.h"
#import "XYLaunchAdView.h"

@class XYLanchAd;
@protocol XYLaunchAdDelegate <NSObject>
@optional
/**
 广告点击
 
 @param launchAd launchAd
 @param openModel 打开页面参数(此参数即你配置广告数据设置的configuration.openModel)
 @param clickPoint 点击位置
 */
- (void)XYLaunchAd:(XYLanchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint;

/**
 广告显示完成
 
 @param launchAd XHLaunchAd
 */
-(void)XYLaunchAdShowFinish:(XYLanchAd *)launchAd;
/**
 *  倒计时回调
 *
 *  @param launchAd XHLaunchAd
 *  @param duration 倒计时时间
 */
-(void)XYLaunchAd:(XYLanchAd *)launchAd customSkipView:(UIView *)customSkipView duration:(NSInteger)duration;
@end

@interface XYLanchAd : NSObject

@property(nonatomic,assign) id<XYLaunchAdDelegate> delegate;
@property (strong, nonatomic) XYImageAdConfiguration *imageAdConfiguration;
/**
 设置你工程的启动页使用的是LaunchImage还是LaunchScreen(default:SourceTypeLaunchImage)
 注意:请在设置等待数据及配置广告数据前调用此方法
 @param sourceType sourceType
 */
+(void)setLaunchSourceType:(SourceType)sourceType;
/**
 *  设置等待数据源时间(建议值:3)
 *
 *  @param waitDataDuration waitDataDuration
 */
+(void)setWaitDataDuration:(NSInteger )waitDataDuration;

+(XYLanchAd *)imageAdWithImageAdConfiguration:(XYImageAdConfiguration *)imageAdconfiguration delegate:(id)delegate;
@end


