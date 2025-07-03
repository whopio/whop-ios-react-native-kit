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
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.6/WhopReactNativeKit-Debug.xcframework.zip",
      checksum: "e3a7f6f344ebe577a95b15cb7a8ba6b58316f9447ed97b99971e127e0eb75dac"),
    .binaryTarget(
      name: "WhopReactNativeKit-Release",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.6/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "3d0e7f9166a360db2af03b8ad3b73232050e6f354ed3d023abaa21bf32d1ec8e"),
  ]
)
