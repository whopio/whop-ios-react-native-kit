#!/bin/bash

set -e

export PUBLISHING_VERSION=$(cat ./android_version.txt)

rm -rf ./docs/com/whoprnkit
mkdir -p ./docs/com/whoprnkit

# expect there to be a file in the ~/.m2/repository...
ls -la ~/.m2/repository/com/whoprnkit/whopreactnativekit/$PUBLISHING_VERSION/whopreactnativekit-$PUBLISHING_VERSION-release.aar
ls -la ~/.m2/repository/com/whoprnkit/whopreactnativekit/$PUBLISHING_VERSION/whopreactnativekit-$PUBLISHING_VERSION-debug.aar

cp -r ~/.m2/repository/com/whoprnkit/whopreactnativekit ./docs/com/whoprnkit/whopreactnativekit

git add ./docs
git commit -m "Publish Android SDK $PUBLISHING_VERSION"
git push


