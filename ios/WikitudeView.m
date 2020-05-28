#import "WikitudeView.h"

#import <WikitudeSDK.h>




@implementation WikitudeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.architectView = [[WTArchitectView alloc] initWithFrame:frame];        
        [self addSubview: [self architectView]];   
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
      /**
                NSURL *absoluteURL = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html" subdirectory:bundleSubdirectory];
       */
        NSURL *url = [NSURL URLWithString:self.tmp_url];
        if(url && url.scheme && url.host){
            self.wtNavigation =  [self.architectView loadArchitectWorldFromURL:url];
        }else{
            NSURL *bundle = [[NSBundle mainBundle] bundleURL];
            NSURL *file = [NSURL URLWithString: [NSString stringWithFormat:@"../%@", self.tmp_url] relativeToURL:bundle];
            NSURL *absoluteFile = [file absoluteURL];
            self.wtNavigation =  [self.architectView loadArchitectWorldFromURL: [[NSBundle mainBundle] URLForResource:self.tmp_url withExtension:@"html"] ];
        }
       
        
        self.tmp_url = @"";
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.hasCameraPermission)
               [self startWikitudeSDKRendering];
        });
        
        return self;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    // Ensure webview takes the position and dimensions of View
    self.architectView.frame = self.bounds;
}

- (void)didReceiveApplicationDidBecomeActiveNotification:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.architectView != nil){
            if([self.architectView isRunning] == NO){
                if(self.hasCameraPermission)
                  [self startWikitudeSDKRendering];
            }
        }
        
    });
}
- (void)didReceiveApplicationWillResignActiveNotification:(NSNotification *)notification
{
    if(self.architectView != nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.architectView isRunning] != NO){
                [self stopWikitudeSDKRendering];
            }
        });
    }
    
}
- (void)setLicenseKey:(NSString *)licenseKey
{
    [self.architectView setLicenseKey:licenseKey];
}

- (void)setFeatures:(NSInteger *)feature
{
    
    //self.requiredFeatures = feature;
}

-(void)setUrl:(NSString *)url
{
    
    NSLog(@"url: %@",url);
    /*if( url != self.tmp_url){
        
    }
    */
    self.tmp_url = url;
    @try {
        //NSLog(url);
        if( self.architectView != nil){
            NSLog(@"loadArchitectWorld");
            
            NSURL *url2 = [NSURL URLWithString:url];
                  if(url2 && url2.scheme && url2.host){
                      self.wtNavigation =  [self.architectView loadArchitectWorldFromURL:url2];
                  }else{
                      NSURL *bundle = [[NSBundle mainBundle] bundleURL];
                      NSURL *file = [NSURL URLWithString:[NSString stringWithFormat:@"../%@", self.tmp_url] relativeToURL:bundle];
                      NSURL *absoluteFile = [file absoluteURL];
                      self.wtNavigation =  [self.architectView loadArchitectWorldFromURL: [[NSBundle mainBundle] URLForResource:self.tmp_url withExtension:@"html"] ];
                  }
            //[self.architectView loadArchitectWorldFromURL:[NSURL URLWithString:url]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@ EXP", exception.reason);
    }
    
}

-(void)startWikitudeSDKRendering{

    /* To check if the WTArchitectView is currently rendering, the isRunning property can be used */
    if ( ![self.architectView isRunning] ) {
        
        [self.architectView start:^(WTArchitectStartupConfiguration * _Nonnull configuration) {
            
        } completion:^(BOOL isRunning, NSError * _Nonnull error) {
                if ( !isRunning ) {
                               NSLog(@"WTArchitectView could not be started. Reason: %@", [error localizedDescription]);
                           }
              NSLog(@"Corriendo Completion");
        }];

    }else{
        NSLog(@"No Corriendo");
    }
}

-(void)stopWikitudeSDKRendering {
    /* The stop method is blocking until the rendering and camera access is stopped */
    if ( [self.architectView isRunning] ) {
        [self.architectView stop];
    }
}

-(void)injectLocationWithLatitude:(double *)latitude longitude:(double *)longitude{
    [self.architectView injectLocationWithLatitude:*latitude longitude:*longitude accuracy:100.0];
}

- (void)callJavaScript:(NSString *)js{
    if ( [_architectView isRunning] ) {
        [_architectView callJavaScript:js];
    }
}
@end
