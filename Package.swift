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
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.4/WhopReactNativeKit-Debug.xcframework.zip",
      checksum: "93ac892ae8709694bcb201bce3f3626a90ae3bdeac20f459cd4f7cd2133c95f9"),
    .binaryTarget(
      name: "WhopReactNativeKit-Release",
      url:
        "https://github.com/whopio/whop-ios-react-native-kit/releases/download/0.0.4/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "ebeef6fe0d68100b929ed4a2010caa73df03857a5745ad6cdf525e5a582951bd"),
  ]
)
