//
//  ReactKitAppFactory.h
//  WhopReactNativeKit
//
//  Created by Jordan Jantschulev on 7/11/25.
//

#if __has_include(<React-RCTAppDelegate/RCTReactNativeFactory.h>)
#import <React-RCTAppDelegate/RCTReactNativeFactory.h>
#elif __has_include(<React_RCTAppDelegate/RCTReactNativeFactory.h>)
#import <React_RCTAppDelegate/RCTReactNativeFactory.h>
#else
#import <React/RCTReactNativeFactory.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@protocol ReactKitTurboModule <RCTTurboModule>
@end

@protocol ReactKitAppFactoryDelegate <NSObject>
@optional
/// Return a custom TurboModule instance, or `nil` to fall back to the normal
/// path.
- (nullable id<ReactKitTurboModule>)getModuleInstanceFromClass:
    (Class)moduleClass;
@end

@interface ReactKitAppFactory : RCTReactNativeFactory

/// Optional delegate.  Weak to avoid retain cycles.
@property(nonatomic, weak, nullable) id<ReactKitAppFactoryDelegate>
    reactKitDelegate;

@end

NS_ASSUME_NONNULL_END
