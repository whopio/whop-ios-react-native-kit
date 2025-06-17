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
        "https://github.com/wafflestudio/ios-rn-prebuilt/releases/download/0.23.0/WhopReactNativeKit-Debug.xcframework.zip",
      checksum: "a503b02d84e776185e2af827b9283fa2a1bb61e4f3971c25c1d8a9243acbdf07"),
    .binaryTarget(
      name: "WhopReactNativeKit-Release",
      url:
        "https://github.com/wafflestudio/ios-rn-prebuilt/releases/download/0.23.0/WhopReactNativeKit-Release.xcframework.zip",
      checksum: "41e5deb537d41e609e0d4c841ac50f807927abccf72d85424434d05a3bf6ccea"),
  ]
)
