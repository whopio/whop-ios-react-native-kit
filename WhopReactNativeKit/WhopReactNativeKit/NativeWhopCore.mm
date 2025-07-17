//
//  NativeWhopCore.m
//  WhopReactNativeKit
//
//  Created by Jordan Jantschulev on 7/15/25.
//

#import "NativeWhopCore.h"
#import "WhopReactNativeKit-Swift.h"
#import <React/RCTLog.h>
#import <ReactCodegen/NativeWhopCore/NativeWhopCore.h>

NS_ASSUME_NONNULL_BEGIN

@implementation NativeWhopCore : NativeWhopCoreSpecBase

RCT_EXPORT_MODULE("NativeWhopCore")

@synthesize delegate = _delegate;

- (nonnull instancetype)initWithDelegate:
    (nonnull id<NativeWhopCoreDelegate>)delegate {
  _delegate = delegate;
  return self;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeWhopCoreSpecJSI>(params);
}

- (void)execAsync:(nonnull NSString *)name
       paramsJson:(nonnull NSString *)paramsJson
          resolve:(nonnull RCTPromiseResolveBlock)resolve
           reject:(nonnull RCTPromiseRejectBlock)reject {
  [_delegate execAsync:name
            paramsJson:paramsJson
               resolve:resolve
                reject:reject];
}

- (nonnull NSDictionary *)execSync:(nonnull NSString *)name
                        paramsJson:(nonnull NSString *)paramsJson {
  auto result = [_delegate execSync:name paramsJson:paramsJson];
  RCTLogInfo(@"[NativeWhopCore] (c++) called delegate for name: %@ ; params: "
             @"%@ ; result = %@",
             name, paramsJson, result);
  return result;
}

@end

NS_ASSUME_NONNULL_END
