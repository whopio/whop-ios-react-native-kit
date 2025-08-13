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
  react-native-reanimated@3.18.0 \
  react-native-gesture-handler@2.27.2 \
  react-native-haptic-feedback@2.3.3 \
  react-native-vision-camera@4.7.1 \
  react-native-safe-area-context@5.5.2 \
  lottie-react-native@7.3.2 \
  --legacy-peer-deps --save-exact

cd $root

