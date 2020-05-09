//
//  RNWikitude.m
//  RNWikitude
//
//  Created by Brave Digital Machine 7 on 2017/09/05.
//  Copyright © 2017 Brave Digital. All rights reserved.
//

#import "RNWikitude.h"
// import RCTLog
#if __has_include(<React/RCTLog.h>)
#import <React/RCTLog.h>
#elif __has_include("RCTLog.h")
#import "RCTLog.h"
#else
#import "React/RCTLog.h"   // Required when used as a Pod in a Swift project
#endif

#import <WikitudeSDK/WikitudeSDK.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTUIManager.h>

#define ERROR_PICKER_CANNOT_RUN_CAMERA_ON_SIMULATOR_KEY @"E_PICKER_CANNOT_RUN_CAMERA_ON_SIMULATOR"
#define ERROR_PICKER_CANNOT_RUN_CAMERA_ON_SIMULATOR_MSG @"Cannot run camera on simulator"

#define ERROR_PICKER_NO_CAMERA_PERMISSION_KEY @"E_PICKER_NO_CAMERA_PERMISSION"
#define ERROR_PICKER_NO_CAMERA_PERMISSION_MSG @"User did not grant camera permission."

#define ERROR_PICKER_UNAUTHORIZED_KEY @"E_PERMISSION_MISSING"
#define ERROR_PICKER_UNAUTHORIZED_MSG @"Cannot access images. Please allow access if you want to be able to select images."

@interface RNWikitude  () <WTArchitectViewDelegate>

@end

@implementation RNWikitude 
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()



@synthesize bridge = _bridge;
- (instancetype)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (NSDictionary *)constantsToExport
{
    return @{ @"ImageTracking": @(WTFeature_ImageTracking),
              @"Geo": @(WTFeature_Geo),
              @"ObjectTracking": @(WTFeature_ObjectTracking),
              @"InstantTracking": @(WTFeature_InstantTracking)
              };
}

- (UIView *)view
{
    _wikitudeView = [WikitudeView new];
    _wikitudeView.architectView.delegate = self;
    
    return _wikitudeView;
}
RCT_EXPORT_VIEW_PROPERTY(licenseKey,NSString);
RCT_EXPORT_VIEW_PROPERTY(url,NSString);
RCT_EXPORT_VIEW_PROPERTY(feature,NSInteger);
RCT_EXPORT_VIEW_PROPERTY(onJsonReceived, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFinishLoading, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFailLoading, RCTBubblingEventBlock)


- (void) setConfiguration:(NSDictionary *)options
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject {
    
    self.reject = reject;
}

- (UIViewController*) getRootVC {
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (root.presentedViewController != nil) {
        root = root.presentedViewController;
    }
    
    return root;
}
-(void)startWikitudeCamera{
        [self.architectView start:^(WTStartupConfiguration *configuration) {
        } completion:^(BOOL isRunning, NSError *error) {
            NSLog(@"WTArchitectView could started.");
            if ( !isRunning ) {
                NSLog(@"WTArchitectView could not be started. Reason: %@", [error localizedDescription]);
            }
        }];
}
- (void)checkCameraPermissions:(void(^)(BOOL granted))callback
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        callback(YES);
        return;
    } else if (status == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            callback(granted);
            return;
        }];
    } else {
        callback(NO);
    }
}


RCT_EXPORT_METHOD(resumeAR){
    if ( [_wikitudeView isRunning] != NO ) {
                [_wikitudeView startWikitudeSDKRendering];
    }
}
RCT_EXPORT_METHOD(stopAR){
    if(_wikitudeView != nil){
        if([_wikitudeView isRunning] != NO){
        [_wikitudeView stopWikitudeSDKRendering];
        }
    }
}

RCT_EXPORT_METHOD(callJavascript:(NSString *)js reactTag:(nonnull NSNumber *)reactTag){
    /*if( _wikitudeView != nil){
        [_wikitudeView callJavaScript:js];
    }
    */
    dispatch_async(dispatch_get_main_queue(), ^{
        WikitudeView *component = (WikitudeView *)[self.bridge.uiManager viewForReactTag:reactTag];
        
       // [component callJavaScript:js];
        [_wikitudeView callJavaScript:js];
    });
}
RCT_EXPORT_METHOD(setUrl:(NSString *)url reactTag:(nonnull NSNumber *)reactTag ){
    /*if(_wikitudeView != nil){
        [_wikitudeView setUrl:url];
    }*/

    dispatch_async(dispatch_get_main_queue(), ^{
           WikitudeView *component = (WikitudeView *)[self.bridge.uiManager viewForReactTag:reactTag];
           
           //[component setUrl:url];
          [_wikitudeView setUrl:url];
    });
}
RCT_EXPORT_METHOD(injectLocation:(double *)latitude longitude:(double *)longitude){
    if(_wikitudeView != nil){
        [_wikitudeView injectLocationWithAltitude:latitude longitude:longitude];
    }
}

RCT_EXPORT_METHOD(openNewWindow:(NSString *)url hasGeolocation:(BOOL *)geo hasImageRecognition:(BOOL *)image hasInstantTracking:(BOOL *)instant wikitudeSDKKey:(NSString *)sdkkey)
{

    
#if TARGET_IPHONE_SIMULATOR
    self.reject(ERROR_PICKER_CANNOT_RUN_CAMERA_ON_SIMULATOR_KEY, ERROR_PICKER_CANNOT_RUN_CAMERA_ON_SIMULATOR_MSG, nil);
    return;
#else
    [self checkCameraPermissions:^(BOOL granted) {
        if (!granted) {
            self.reject(ERROR_PICKER_NO_CAMERA_PERMISSION_KEY, ERROR_PICKER_NO_CAMERA_PERMISSION_MSG, nil);
            return;
        }
        
        ARViewController *arView = [[ARViewController alloc] init];
        arView.url = url;
        arView.sdkkey = sdkkey;

        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self getRootVC] presentViewController:arView animated:YES completion:nil];
        });
    }];
#endif
}


- (void)architectView:(WTArchitectView *)architectView receivedJSONObject:(NSDictionary *)jsonObject
{
    NSLog(@"onJsonObject");
    //dispatch_async(dispatch_get_main_queue(), ^{
        _wikitudeView.onJsonReceived(jsonObject);
   // });
}

- (void)architectView:(WTArchitectView *)architectView didFinishLoadArchitectWorldNavigation:(WTNavigation *)navigation {
    /* Architect World did finish loading */
    NSLog(@"Architect World finish loading");
    
    
    //[architectView callJavaScript: @"alert('desde RNWikitude')"];
    dispatch_async(dispatch_get_main_queue(), ^{
        _wikitudeView.onFinishLoading(@{
                                        @"success": @YES
                                        });
    });
    
}
- (void)architectView:(WTArchitectView *)architectView didFailToAuthorizeRestrictedAppleiOSSDKAPIs:(NSError *)error{
    NSLog(@"DidFailToAutorize %@",[error localizedDescription]);
}

- (void)architectView:(WTArchitectView *)architectView didFailToLoadArchitectWorldNavigation:(WTNavigation *)navigation withError:(NSError *)error {

    NSLog(@"En delegate: Architect World from URL '%@' could not be loaded. Reason: %@", navigation.originalURL, [error localizedDescription]);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        /*_wikitudeView.onFailLoading(@{
                                        @"success": @NO,
                                        @"message": [error localizedDescription]
                                        });
        */
    });
    
}


@end
