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
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.31/hermes.xcframework.zip",
      checksum: "76a12f7fc47a53a68fc691c79a3855b2a95c2aadea2c26e0b92c558039263bde"),
    .binaryTarget(
      name: "WhopReactNativeKit",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.31/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "82a387068ce5c9ddeb10b0939aa1ad0f4cba629cbbb6973f0d838ee773881a54"),
  ]
)
