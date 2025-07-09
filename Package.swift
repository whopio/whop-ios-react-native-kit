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
      name: "hermes",
      targets: ["hermes"]
    ),
  ],
  targets: [
    .binaryTarget(
      name: "WhopReactNativeKit-Release",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.12/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "f37e57f48e1c2e0ae2f0bebda1a709a1f19ad6a0475544394a0477834c0c9dd3"),
    .binaryTarget(
      name: "hermes",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.12/hermes.xcframework.zip",
      checksum: "1fbd21090beeabcafb460786abbd2583ca47a90a039d7d29f28e456273e28ac1"),
  ]
)
