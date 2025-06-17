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
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/$version/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "ff2342fe234fdaf2ea34fd2a5ef123da4f2ea43df23ea"),
    .binaryTarget(
      name: "WhopReactNativeKit-Release",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/$version/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "helloworld"),
  ]
)
