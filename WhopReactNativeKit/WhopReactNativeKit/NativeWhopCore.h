//
//  NativeWhopCore.h
//  WhopReactNativeKit
//
//  Created by Jordan Jantschulev on 7/15/25.
//

#import <Foundation/Foundation.h>
#import <ReactCodegen/NativeWhopCore/NativeWhopCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NativeWhopCoreDelegate;

@interface NativeWhopCore : NativeWhopCoreSpecBase <NativeWhopCoreSpec>

@property(nonatomic) id<NativeWhopCoreDelegate> delegate;

- (instancetype)initWithDelegate:(id<NativeWhopCoreDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
