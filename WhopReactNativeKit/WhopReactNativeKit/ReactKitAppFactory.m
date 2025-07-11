//
//  ReactKitAppFactory.m
//  WhopReactNativeKit
//
//  Created by Jordan Jantschulev on 7/11/25.
//

#import "ReactKitAppFactory.h"
#import <React/RCTLog.h>

@interface RCTReactNativeFactory (Private)
- (id<RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass;
@end

@implementation ReactKitAppFactory
@synthesize reactKitDelegate = _reactKitDelegate;

- (id<RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass {
  // Check the delegate first
  if (self.reactKitDelegate &&
      [self.reactKitDelegate
          respondsToSelector:@selector(getModuleInstanceFromClass:)]) {

    id<RCTTurboModule> candidate =
        [self.reactKitDelegate getModuleInstanceFromClass:moduleClass];

    if (candidate) {
      RCTLogInfo(@"[ReactKitAppFactory] Delegate supplied TurboModule for %@",
                 NSStringFromClass(moduleClass));
      return candidate;
    }
  }

  // Otherwise fall back to the stock factory logic.
  RCTLogInfo(@"[ReactKitAppFactory] Falling back to default TurboModule "
             @"resolution for %@",
             NSStringFromClass(moduleClass));
  return [super getModuleInstanceFromClass:moduleClass];
}
@end
