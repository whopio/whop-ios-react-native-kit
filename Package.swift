// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "WhopReactNativeKit",
  platforms: [
    .iOS(.v17)
  ],
  products: [
    .library(
      name: "WhopReactNativeKit",
      targets: ["WhopReactNativeKit-Release"]
    ),
    .library(
      name: "WhopReactNativeDevKit",
      targets: ["WhopReactNativeKit-Debug"]
    ),
  ],
  targets: [
    .binaryTarget(
      name: "WhopReactNativeKit-Debug",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.2/WhopReactNativeKit-Debug.xcframework.zip",
      checksum: "e14906fbdbbecf96afc21c96b621616cf9ff9b9e8e2a18a543d266dfc383e512"),
    .binaryTarget(
      name: "WhopReactNativeKit-Release",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.2/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "e0093243bbc0c795ef8a24380c0131010627913916630fe044a7b4ccdca80a92"),
  ]
)
