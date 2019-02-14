//
//  XYAdConst.h
//  JinRongArticle
//
//  Created by ZXY on 2019/1/28.
//  Copyright © 2019年 91JinRong. All rights reserved.
//

#ifndef XYAdConst_h
#define XYAdConst_h
//NSString *const XHLaunchAdWaitDataDurationArriveNotification = @"XHLaunchAdWaitDataDurationArriveNotification";
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define XYWeakSelf __weak typeof(self) weakSelf = self;

#define XY_ScreenW    [UIScreen mainScreen].bounds.size.width
#define XY_ScreenH    [UIScreen mainScreen].bounds.size.height

#define DISPATCH_SOURCE_CANCEL_SAFE(time) if(time)\
{\
dispatch_source_cancel(time);\
time = nil;\
}


#define REMOVE_FROM_SUPERVIEW_SAFE(view) if(view)\
{\
[view removeFromSuperview];\
view = nil;\
}

#endif /* XYAdConst_h */
