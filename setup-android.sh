#!/bin/bash
set -e 

export PUBLISHING_VERSION=$(cat ./android_version.txt)

echo "Building version: $PUBLISHING_VERSION"
echo "Press enter to continue"
read value_does_not_matter


bash ./setup-shared.sh

echo "[TASK] Bootstrap raw react-native project: COMPLETE"
echo "[TASK] Prepare custom modules: START"

node ./prepare-custom-modules.js

echo "[TASK] Prepare custom modules: COMPLETE"
echo "[TASK] Setup the android project: START"


# copy configuration files into the android project
cp -r ./android/whopreactnativekit ./react-native/WhopReactNativeKit/android/whopreactnativekit
cp ./android/build.gradle ./react-native/WhopReactNativeKit/android/build.gradle
cp ./android/settings.gradle ./react-native/WhopReactNativeKit/android/settings.gradle
cp ./android/rnef.config.mjs ./react-native/WhopReactNativeKit/rnef.config.mjs


# Go into the react native project:
cd ./react-native/WhopReactNativeKit

# install the brownfield plugin:
npm i @rnef/plugin-brownfield-android @callstack/react-native-brownfield

# make the cli executable:
chmod +x ./node_modules/@react-native-community/cli/build/bin.js

echo "[TASK] Setup the android project: COMPLETE"
echo "[TASK] Generate codegen artifacts: START"
cd ./android

export ANDROID_HOME=$HOME/Library/Android/sdk

./gradlew generateCodegenArtifactsFromSchema
echo "[TASK] Generate codegen artifacts: COMPLETE"


echo "[TASK] Package the aar file: START"
npx @rnef/cli package:aar --variant Release --module-name whopreactnativekit
npx @rnef/cli package:aar --variant Debug --module-name whopreactnativekit
echo "[TASK] Package the aar file: COMPLETE"

echo "[TASK] Publish the aar file: START"
rm -rf ~/.m2/repository/com/whoprnkit/whopreactnativekit
npx @rnef/cli publish-local:aar --module-name whopreactnativekit
echo "[TASK] Publish the aar file: COMPLETE"

# go back to the root of the project:
cd ../../../


echo ""
echo "  ✔︎✔︎✔︎ Android AAR file is ready to use ✔︎✔︎✔︎"
echo ""

