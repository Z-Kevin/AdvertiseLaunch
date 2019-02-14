//
//  XYAdConfiguration.h
//  JinRongArticle
//
//  Created by ZXY on 2019/1/28.
//  Copyright © 2019年 91JinRong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XYAdButton.h"
/** 显示完成动画时间默认时间 */
static CGFloat const showFinishAnimateTimeDefault = 0.8;
/** 显示完成动画类型 */
typedef NS_ENUM(NSInteger , ShowFinishAnimate) {
    /** 无动画 */
    ShowFinishAnimateNone = 1,
    /** 普通淡入(default) */
    ShowFinishAnimateFadein = 2,
    /** 放大淡入 */
    ShowFinishAnimateLite = 3,
    /** 左右翻转(类似网易云音乐) */
    ShowFinishAnimateFlipFromLeft = 4,
    /** 下上翻转 */
    ShowFinishAnimateFlipFromBottom = 5,
    /** 向上翻页 */
    ShowFinishAnimateCurlUp = 6,
};


@interface XYAdConfiguration : NSObject
/**
 *  停留时间(default 5 ,单位:秒)
 */
@property(nonatomic,assign)NSInteger duration;
/**
 *  跳过按钮类型(default SkipTypeTimeText)
 */
@property(nonatomic,assign)SkipType skipButtonType;
/**
 *  显示完成动画(default ShowFinishAnimateFadein)
 */
@property(nonatomic,assign)ShowFinishAnimate showFinishAnimate;
/**
 *  显示完成动画时间(default 0.8 , 单位:秒)
 */
@property(nonatomic,assign)CGFloat showFinishAnimateTime;
/**
 *  设置开屏广告的frame(default [UIScreen mainScreen].bounds)
 */
@property (nonatomic,assign) CGRect frame;
/**
 *  点击打开页面参数
 */
@property (nonatomic, strong) id openModel;
@end
#pragma mark - 图片广告相关
@interface XYImageAdConfiguration : XYAdConfiguration
/**
 *  图片广告缩放模式(default UIViewContentModeScaleToFill)
 */
@property (nonatomic, assign) UIViewContentMode contentMode;

/**
 *  image本地图片名(jpg/gif图片请带上扩展名)或网络图片URL string
 */
@property (nonatomic, copy) NSString *imageNameOrURLString;
+ (XYImageAdConfiguration *)defaultConfiguration;
@end

