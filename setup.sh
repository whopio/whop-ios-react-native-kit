#!/bin/bash

set -e
ruby --version
export NO_FLIPPER=1
root=$(pwd)
rm -rf ./react-native
mkdir -p ./react-native
cd ./react-native
npx @react-native-community/cli init WhopReactNativeKit --version 0.80.0 --skip-git-init
cd ./WhopReactNativeKit
npm install \
    react-native-safe-area-context@5.4.1 \
    react-native-haptic-feedback@2.3.3 \
    react-native-gesture-handler@2.26.0 \
    react-native-reanimated@3.18.0 \
    @react-native-picker/picker@2.11.0 \
    react-native-svg@15.12.0 \
    @react-native-async-storage/async-storage@2.2.0 --save-exact

cd $root
rm -rf ./react-native/WhopReactNativeKit/ios/*
cp -r ./WhopReactNativeKit/* ./react-native/WhopReactNativeKit/ios/

cd ./react-native/WhopReactNativeKit/ios
pod install
./build.sh
xed .

# Zip the output

# rm -rf ../whop-swift/LocalFrameworks/WhopReactNativeKit/WhopReactNativeKit-Debug.xcframework
# rm -rf ../whop-swift/LocalFrameworks/WhopReactNativeKit/WhopReactNativeKit-Release.xcframework
# cp -r ./react-native/WhopReactNativeKit/ios/output/WhopReactNativeKit-Debug.xcframework ../whop-swift/LocalFrameworks/WhopReactNativeKit/WhopReactNativeKit-Debug.xcframework
# cp -r ./react-native/WhopReactNativeKit/ios/output/WhopReactNativeKit-Release.xcframework ../whop-swift/LocalFrameworks/WhopReactNativeKit/WhopReactNativeKit-Release.xcframework