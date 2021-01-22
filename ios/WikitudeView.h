#import <UIKit/UIKit.h>
#import <WikitudeSDK.h>
#import <React/RCTComponent.h>
#import <WTArchitectView.h>
#import <WTStartupConfiguration.h>
#import <React/RCTBridgeModule.h>

@class WikitudeView;

@interface WikitudeView : UIView

    @property (nonatomic, assign) CGRect frame;
    @property (nonatomic, assign) NSString *url;
    @property (nonatomic, assign) NSString *tmp_url;
    @property (nonatomic, assign) NSURL *architectWorldUrl;
    @property (nonatomic, assign) NSString *licenseKey;
    @property NSString* key;
    @property (nonatomic, assign) NSInteger *feature;
    @property BOOL hasCameraPermission;
    @property (nonatomic, strong) WTArchitectView  *architectView;
    @property (nonatomic, assign) WTNavigation* wtNavigation;

    //Events
    @property (nonatomic, copy) RCTBubblingEventBlock onJsonReceived;
    @property (nonatomic, copy) RCTBubblingEventBlock onFinishLoading;
    @property (nonatomic, copy) RCTBubblingEventBlock onFailLoading;
    @property (nonatomic, copy) RCTBubblingEventBlock onScreenCaptured;

    -(instancetype)initWithBridge:(RCTBridge *)bridge;
    -(void)startWikitudeSDKRendering;
    -(void)setUrl:(NSString *)url;
    -(void)loadArchitect:(NSString *)url;
    -(void)injectLocationWithLatitude:(double)latitude longitude:(double)longitude;
    -(void)callJavaScript:(NSString *)js;
    -(void)stopWikitudeSDKRendering;
    -(void)captureScreen:(BOOL *)mode;
    -(BOOL)isDeviceSupportingFeatures:(WTFeatures)requiredFeatures;
    -(BOOL)isRunning;
    -(void)clearCache; 
@end
