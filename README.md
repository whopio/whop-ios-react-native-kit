# whop-ios-react-native-kit

Bundle react native and common external deps and compile into a XCFramework that can be redistributed as an SPM package on github.

> Most of this code is inspired by [this repo](https://github.com/wafflestudio/ios-rn-prebuilt)

## How to use

1. Update the `setup.sh` script with a new native "npm" package / new react native version or any changes you want to make
2. Run the `./setup.sh` script. This will build the xc framework and prepare it for release.
3. Run the `./publish.sh` script. This will publish a new version to github. 