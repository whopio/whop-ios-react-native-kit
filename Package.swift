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
      targets: ["WhopReactNativeKit"]
    ),
    .library(
      name: "hermes",
      targets: ["hermes"]
    ),
  ],
  targets: [
    .binaryTarget(
      name: "hermes",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.19/hermes.xcframework.zip",
      checksum: "76a12f7fc47a53a68fc691c79a3855b2a95c2aadea2c26e0b92c558039263bde"),
    .binaryTarget(
      name: "WhopReactNativeKit",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.19/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "e6c5dca140aac8934561020bc43090e9a637607328b951674564bbc63c81d14d"),
  ]
)
