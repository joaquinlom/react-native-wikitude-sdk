#import <UIKit/UIKit.h>
#import <WikitudeSDK.h>
#import <React/RCTComponent.h>
#import <WTArchitectView.h>
#import <WTStartupConfiguration.h>


@interface WikitudeView : UIView <WTArchitectViewDelegate>
    @property (nonatomic, assign) NSString *url;
    @property (nonatomic, assign) NSString *tmp_url;
    @property (nonatomic, assign) NSString *licenseKey;
    @property (nonatomic, assign) NSInteger *feature;
    @property BOOL hasCameraPermission;
    @property (nonatomic, strong) WTArchitectView  *architectView;
    @property (nonatomic, assign) WTNavigation* wtNavigation;
    //Events
    @property (nonatomic, copy) RCTBubblingEventBlock onJsonReceived;
    @property (nonatomic, copy) RCTBubblingEventBlock onFinishLoading;
    @property (nonatomic, copy) RCTBubblingEventBlock onFailLoading;

    -(void)startWikitudeSDKRendering;
    -(void)setUrl:(NSString *)url;
    -(void)injectLocationWithAltitude:(double *)latitude longitude:(double *)longitude;
    -(void)callJavaScript:(NSString *)js;
    -(void)stopWikitudeSDKRendering;
    -(BOOL)isRunning;
    
@end
