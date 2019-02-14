//
//  XYLaunchImageView.h
//  JinRongArticle
//
//  Created by ZXY on 2019/1/28.
//  Copyright © 2019年 91JinRong. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 启动图来源 */
typedef NS_ENUM(NSInteger,SourceType) {
    SourceTypeLaunchImage = 1,//LaunchImage(default)
    SourceTypeLaunchScreen = 2,//LaunchScreen.storyboard
};

@interface XYLaunchImageView : UIImageView
- (instancetype)initWithSourceType:(SourceType)sourceType;
@end


