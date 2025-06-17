# whop-ios-react-native-kit

Bundle react native and common external deps and compile into a XCFramework that can be redistributed as an SPM package on github.

> Most of this code is inspired by [this repo](https://github.com/wafflestudio/ios-rn-prebuilt)

## How to use

1. Update the `setup.sh` script with a new native "npm" package / new react native version
2. Run the setup script.
3. Create a new github release, and a tag for the branch
4. Update the Package.swift file to point to the artifacts uploaded for the github release.