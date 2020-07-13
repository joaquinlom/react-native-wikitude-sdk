//
//  RNWikitude.m
//  RNWikitude
//
//  Created by Brave Digital Machine 7 on 2017/09/05.
//  Copyright © 2017 Brave Digital. All rights reserved.
//

#import "WikitudeSdk.h"
// import RCTLog
#if __has_include(<React/RCTLog.h>)
#import <React/RCTLog.h>
#elif __has_include("RCTLog.h")
#import "RCTLog.h"
#else
#import "React/RCTLog.h"   // Required when used as a Pod in a Swift project
#endif

#import <WikitudeSDK.h>
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
    [self checkCameraPermissions:^(BOOL granted) {
        self.hasCameraPermission = &(granted);
          }];
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
    [self checkCameraPermissions:^(BOOL granted) {
           self.hasCameraPermission = &(granted);
    }];
    if(_wikitudeView != nil){
        return _wikitudeView;
    }
   _wikitudeView = [WikitudeView new];
    _wikitudeView.hasCameraPermission = self.hasCameraPermission;
   _wikitudeView.architectView.delegate = self;
    return _wikitudeView;
}

// Please add this one
+ (BOOL)requiresMainQueueSetup
{
  return YES;
}
RCT_EXPORT_VIEW_PROPERTY(licenseKey,NSString);
RCT_EXPORT_VIEW_PROPERTY(url,NSString);
RCT_EXPORT_VIEW_PROPERTY(feature,NSInteger);
RCT_EXPORT_VIEW_PROPERTY(onJsonReceived, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFinishLoading, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFailLoading, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onScreenCaptured, RCTBubblingEventBlock)

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
    /*[self.wikitudeView start:^( *) {
        } completion:^(BOOL isRunning, NSError *error) {
            NSLog(@"WTArchitectView could started.");
            if ( !isRunning ) {
                NSLog(@"WTArchitectView could not be started. Reason: %@", [error localizedDescription]);
            }
        }];
    */
}
- (void)checkCameraPermissions:(void(^)(BOOL granted))callback
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        callback(YES);
        return;
    } else if (status == AVAuthorizationStatusNotDetermined){
        NSLog(@"No determinado");
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            callback(granted);
            return;
        }];
    }else if (status == AVAuthorizationStatusDenied){
        NSLog(@"Denied");
        /*
        NSURL * url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
        [UIApplication.sharedApplication openURL:url];
        */
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Camera Permission Needed" message:@"Wikitude needs the Camera to show AR" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                //button click event
            NSURL * url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
            [UIApplication.sharedApplication openURL:url];
                            }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [alert addAction:ok];
        [ [self getRootVC] presentViewController:alert animated:YES completion:nil];

    } else {
        NSLog(@"En el ultimo No");
        callback(NO);
    }
}


RCT_EXPORT_METHOD(resumeAR:(nonnull NSNumber *)reactTag){
    /*if ( [_wikitudeView isRunning] != NO ) {
                [_wikitudeView startWikitudeSDKRendering];
    }*/
    dispatch_async(dispatch_get_main_queue(), ^{
        WikitudeView *component = (WikitudeView *)[self.bridge.uiManager viewForReactTag:reactTag];
        
        [component startWikitudeSDKRendering];
        //[self->_wikitudeView callJavaScript:js];
    });
}
RCT_EXPORT_METHOD(stopAR:(nonnull NSNumber *)reactTag){
    /*if(_wikitudeView != nil){
        if([_wikitudeView isRunning] != NO){
        [_wikitudeView stopWikitudeSDKRendering];
        }
    }
    */
    dispatch_async(dispatch_get_main_queue(), ^{
        WikitudeView *component = (WikitudeView *)[self.bridge.uiManager viewForReactTag:reactTag];
        if([component isRunning] != NO){
            [component stopWikitudeSDKRendering];
        }
        
        //[self->_wikitudeView callJavaScript:js];
    });
}
RCT_EXPORT_METHOD(captureScreen:(BOOL *)mode reactTag:(nonnull NSNumber *)reactTag){
    /*if( _wikitudeView != nil){
        [_wikitudeView callJavaScript:js];
    }
    */
    
    dispatch_async(dispatch_get_main_queue(), ^{
        WikitudeView *component = (WikitudeView *)[self.bridge.uiManager viewForReactTag:reactTag];
        NSLog(@"capture rct export method");
        [component captureScreen:mode];
         [_wikitudeView captureScreen:mode];
    });
}
RCT_EXPORT_METHOD(callJavascript:(NSString *)js reactTag:(nonnull NSNumber *)reactTag){
    /*if( _wikitudeView != nil){
        [_wikitudeView callJavaScript:js];
    }
    */
    dispatch_async(dispatch_get_main_queue(), ^{
        WikitudeView *component = (WikitudeView *)[self.bridge.uiManager viewForReactTag:reactTag];
        
        [component callJavaScript:js];
        //[self->_wikitudeView callJavaScript:js];
    });
}
RCT_EXPORT_METHOD(setUrl:(NSString *)url reactTag:(nonnull NSNumber *)reactTag ){
    /*if(_wikitudeView != nil){
        [_wikitudeView setUrl:url];
    }*/

    dispatch_async(dispatch_get_main_queue(), ^{
           WikitudeView *component = (WikitudeView *)[self.bridge.uiManager viewForReactTag:reactTag];
           
        [component setUrl:url];
        //[self->_wikitudeView setUrl:url];
    });
}
RCT_EXPORT_METHOD(injectLocation:(double *)latitude longitude:(double *)longitude reactTag:(nonnull NSNumber *)reactTag){
    if(_wikitudeView != nil){
        [_wikitudeView injectLocationWithAltitude:latitude longitude:longitude];
    }
}
RCT_EXPORT_METHOD(isDeviceSupportingFeatures:(int)feature (RCTResponseSenderBlock)callback)
{
  if([_wikitudeView isDeviceSupportingFeatures:feature]){
         callback(@[[NSNull null], YES]);
  }else{
      callback(@[[NSNull null], NO]);
  }
}
RCT_EXPORT_METHOD(isDeviceSupportingFeatures:(int)feature reactTag:(nonnull NSNumber *)reactTag){
    if(_wikitudeView != nil){
        [_wikitudeView isDeviceSupportingFeatures:feature];
    }
}
- (void)showPhotoLibraryAlert
{
    UIAlertController *photoLibraryStatusNotificationController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Screenshot was stored in your photo library" preferredStyle:UIAlertControllerStyleAlert];
    [photoLibraryStatusNotificationController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
}
- (void)architectView:(WTArchitectView *)architectView didCaptureScreenWithContext:(NSDictionary *)context
{
    //WTScreenshotSaveMode saveMode = [[context objectForKey:kWTScreenshotSaveModeKey] unsignedIntegerValue];
    NSLog(@"didCaptureScreenWithContext");
    UIImage *image = [context objectForKey:WTScreenshotImageKey];
    NSString *base = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    _wikitudeView.onScreenCaptured(@{
            @"success": @"true",
            @"image":  [NSString stringWithFormat:@"%@%@", @"data:image/png;base64,", base]
    });
}

- (void)architectView:(WTArchitectView *)architectView didFailCaptureScreenWithError:(NSError *)error
{
    NSLog(@"Error capturing screen: %@", error);
    _wikitudeView.onScreenCaptured(@{
            @"success": @"false"
    });
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
    
    _wikitudeView.onFinishLoading(@{
    @"success": @YES
    });
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
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _wikitudeView.onFailLoading(@{
                                        @"success": @NO,
                                        @"message": [error localizedDescription]
                                        });
        
    });
    
}


@end
