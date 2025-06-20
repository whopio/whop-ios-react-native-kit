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
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.5/WhopReactNativeKit-Debug.xcframework.zip",
      checksum: "2f70d31015cb0ace64b28103d1a85cfa1cf6bd81dc8cc0b096e73ce3570da8b4"),
    .binaryTarget(
      name: "WhopReactNativeKit-Release",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.5/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "c2aa0f4949ff5a449134b577bfff88d87d3f8f6ba65ff36589378402d64ba2c9"),
  ]
)
