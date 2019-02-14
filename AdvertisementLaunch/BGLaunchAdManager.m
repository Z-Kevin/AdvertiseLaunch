//
//  BGLaunchAdManager.m
//  JinRongArticle
//
//  Created by ZXY on 2019/1/25.
//  Copyright © 2019年 91JinRong. All rights reserved.
//

#import "BGLaunchAdManager.h"
#import "XYLanchAd.h"

@interface  BGLaunchAdManager ()<XYLaunchAdDelegate>

@end


@implementation BGLaunchAdManager
+ (void)load {
    [self shareManager];
}
+ (BGLaunchAdManager *)shareManager {
    static BGLaunchAdManager *instatnce = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instatnce = [[BGLaunchAdManager alloc] init];
    });
    return instatnce;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self setupBGLaunchAd];
        }];
    }
    return self;
}
- (void)setupBGLaunchAd {
   [XYLanchAd setLaunchSourceType:SourceTypeLaunchImage];
    [XYLanchAd setWaitDataDuration:2];
//    [HYBNetworking getWithUrl:AdvertiseURL refreshCache:YES success:^(id response) {
//        JBBaseDataModel *baseModel = [JBBaseDataModel parseDataWithRequest:response];
//        if (baseModel.retCode == 200) {
//            XYImageAdConfiguration *imageConfigure = [XYImageAdConfiguration new];
//            imageConfigure.duration = 3;
//            imageConfigure.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//            imageConfigure.imageNameOrURLString = [ValueUtils stringValue:baseModel.body forKey:@"imageUrl"];
//            imageConfigure.showFinishAnimate =ShowFinishAnimateLite;
//            imageConfigure.openModel = response;
//            imageConfigure.showFinishAnimateTime = 0.8;
//            //显示开屏广告
//            [XYLanchAd imageAdWithImageAdConfiguration:imageConfigure delegate:self];
//        }else{
//
//        }
//
//
//    } fail:^(NSError *error) {
//
//    }];
}
- (void)XYLaunchAd:(XYLanchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint {

}

@end
