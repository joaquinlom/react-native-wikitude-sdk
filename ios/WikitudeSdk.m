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


@implementation RNWikitude

 bool hasListeners;

/*
- (dispatch_queue_t)methodQueue
{
    //return dispatch_get_main_queue();
    return self.bridge.uiManager.methodQueue;
}*/
RCT_EXPORT_MODULE()

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
    return [[WikitudeView alloc] initWithBridge:self.bridge];
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

RCT_EXPORT_METHOD(resumeAR:(nonnull NSNumber *)reactTag){
    NSLog(@"Trying to call resume:");
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
      UIView *view = viewRegistry[reactTag];
        NSLog(@"View: Resume: %@",view);
      if (![view isKindOfClass:[WikitudeView class]]) {
        NSLog(@"expecting UIView, got: %@", view);
      }
      else {
        WikitudeView *component = (WikitudeView *)view;
        NSLog(@"resume UIView", component);
        [component startWikitudeSDKRendering];
      }
    }];
}
RCT_EXPORT_METHOD(stopAR:(nonnull NSNumber *)reactTag){
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
      UIView *view = viewRegistry[reactTag];
        NSLog(@"View: stopAR: %@",view);
      if (![view isKindOfClass:[WikitudeView class]]) {
        NSLog(@"expecting UIView, got: %@", view);
      }
      else {
        WikitudeView *component = (WikitudeView *)view;
         NSLog(@"stoping UIView", component);
          [component stopWikitudeSDKRendering];
      }
    }];
}
RCT_EXPORT_METHOD(captureScreen:(nonnull NSNumber *)reactTag mode:(BOOL *)mode){

    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
      UIView *view = viewRegistry[reactTag];
      if (![view isKindOfClass:[WikitudeView class]]) {
        RCTLog(@"expecting UIView, got: %@", view);
      }
      else {
        WikitudeView *component = (WikitudeView *)view;
         [component captureScreen:mode];
      }
    }];
}
RCT_EXPORT_METHOD(callJavascript:(nonnull NSNumber *)reactTag js:(NSString *)js){

    NSLog(@"RCT JS: %@",js);
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
      UIView *view = viewRegistry[reactTag];
      if (![view isKindOfClass:[WikitudeView class]]) {
        RCTLog(@"expecting UIView, got: %@", view);
      }
      else {
        NSLog(@"RCT JS: %@",js);
        WikitudeView *component = (WikitudeView *)view;
        [component callJavaScript:js];
      }
    }];
}
RCT_EXPORT_METHOD(loadArchitect:(nonnull NSNumber *)reactTag  url:(NSString *)url ){

        [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        UIView *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[WikitudeView class]]) {
            RCTLog(@"expecting UIView, got: %@", view);
        }
        else {
            WikitudeView *component = (WikitudeView *)view;
            [component loadArchitect:url];
        }
        }];
}
RCT_EXPORT_METHOD(setUrl:(nonnull NSNumber *)reactTag  url:(NSString *)url ){

        [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        UIView *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[WikitudeView class]]) {
            RCTLog(@"expecting UIView, got: %@", view);
        }
        else {
            WikitudeView *component = (WikitudeView *)view;
            NSLog(@"RCT Setting Url: %@",url);
            [component loadArchitect:url];
        }
        }];
}
RCT_EXPORT_METHOD(injectLocation:(nonnull NSNumber *)reactTag latitude:(double)latitude longitude:(double)longitude){

    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
      UIView *view = viewRegistry[reactTag];
      if (![view isKindOfClass:[WikitudeView class]]) {
        RCTLog(@"expecting UIView, got: %@", view);
      }
      else {	
        WikitudeView *component = (WikitudeView *)view;
        [component injectLocationWithLatitude:latitude longitude:longitude];
      }
    }];
}

RCT_EXPORT_METHOD(isDeviceSupportingFeatures:(int)feature reactTag:(nonnull NSNumber *)reactTag){
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
      UIView *view = viewRegistry[reactTag];
      if (![view isKindOfClass:[WikitudeView class]]) {
        RCTLog(@"expecting UIView, got: %@", view);
      }
      else {
        WikitudeView *component = (WikitudeView *)view;
        //[component injectLocationWithLatitude:latitude longitude:longitude];
      }
    }];
}


@end
