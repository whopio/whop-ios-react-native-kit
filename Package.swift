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
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.1.1/hermes.xcframework.zip",
      checksum: "40c33b5e2d165825eaac6a1311bde380a8b0ba5fd690bdbd6bbce339c7349ba4"),
    .binaryTarget(
      name: "WhopReactNativeKit",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.1.1/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "1181ee1ee4da8700f16a1d04247f38dcd245306facd90ad6cd29e1cf4ad86e50"),
  ]
)
