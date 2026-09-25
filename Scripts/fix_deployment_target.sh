#!/bin/bash
# tuist generate + Xcode 27 deployment target 패치

tuist generate

find Tuist/.build/tuist-derived -name "project.pbxproj" -exec sed -i '' \
  's/IPHONEOS_DEPLOYMENT_TARGET = 12\.0/IPHONEOS_DEPLOYMENT_TARGET = 16.0/g; s/IPHONEOS_DEPLOYMENT_TARGET = 13\.0/IPHONEOS_DEPLOYMENT_TARGET = 16.0/g' {} \;

echo "Done. tuist generate + deployment target patched."
