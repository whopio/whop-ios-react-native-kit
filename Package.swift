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
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.22/hermes.xcframework.zip",
      checksum: "76a12f7fc47a53a68fc691c79a3855b2a95c2aadea2c26e0b92c558039263bde"),
    .binaryTarget(
      name: "WhopReactNativeKit",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.22/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "a0e70af5e8cc5a07e6b1378e7317ad2c31eb1ea50ee7365b559ae35674053e05"),
  ]
)
