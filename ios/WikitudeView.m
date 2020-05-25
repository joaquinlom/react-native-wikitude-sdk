#import "WikitudeView.h"

#import <WikitudeSDK.h>




@implementation WikitudeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.architectView = [[WTArchitectView alloc] initWithFrame:frame];        
        [self addSubview:[self architectView]];   
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
       self.wtNavigation =  [self.architectView loadArchitectWorldFromURL:[NSURL URLWithString:self.tmp_url]];
        
        self.tmp_url = @"";
        dispatch_async(dispatch_get_main_queue(), ^{
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
    
    NSLog(@"tmp url: %@",self.tmp_url);
    NSLog(@"url: %@",url);
    /*if( url != self.tmp_url){
        
    }
    */
    self.tmp_url = url;
    @try {
        //NSLog(url);
        if( self.architectView != nil){
            NSLog(@"loadArchitectWorld");
            [self.architectView loadArchitectWorldFromURL:[NSURL URLWithString:url]];
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
