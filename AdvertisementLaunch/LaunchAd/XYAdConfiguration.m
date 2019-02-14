//
//  XYAdConfiguration.m
//  JinRongArticle
//
//  Created by ZXY on 2019/1/28.
//  Copyright © 2019年 91JinRong. All rights reserved.
//

#import "XYAdConfiguration.h"
#import "XYAdButton.h"
@implementation XYAdConfiguration

@end
#pragma mark - 图片广告相关
@implementation XYImageAdConfiguration
+ (XYImageAdConfiguration *)defaultConfiguration {
    //配置广告数据
    XYImageAdConfiguration *configuration = [XYImageAdConfiguration new];
    //广告停留时间
    configuration.duration = 5;
    //广告frame
    configuration.frame = [UIScreen mainScreen].bounds;
    
    //图片填充模式
    configuration.contentMode = UIViewContentModeScaleToFill;
    //广告显示完成动画
    configuration.showFinishAnimate =ShowFinishAnimateFadein;
    //显示完成动画时间
    configuration.showFinishAnimateTime = showFinishAnimateTimeDefault;
    //跳过按钮类型
    configuration.skipButtonType = SkipTypeTimeText;
    return configuration;
}
@end
