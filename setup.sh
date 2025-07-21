#!/bin/bash

set -e
ruby --version
export NO_FLIPPER=1
root=$(pwd)
rm -rf ./react-native
mkdir -p ./react-native
cd ./react-native
npx @react-native-community/cli init WhopReactNativeKit --version 0.80.0 --skip-git-init --install-pods false
cd ./WhopReactNativeKit
npm install \
  react-native-nitro-modules@0.26.3 \
  react-native-video@6.16.1 \
  @d11/react-native-fast-image@8.10.0 \
  react-native-svg@15.12.0 \
  react-native-webview@13.15.0 \
  --legacy-peer-deps --save-exact
# npm install \
#     react-native-safe-area-context@5.4.1 \
#     react-native-haptic-feedback@2.3.3 \
#     react-native-gesture-handler@2.26.0 \
#     react-native-reanimated@3.18.0 \
#     @react-native-picker/picker@2.11.0 \
#     react-native-svg@15.12.0 \
#     @react-native-camera-roll/camera-roll@7.10.0 \
#     react-native-sensors@7.3.6 \
#     @react-native-async-storage/async-storage@2.2.0 --save-exact

cd $root

# apply patches to npm installs:
cp ./patches/RNFastImage.podspec ./react-native/WhopReactNativeKit/node_modules/@d11/react-native-fast-image/RNFastImage.podspec

rm -rf ./react-native/WhopReactNativeKit/ios/*
cp -r ./WhopReactNativeKit/* ./react-native/WhopReactNativeKit/ios/

node ./prepare-custom-modules.js

cd ./react-native/WhopReactNativeKit/ios
pod install
./build.sh

echo "  ✔︎  Finished building the framework"

cd output
# ditto -c -k --sequesterRsrc --keepParent "WhopReactNativeKit-Debug.xcframework" "WhopReactNativeKit-Debug.xcframework.zip"
ditto -c -k --sequesterRsrc --keepParent "WhopReactNativeKit-Release.xcframework" "WhopReactNativeKit-Release.xcframework.zip"
# ditto -c -k --sequesterRsrc --keepParent "hermes.xcframework" "hermes.xcframework.zip" 
# using a externally downloaded hermes.xcframework.zip directly from the github action that published 0.80.0 in the facebook/react-native repo. 
# This MUST be the release version of the darwin-hermes-RELEASE. Then find the universal xcframework in the Library/Frameworks... 
# and then run this ditto command and copy the zip to the root of this project.

echo "  ✔︎  Finished zipping the framework"

cd $root

# mv ./react-native/WhopReactNativeKit/ios/output/WhopReactNativeKit-Debug.xcframework.zip ./WhopReactNativeKit-Debug.xcframework.zip
mv ./react-native/WhopReactNativeKit/ios/output/WhopReactNativeKit-Release.xcframework.zip ./WhopReactNativeKit-Release.xcframework.zip
# mv ./react-native/WhopReactNativeKit/ios/output/hermes.xcframework.zip ./hermes.xcframework.zip

echo "  ✔︎✔︎✔︎  Success!  ✔︎✔︎✔︎"