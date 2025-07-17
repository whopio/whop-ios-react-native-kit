//
//  ReactKitAppFactory.m
//  WhopReactNativeKit
//
//  Created by Jordan Jantschulev on 7/11/25.
//

#import "ReactKitAppFactory.h"
#import "NativeWhopCore.h"
#import "WhopReactNativeKit-Swift.h"
#import <React/RCTLog.h>

@interface RCTReactNativeFactory (Private)
- (id<RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass;
@end

@implementation ReactKitAppFactory

@synthesize reactKitDelegate = _reactKitDelegate;

@synthesize whopCoreDelegate = _whopCoreDelegate;

- (id<RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass {
  // Check the delegate first
  if (self.reactKitDelegate) {
    if ([self.reactKitDelegate
            respondsToSelector:@selector(getModuleInstanceFromClass:)]) {
      id<RCTTurboModule> candidate =
          [self.reactKitDelegate getModuleInstanceFromClass:moduleClass];

      if (candidate) {
        RCTLogInfo(@"[ReactKitAppFactory] getModuleInstanceFromClass: Delegate "
                   @"supplied TurboModule for %@",
                   NSStringFromClass(moduleClass));
        return candidate;
      }
    }

    // Check if we are trying to construct custom ObjC++ turbo modules
    if ([NSStringFromClass(moduleClass) isEqual:@"NativeWhopCore"]) {
      bool classesEqual = moduleClass == NativeWhopCore.class;
      bool hasWhopCoreDelegate = self.whopCoreDelegate;
      RCTLogInfo(@"[ReactKitAppFactory] trying to register NativeWhopCore. "
                 @"classesEqual = %d, respondsToSelector = %d",
                 classesEqual, hasWhopCoreDelegate);
    }
    if (moduleClass == NativeWhopCore.class && self.whopCoreDelegate) {
      RCTLogInfo(@"[ReactKitAppFactory] constructed instance of "
                 @"NativeWhopCoreImpl with injected delegate");
      id<RCTTurboModule> moduleInstance =
          [[NativeWhopCore alloc] initWithDelegate:self.whopCoreDelegate];
      return moduleInstance;
    }
  }

  // Otherwise fall back to the stock factory logic.
  RCTLogInfo(@"[ReactKitAppFactory] getModuleInstanceFromClass: Falling back "
             @"to default TurboModule "
             @"resolution for %@",
             NSStringFromClass(moduleClass));
  return [super getModuleInstanceFromClass:moduleClass];
}

@end
