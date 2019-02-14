# AdvertiseLaunch
用法非常简单，完全与你现有逻辑不进行任何耦合，直接添加工程中即可使用
创建一个广告类BGLaunchAdManager 集成NSObject
利用load方法在应用启动时候加载改类方法，进行初始化
```
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
    [HYBNetworking getWithUrl:AdvertiseURL refreshCache:YES success:^(id response) {
        JBBaseDataModel *baseModel = [JBBaseDataModel parseDataWithRequest:response];
        if (baseModel.retCode == 200) {
            XYImageAdConfiguration *imageConfigure = [XYImageAdConfiguration new];
            imageConfigure.duration = 3;
            imageConfigure.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            imageConfigure.imageNameOrURLString = [ValueUtils stringValue:baseModel.body forKey:@"imageUrl"];
            imageConfigure.showFinishAnimate =ShowFinishAnimateLite;
            imageConfigure.openModel = response;
            imageConfigure.showFinishAnimateTime = 0.8;
            //显示开屏广告
            [XYLanchAd imageAdWithImageAdConfiguration:imageConfigure delegate:self];
        }else{
            
        }
        
        
    } fail:^(NSError *error) {
        
    }];
}
```
