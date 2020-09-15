#import "WikitudeView.h"

#import <WikitudeSDK.h>




@implementation WikitudeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.frame = frame;
        self.architectView = [[WTArchitectView alloc] initWithFrame:frame];        
        [self addSubview: [self architectView]];   
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
      /**
                NSURL *absoluteURL = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html" subdirectory:bundleSubdirectory];
       */
        NSURL *url = [NSURL URLWithString:self.tmp_url];
        if(url && url.scheme && url.host){
            
            //self.wtNavigation =  [self.architectView loadArchitectWorldFromURL:url];
        }else{
            NSURL *bundle = [[NSBundle mainBundle] bundleURL];
            NSURL *file = [NSURL URLWithString: [NSString stringWithFormat:@"../%@", self.tmp_url] relativeToURL:bundle];
            NSURL *absoluteFile = [file absoluteURL];
             
            //self.wtNavigation =  [self.architectView loadArchitectWorldFromURL: [[NSBundle mainBundle] URLForResource:self.tmp_url withExtension:@"html"] ];
        }
       
        
        self.tmp_url = @"";
        /*
        dispatch_async(dispatch_get_main_queue(), ^{
           if(self.hasCameraPermission)
               [self startWikitudeSDKRendering];
        });
        */
        //self.architectView.requiredFeatures = WTFeature_ImageTracking;
        NSLog(@"InitWithFrame: ");
        //[self startWikitudeSDKRendering];
        return self;
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"layoutSubviews: ");
    // Ensure webview takes the position and dimensions of View
    self.architectView.frame = self.bounds;
}

- (void)didReceiveApplicationDidBecomeActiveNotification:(NSNotification *)notification
{
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.architectView != nil){
            if([self.architectView isRunning] == NO){
                if(self.hasCameraPermission)
                  [self startWikitudeSDKRendering];
            }
        }
    });*/

    if(self.architectView != nil){
        if([self.architectView isRunning] == NO){
                    if(self.hasCameraPermission)
                       [self startWikitudeSDKRendering];
               }
        dispatch_async(dispatch_get_main_queue(), ^{
       
        });
    }
}
- (void)didReceiveApplicationWillResignActiveNotification:(NSNotification *)notification
{
    if(self.architectView != nil){
        if([self.architectView isRunning] != NO){
                       [self stopWikitudeSDKRendering];
                   }
        dispatch_async(dispatch_get_main_queue(), ^{
           
        });
    }
    
}
- (void)setLicenseKey:(NSString *)licenseKey
{
    NSLog(@"setLicenseKey in property Native: ");
    //self.licenseKey = licenseKey;
    if( self.architectView != nil){
        [self.architectView setLicenseKey:licenseKey];
    }
        
}

- (void)setFeature:(NSInteger *)feature
{
    NSLog(@"Changing Feature: %@",feature);
    //self.requiredFeatures = feature;
    if( self.architectView != nil){
        NSLog(@"Changing Feature: %@",feature);
        self.architectView.requiredFeatures = feature;
        //[self.architectView reloadArchitectWorld];
    }
        
}
-(void)loadArchitect:(NSString *)url{
    NSLog(@"LoadArchitect  %@",url);
    NSUUID *uuid = [NSUUID UUID];
    NSString *str = [uuid UUIDString];
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@?uuid=%@", url,str]];
    if(url2 && url2.scheme && url2.host){
        self.architectWorldUrl = url2;
        if([self.architectView isRunning]){
            self.wtNavigation =  [self.architectView loadArchitectWorldFromURL:url2];
        }
    }else{  
        NSURL *bundle = [[NSBundle mainBundle] bundleURL];
        NSURL *file = [NSURL URLWithString:[NSString stringWithFormat:@"../%@", self.tmp_url] relativeToURL:bundle];
        NSURL *absoluteFile = [file absoluteURL];
        NSLog(@"Es Local url: %@",self.tmp_url);
        if([self.architectView isRunning]){
            self.wtNavigation =  [self.architectView loadArchitectWorldFromURL: [[NSBundle mainBundle] URLForResource:self.tmp_url withExtension:@"html"] ];
        }
    }
    [self startWikitudeSDKRendering];
}
-(void)setUrl:(NSString *)url
{
    if(url == nil || url == @""){
         NSLog(@"EMPTY setUrl in property Native EMPTY: %@",url);
        return;
    }
    NSLog(@"setUrl in property Native: %@",url);
    self.tmp_url = url;
    @try {
        if( self.architectView != nil){
            NSUUID *uuid = [NSUUID UUID];
            NSString *str = [uuid UUIDString];
            NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@?uuid=%@", url,str]];
            if(url2 && url2.scheme && url2.host){
                self.architectWorldUrl = url2;
                if([self.architectView isRunning]){
                    NSLog(@"Es Web url and isRunning: %@",url2);
                    //self.wtNavigation =  [self.architectView loadArchitectWorldFromURL:url2];
                }else{
                    NSLog(@"Architect is not running on Set URL");
                    //[self loadArchitect:url];
                    //self.wtNavigation =  [self.architectView loadArchitectWorldFromURL:url2];
                }
                [self.architectView loadArchitectWorldFromURL:url2];
                }else{
                      
                      NSURL *bundle = [[NSBundle mainBundle] bundleURL];
                      NSURL *file = [NSURL URLWithString:[NSString stringWithFormat:@"../%@", self.tmp_url] relativeToURL:bundle];
                      NSURL *absoluteFile = [file absoluteURL];
                      NSLog(@"Es Local url: %@",self.tmp_url);
                     if([self.architectView isRunning]){
                        self.wtNavigation =  [self.architectView loadArchitectWorldFromURL: [[NSBundle mainBundle] URLForResource:self.tmp_url withExtension:@"html"] ];
                    }
                  }
            [self startWikitudeSDKRendering];
            //[self stopWikitudeSDKRendering];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@ EXP", exception.reason);
    }
}

-(void)startWikitudeSDKRendering{

    if( self.architectView == nil){
        return;
    }
    NSLog(@"Start WikitudeSDK: runnning %d",[self.architectView isRunning]);
    /* To check if the WTArchitectView is currently rendering, the isRunning property can be used */

    @try{
        if ( ![self.architectView isRunning] ) {
            
            [self.architectView start:^(WTArchitectStartupConfiguration *configuration) {
                
            } completion:^(BOOL isRunning, NSError * _Nonnull error) {
                    if ( !isRunning ) {
                                NSLog(@"WTArchitectView could not be started. Reason: %@", [error localizedDescription]);
                            }
                    if(error){
                        //NSLog([error localizedDescription]);
                    }
                //[self.architectView loadArchitectWorldFromURL:self.architectWorldUrl];
                //[self.architectView reloadArchitectWorld];
                NSLog(@"SDK finish Started");
            }];

        }else{
            NSLog(@"is Already running Wiki Resume loading again the url");
            //if(self.architectWorldUrl != nil)
            // [self.architectView loadArchitectWorldFromURL:self.architectWorldUrl];
        }
    }@catch (NSException *exception) {
        NSLog(@"%@ START SDK EXCEPTION", exception.reason);
    }

}

-(void)stopWikitudeSDKRendering {
    if(self.architectView == nil){
        return;
    }
    /* The stop method is blocking until the rendering and camera access is stopped */
    if ( [self.architectView isRunning] ) {
        [self.architectView stop];
    }
}

-(void)injectLocationWithLatitude:(double *)latitude longitude:(double *)longitude{
    if(self.architectView != nil)
        [self.architectView injectLocationWithLatitude:*latitude longitude:*longitude accuracy:100.0];
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
@end
