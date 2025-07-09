#!/bin/bash

# Define variables
workspace="WhopReactNativeKit.xcworkspace"
scheme="WhopReactNativeKit"
outputDir="./output"
podsDir="./Pods"

# Declare environment variable
ENV_CONFIG=$CONFIGURATION

# Arrays of configurations and SDKs
declare -a configs
if [ -z "$ENV_CONFIG" ]; then
    configs=("Release")
else
    configs=("$ENV_CONFIG")
fi
declare -a sdks=("iphoneos" "iphonesimulator")

find "${podsDir}" -name '*.xcframework' -print0 | while read -d $'\0' file
do
    if [ "$(ls -A $file)" ]; then
        echo "Copying $file to ${outputDir}"
        rsync -a "$file" "${outputDir}"
    else
        echo "$file is empty or does not exist."
    fi
done

# Loop through configurations
for config in "${configs[@]}"; do
    # Loop through SDKs
    for sdk in "${sdks[@]}"; do
        # Define platform based on SDK
        platform=$([ "$sdk" == "iphonesimulator" ] && echo "iOS Simulator" || echo "iOS")

        # Run xcodebuild command for current configuration and SDK
        # xcodebuild \
        #     -workspace $workspace \
        #     -scheme $scheme \
        #     -destination="generic/platform=${platform}" \
        #     -configuration $config \
        #     -sdk $sdk \
        #     -archivePath "${outputDir}/${config}/${sdk}/${scheme}.xcarchive" \
        #     archive \
        #     SKIP_INSTALL=NO \
        #     BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        #     EXCLUDED_ARCHS=i386

        mkdir -p "$outputDir/$sdk"

        xcodebuild \
            -workspace "$workspace" \
            -scheme "$scheme" \
            -configuration "$config" \
            -sdk "$sdk" \
            BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
            SKIP_INSTALL=NO \
            -derivedDataPath "$outputDir/$sdk/DerivedData" \
            clean build
    done

    # Create xcframework
    # xcodebuild -create-xcframework \
    #     -framework "${outputDir}/${config}/iphoneos/${scheme}.xcarchive/Products/Library/Frameworks/${scheme}.framework" \
    #     -framework "${outputDir}/${config}/iphonesimulator/${scheme}.xcarchive/Products/Library/Frameworks/${scheme}.framework" \
    #     -output "${outputDir}/${scheme}-${config}.xcframework"

    # Create xcframework from *static* libraries (+ headers for each slice)
    xcodebuild -create-xcframework \
        -library "${outputDir}/iphoneos/DerivedData/Build/Products/$config-iphoneos/lib${scheme}.a" \
        -headers "${outputDir}/iphoneos/DerivedData/Build/Products/$config-iphoneos/${scheme}.swiftmodule" \
        -library "${outputDir}/iphonesimulator/DerivedData/Build/Products/$config-iphonesimulator/lib${scheme}.a" \
        -headers "${outputDir}/iphonesimulator/DerivedData/Build/Products/$config-iphonesimulator/${scheme}.swiftmodule" \
        -output "${outputDir}/${scheme}-${config}.xcframework"
done