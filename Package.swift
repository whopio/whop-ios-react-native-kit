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
    .library(
      name: "hermes",
      targets: ["hermes"]
    ),
  ],
  targets: [
    .binaryTarget(
      name: "WhopReactNativeKit-Debug",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.10/hermes.xcframework.zip",
      checksum: "e929b45da64fe792c05e7e8edbb9b4c75264e68da2a701c72c3942ef6a937058"),
    .binaryTarget(
      name: "WhopReactNativeKit-Release",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.10/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "5b98bcf798998efa450fccdbdc8f463fe7c6d21abcf9e26dd706175dc1fdb8ba"),
    .binaryTarget(
      name: "hermes",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.10/hermes.xcframework.zip",
      checksum: "e1cb644c36f3420c3e23194d0daba138e095c62675082a54206297ede441f6b9"),
  ]
)
