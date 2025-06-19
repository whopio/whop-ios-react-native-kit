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
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.3/WhopReactNativeKit-Debug.xcframework.zip",
      checksum: "4c3121f994f4b62a0f2e76a9d4d9e77609b8627c6703d652f3e9baf05acf9f2c"),
    .binaryTarget(
      name: "WhopReactNativeKit-Release",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.3/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "a25df8e1481d48269bd48ac8a8723de4321a96d80b17c864ec1186c3e88e3b82"),
  ]
)
