#import "WikitudeView.h"

#import <WikitudeSDK.h>




@implementation WikitudeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.architectView = [[WTArchitectView alloc] initWithFrame:frame];
        
        /*[self loadArchitectWorldFromURL:[NSURL URLWithString:@"http://spinar-dev.com/wikitude/spinar/principal/index.html"]];*/
        //self.architectView.delegate = self;
        [self.architectView setLicenseKey:@"LrkTtevWC8CU1qsUr/eFXWzlLv/Ajke98OBWDALT09i3RxsfsUo6b4Wrs5SyrAeDXnVXGVEUQyqkbpVNnEhQMt6i2L2dwV5fyEV8Atz0REQNr+BmOQc2Zhix3OePMeLTMl8T/JEaiS5AiYlVUKsdyDxTxYQ43c1grzRrm9F2bjtTYWx0ZWRfXyb2NyPwiTu1xEgUJG+QkLL/k7A/SXIBmBlxuaxhwywKPmwRBxLOa0ZRPGFJZMkX+WqhXugh2F6iJKVZ8+5slT80x/Qdnr/2uHNnfBUCufis9nZHjqZqbs/c4ItGHStssOTyHcmeb95I9AwqAEAyWRhhMLjWQW7sf/5BAGdicTgOdxaZ/Y/w2Wpl0wG076xkr22XcUv1cqEqzlaSH6IfOR31ZY+gHUPdao18NXy3Dv10VN8x9vFzz9Qu5OX1AZMT9osLmBKAeWUq+ViHJZQy5GTnTLLEBukBh1zcUO68Pce8LC03N2exIhYCEtZNbv89nDXFw910uukx9sIgSerO1YyBkHuCsKktFXbuAQz7XFjfENd9WZHbf1RRJiO9nevrqzRjezAbth4WnwPX5TfIEnQse90qDZj1Xqewx4RCR2qoySSulwMoIePLutKYcr5Kk4F8nyY9rQM2F5HT82f0f/XrJl++7nQwNO9X6FIYX+8YGda86cCleE9cSH6/tOp0NpNp5pk+dfb5NZDc0OeRBXh4m2YZ34J+NQrXop0U+1ebpVw+1azEd1I="];
        self.translatesAutoresizingMaskIntoConstraints = NO;
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
