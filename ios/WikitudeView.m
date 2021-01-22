#import "WikitudeView.h"

#import <WikitudeSDK.h>
#import <AVKit/AVKit.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTLog.h>
#import <React/RCTUtils.h>
#import <React/UIView+React.h>


@interface WikitudeView () <WTArchitectViewDelegate, WTArchitectViewDebugDelegate>
@property (nonatomic, weak) RCTBridge *bridge;
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@end

@implementation WikitudeView

- (instancetype)initWithBridge:(RCTBridge *)bridge {
    if ((self = [super init])) {
        self.bridge = bridge;
        self.sessionQueue = dispatch_queue_create("sessionQueue", DISPATCH_QUEUE_SERIAL);
        self.architectView = [WTArchitectView new];
        self.architectView.delegate = self;
        [self addSubview: _architectView];
        [self.architectView setTranslatesAutoresizingMaskIntoConstraints:false];
        NSDictionary* viewsDict = @{@"view": self.architectView};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:viewsDict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:viewsDict]];
    }
    return self;
}
/*
- (void) didMoveToSuperview {
    if (self.superview) {
        [self startSession];
    }
}*/
/*
- (void)removeFromSuperview {
    _bridge = nil;
    _architectView = nil;
    [super removeFromSuperview];
}*/

- (void)startSession {
    dispatch_async(self.sessionQueue, ^{
        /**
         * We need to grant camera permission before starting AugmentPlayerSDK
         * otherwise we will have an error during initialization: "Cannot access the camera"
         * Also we must update our Info.plist to allow camera access on the App level, key: NSCameraUsageDescription
         */
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
        NSString* errorMessage = @"Augment Player need access to your camera to work.\nGo to Setting and allow access for this App.";
        __weak typeof(self) weakSelf = self;
        if (authStatus == AVAuthorizationStatusAuthorized) {
            [weakSelf startWikitudeSDKRendering];
        } else if (authStatus == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType: AVMediaTypeVideo completionHandler: ^(BOOL granted) {
                if (granted) {
                    [self startWikitudeSDKRendering];
                }
                else {
                    [weakSelf onFailLoading];
                }
            }];
        } else {
            [weakSelf onFailLoading];
        }
    });
}
/*
- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.frame = frame;
        self.architectView = [[WTArchitectView alloc] initWithFrame:frame];        
        [self addSubview: [self architectView]];
        
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        self.tmp_url = @"";
        NSLog(@"InitWithFrame: ");
        return self;
    }
    return self;
}*/



- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"layoutSubviews: ");
    // Ensure webview takes the position and dimensions of View
    self.architectView.frame = self.bounds;
}

- (void)setLicenseKey:(NSString *)licenseKey
{
    NSLog(@"setLicenseKey in property Native: ");
    if( self.architectView != nil){
        self.key = licenseKey;
        [self.architectView setLicenseKey:licenseKey];
        [self startSession];
    }
        
}

- (void)setFeature:(NSInteger *)feature
{
   NSLog(@"Changing Feature: Next version...");
}
-(void)loadArchitect:(NSString *)url{
    NSLog(@"LoadArchitect  %@",url);
    __weak typeof(self) weakSelf = self;
    [self setUrl:url];
}


-(void)setUrl:(NSString *)url
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(url == nil || [url  isEqual: @""]){
             NSLog(@"EMPTY setUrl in property Native EMPTY: %@",url);
            return;
        }
        NSLog(@"setUrl in property Native: %@",url);
        self.tmp_url = url;
        @try {
            if( self.architectView != nil){
                if([self.architectView isRunning]){
                   [self clearCache];
                }else{
                    NSLog(@"Architect is not running on Set URL");
                }
                NSURL *url2 = [NSURL URLWithString: url];
                if(url2 && url2.scheme && url2.host){
                    self.architectWorldUrl = url2;
                    [self.architectView loadArchitectWorldFromURL:url2];
                    
                }else{
                    NSLog(@"Es Local url: %@",self.tmp_url);
                    [self.architectView loadArchitectWorldFromURL: [[NSBundle mainBundle] URLForResource:self.tmp_url withExtension:@"html"] ];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@ EXP", exception.reason);
        }
    });
    
}

-(void)clearCache{
   // dispatch_async(dispatch_get_main_queue(), ^{
        if( self.architectView == nil){
            return;
        }
        [self.architectView callJavaScript:@"AR.context.destroyAll();"];
        NSLog(@"Clear cache WikitudeSDK:");
        [self.architectView clearCache];
    //});

}

-(void)startWikitudeSDKRendering{

    __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            @try{
                if ( ![self.architectView isRunning] ) {
                    [self.architectView start:^(WTArchitectStartupConfiguration *configuration) {
                        
                    } completion:^(BOOL isRunning, NSError * _Nonnull error) {
                            if ( !isRunning ) {
                                        NSLog(@"WTArchitectView could not be started. Reason: %@", [error localizedDescription]);
                                    }
                            if(error){
                                NSLog(@"%@", [error localizedDescription]);
                            }
                        NSLog(@"SDK finish Started");
                    }];

                }else{
                    NSLog(@"is Already running Wiki");
                }
            }@catch (NSException *exception) {
                NSLog(@"%@ START SDK EXCEPTION", exception.reason);
            }
        });
    NSLog(@"Start WikitudeSDK: is runnning %d",[self.architectView isRunning]);
}

-(void)stopWikitudeSDKRendering {
    NSLog(@"Stoping Wikitude");
    
    dispatch_async(dispatch_get_main_queue(), ^{
            if(self.architectView == nil){
                return;
            }
            /* The stop method is blocking until the rendering and camera access is stopped */
            if ( [self.architectView isRunning] ) {
                [self.architectView stop];
            }
    });
   
}

-(void)injectLocationWithLatitude:(double)latitude longitude:(double)longitude{
     if(self.architectView == nil){
        return;
    }
    if ([self.architectView isRunning] ){
        [self.architectView setUseInjectedLocation:YES];

        CLLocationDegrees latitudeDegrees = latitude;
        CLLocationDegrees longitudeDegrees = longitude;
        CLLocationAccuracy accuracy = 100.0;
        [self.architectView injectLocationWithLatitude:latitudeDegrees longitude:longitudeDegrees accuracy:accuracy];
    }
        
}
-(void)captureScreen:(BOOL *)mode{
    NSDictionary* info = @{};
      NSLog(@"Trying to Capture Screen");
       if(mode == YES){
            [self.architectView captureScreenWithMode: WTScreenshotCaptureMode_CamAndWebView usingSaveMode:WTScreenshotSaveMode_Delegate saveOptions:WTScreenshotSaveOption_CallDelegateOnSuccess context:info];
        }else{
            [self.architectView captureScreenWithMode: WTScreenshotCaptureMode_Cam usingSaveMode:WTScreenshotSaveMode_Delegate saveOptions:WTScreenshotSaveOption_CallDelegateOnSuccess context:info];
        }
}
- (void)callJavaScript:(NSString *)js{
    //NSLog(@"BEFORE CONDITION: %@",js);
    if ( [self.architectView isRunning] ) {
        NSLog(@"JS: %@",js);
        [self.architectView  callJavaScript:js];
    }
}

-(BOOL) isDeviceSupportingFeatures:(int *) feature{
    return TRUE;
}

- (void)showPhotoLibraryAlert
{
    UIAlertController *photoLibraryStatusNotificationController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Screenshot was stored in your photo library" preferredStyle:UIAlertControllerStyleAlert];
    [photoLibraryStatusNotificationController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
}
- (void)onInitializationError {
    if(_onFailLoading){
        _onFailLoading(@{
            @"success": @NO,
            @"message": @"Wikitude need Camera access"
                       });
    }
}
- (void)architectView:(WTArchitectView *)architectView didCaptureScreenWithContext:(NSDictionary *)context
{

    //WTScreenshotSaveMode saveMode = [[context objectForKey:kWTScreenshotSaveModeKey] unsignedIntegerValue];
    NSLog(@"didCaptureScreenWithContext");
    UIImage *image = [context objectForKey:kWTScreenshotImageKey];
    NSString *base = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    if (_onScreenCaptured) {
        _onScreenCaptured(@{
            @"success": @"true",
            @"image":  [NSString stringWithFormat:@"%@%@", @"data:image/png;base64,", base]
                          });
       }
}

- (void)architectView:(WTArchitectView *)architectView didFailCaptureScreenWithError:(NSError *)error
{
    NSLog(@"Error capturing screen: %@", error);
    if (_onScreenCaptured) {
        _onScreenCaptured(@{
            @"success": @"false"
                          });
    }
     

}

- (void)architectView:(WTArchitectView *)architectView receivedJSONObject:(NSDictionary *)jsonObject
{
    NSLog(@"onJsonObject");
    //dispatch_async(dispatch_get_main_queue(), ^{
        //_wikitudeView.onJsonReceived(jsonObject);
    if(_onJsonReceived){
        _onJsonReceived(jsonObject);
    }
   // });
     

}

- (void)architectView:(WTArchitectView *)architectView didFinishLoadArchitectWorldNavigation:(WTNavigation *)navigation {
    /* Architect World did finish loading */
    NSLog(@"Architect World finish loading");
    
    if(_onFinishLoading){
        _onFinishLoading(@{
            @"success": @YES
                         });
    }
    

    //[architectView callJavaScript: @"alert('desde RNWikitude')"];
    /*dispatch_async(dispatch_get_main_queue(), ^{
       // _wikitudeView.onFinishLoading(@{
                                        @"success": @YES
                                        });
    });*/
    
}
- (void)architectView:(WTArchitectView *)architectView didFailToAuthorizeRestrictedAppleiOSSDKAPIs:(NSError *)error{
    NSLog(@"DidFailToAutorize %@",[error localizedDescription]);
}


- (void)architectView:(WTArchitectView *)architectView didFailToLoadArchitectWorldNavigation:(WTNavigation *)navigation withError:(NSError *)error {

    NSLog(@"architect view '%@' \ndid fail to load navigation '%@' \nwith error '%@'", architectView, navigation, error);
    NSLog(@"En delegate: Architect World from URL '%@' could not be loaded. Reason: %@", navigation, [error localizedDescription]);

    if(_onFailLoading){
        _onFailLoading(@{
            @"success": @NO,
            @"message": [error localizedDescription]
                       });
    }
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        _wikitudeView.onFailLoading(@{
                                        @"success": @NO,
                                        @"message": [error localizedDescription]
                                        });
        
    });
     */
    

    
}

/*Debug*/
- (void)architectView:(WTArchitectView *)architectView didEncounterInternalError:(NSError *)error{
 NSLog(@"didEncounterInternalError %@",[error localizedDescription]);
}

- (void)architectView:(WTArchitectView *)architectView didEncounterInternalWarning:(WTWarning *)warning{
NSLog(@"didEncounterInternalWarning %@",warning );
}


@end
