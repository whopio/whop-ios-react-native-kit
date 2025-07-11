#!/bin/bash

# Define variables
workspace="WhopReactNativeKit.xcworkspace"
scheme="WhopReactNativeKit"
outputDir="./output"
podsDir="./Pods"

# Declare environment variable
ENV_CONFIG=$CONFIGURATION
sdk="iphonesimulator"
config="Release"

platform=$([ "$sdk" == "iphonesimulator" ] && echo "iOS Simulator" || echo "iOS")

mkdir -p "$outputDir/$sdk"

rm -rf "$outputDir/$scheme-$config.xcframework"

xcodebuild \
    -workspace "$workspace" \
    -scheme "$scheme" \
    -configuration "$config" \
    -sdk "$sdk" \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO \
    -derivedDataPath "$outputDir/$sdk/DerivedData" \
    build

if [ $? -ne 0 ]; then
    echo ""
    echo "  ✘  Build failed  ✘  "
    echo ""
    exit 1
fi

echo "  ✔︎  Build completed  ✔︎"

# Now we need to use libtool to create a single static library from all the static libraries in the output directory
# This makes the framework really big (200+ MB) but for now i think its ok. 
# We could also individually add all the headers to the framework, and then the main app can optimize what is included in the final app build.
baseLibDir="${outputDir}/$sdk/DerivedData/Build/Products/$config-$sdk"
libtool -static -o "${outputDir}/$sdk/lib${scheme}.a" "${baseLibDir}"/lib${scheme}.a "${baseLibDir}"/*/*.a

if [ $? -ne 0 ]; then
    echo ""
    echo "  ✘  Static library merge failed  ✘  "
    echo ""
    exit 1
fi

echo "  ✔︎  Static library merged  ✔︎"

# now we copy the swiftmodules to the output directory
cp -r "${baseLibDir}/${scheme}.swiftmodule" "${outputDir}/$sdk"

# Create xcframework from *static* libraries (the sibling swiftmodules will be automatically included)
xcodebuild -create-xcframework \
    -library "${outputDir}/iphonesimulator/lib${scheme}.a" \
    -output "${outputDir}/${scheme}-${config}.xcframework"
    # -library "${outputDir}/iphoneos/lib${scheme}.a" \

if [ $? -ne 0 ]; then
    echo ""
    echo "  ✘  XCFramework creation failed  ✘  "
    echo ""
    exit 1
fi

echo "  ✔︎  Build completed - XCFramework created  ✔︎"
