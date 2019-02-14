//
//  XYLaunchAdVideoView.m
//  JinRongArticle
//
//  Created by ZXY on 2019/1/29.
//  Copyright © 2019年 91JinRong. All rights reserved.
//

#import "XYLaunchAdView.h"




@implementation XYLaunchAdView

@end

@implementation XYLaunchAdImageView

- (id)init{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.frame = [UIScreen mainScreen].bounds;
        self.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)tap:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self];
    if(self.click) self.click(point);
}

@end
