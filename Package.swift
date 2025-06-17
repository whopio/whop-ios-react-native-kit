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
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.1/WhopReactNativeKit-Debug.xcframework.zip",
      checksum: "8d7d5e5510e58af3df201c5cbb97864924db7e60614f2163aa3650018148de98"),
    .binaryTarget(
      name: "WhopReactNativeKit-Release",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.1/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "4b8e3638f0f4361aa5ba75aef496920c371f0777fc682e85698eea58231619b3"),
  ]
)
