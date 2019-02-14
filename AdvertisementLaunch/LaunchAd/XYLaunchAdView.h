//
//  XYLaunchAdVideoView.h
//  JinRongArticle
//
//  Created by ZXY on 2019/1/29.
//  Copyright © 2019年 91JinRong. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<FLAnimatedImage/FLAnimatedImage.h>)
#import <FLAnimatedImage/FLAnimatedImage.h>
#else
#import "FLAnimatedImage.h"
#endif

#if __has_include(<FLAnimatedImage/FLAnimatedImageView.h>)
#import <FLAnimatedImage/FLAnimatedImageView.h>
#else
#import "FLAnimatedImageView.h"
#endif
@interface XYLaunchAdView : UIView

@end
//
@interface XYLaunchAdImageView : FLAnimatedImageView

@property (nonatomic, copy) void(^click)(CGPoint point);

@end

