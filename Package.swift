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
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.21/hermes.xcframework.zip",
      checksum: "76a12f7fc47a53a68fc691c79a3855b2a95c2aadea2c26e0b92c558039263bde"),
    .binaryTarget(
      name: "WhopReactNativeKit",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.21/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "0f59efb1b00a4b98195fb3ee0d569109c872d17e821bbdd5fbe5453e1cfc7395"),
  ]
)
