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
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.7/WhopReactNativeKit-Debug.xcframework.zip",
      checksum: "f23907a6004608811eeeaa5290d9a1f2b63b65edf0686a990e03a95b6d64ac92"),
    .binaryTarget(
      name: "WhopReactNativeKit-Release",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.7/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "a66b9eacc2d2eeb3cfdc6c4f18acd3fdd8b08a1d0da20f22ec26f767698e5ca3"),
  ]
)
