#!/bin/bash

echo "Enter the version number (e.g. 0.1.0): "
read version

version=$(echo "$version" | tr -d '[:space:]')

# DEBUG_CHECKSUM=$(swift package compute-checksum "WhopReactNativeKit-Debug.xcframework.zip")
# DEBUG_URL="https://github.com/whopio/whop-ios-react-native-kit/releases/download/$version/WhopReactNativeKit-Debug.xcframework.zip"
RELEASE_CHECKSUM=$(swift package compute-checksum "WhopReactNativeKit-Release.xcframework.zip")
RELEASE_URL="https://github.com/whopio/whop-ios-react-native-kit/releases/download/$version/WhopReactNativeKit-Release.xcframework.zip"
HERMES_CHECKSUM=$(swift package compute-checksum "hermes.xcframework.zip")
HERMES_URL="https://github.com/whopio/whop-ios-react-native-kit/releases/download/$version/hermes.xcframework.zip"

# echo "WhopReactNativeKit-Debug.xcframework.zip:"
# echo "url: $DEBUG_URL"
# echo "checksum: $DEBUG_CHECKSUM"

echo "WhopReactNativeKit-Release.xcframework.zip:"
echo "url: $RELEASE_URL"
echo "checksum: $RELEASE_CHECKSUM"

echo "hermes.xcframework.zip:"
echo "url: $HERMES_URL"
echo "checksum: $HERMES_CHECKSUM"

echo "Updating the Package.swift file..."
sed -E -i '' \
    "/name: \"WhopReactNativeKit\"/,/checksum:/ \
    s/checksum: \"[^\"]*\"/checksum: \"${RELEASE_CHECKSUM}\"/" \
    Package.swift

sed -E -i '' \
    "/name: \"hermes\"/,/checksum:/ \
    s/checksum: \"[^\"]*\"/checksum: \"${HERMES_CHECKSUM}\"/" \
    Package.swift

# sed -E -i '' \
#     "/name: \"WhopReactNativeKit-Debug\"/,/checksum:/ \
#     s/checksum: \"[^\"]*\"/checksum: \"${DEBUG_CHECKSUM}\"/" \
#     Package.swift

# sed -E -i '' \
#   "/name: \"WhopReactNativeKit-Debug\"/,/checksum:/ {
#       /url:/ {
#           n
#           s#\"[^\"]*\"#\"${DEBUG_URL}\"#
#       }
#   }" Package.swift

sed -E -i '' \
  "/name: \"WhopReactNativeKit\"/,/checksum:/ {
      /url:/ {
          n
          s#\"[^\"]*\"#\"${RELEASE_URL}\"#
      }
  }" Package.swift

sed -E -i '' \
  "/name: \"hermes\"/,/checksum:/ {
      /url:/ {
          n
          s#\"[^\"]*\"#\"${HERMES_URL}\"#
      }
  }" Package.swift

echo "Updated the Package.swift file - double check the output now then click enter:"
read value_does_not_matter

echo "Enter the release notes: "
read release_notes

echo "Committing to github"

git add Package.swift
git commit -m "Release $version - update binaryTarget URL & checksum"
git push origin main

echo "Creating a release on github with version $version"

gh release create "$version" "WhopReactNativeKit-Release.xcframework.zip" "hermes.xcframework.zip" \
  --title "WhopReactNativeKit $version" \
  --notes "$release_notes"

echo ""
echo ""
echo " ✔︎ Done! ✔︎ "
echo ""
