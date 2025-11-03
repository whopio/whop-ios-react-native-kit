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
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.1.0/hermes.xcframework.zip",
      checksum: "3e49f30c289cae9cad53733e7f21c42c39802e05e506de263c4d77e947b5c739"),
    .binaryTarget(
      name: "WhopReactNativeKit",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.1.0/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "e7697da978abb6b9cd7efbd16bcb77f0c4ffb1617138269908c529d7c443128b"),
  ]
)
