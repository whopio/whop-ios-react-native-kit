#!/bin/bash
set -e 

bash ./setup-shared.sh

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