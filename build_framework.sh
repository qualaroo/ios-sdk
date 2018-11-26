#!/bin/bash
# Set bash script to exit immediately if any commands fail.
set -e

# Setup some constants for use later on.
SRCROOT="."
FRAMEWORK_NAME="Qualaroo"

# If remnants from a previous build exist, delete them.
if [ -d "${SRCROOT}/build" ]; then
rm -rf "${SRCROOT}/build"
fi

# Build the framework for device and for simulator (using all needed architectures).
xcodebuild -target "${FRAMEWORK_NAME}" -configuration Release -arch arm64 -arch armv7 -arch armv7s only_active_arch=no defines_module=yes -sdk "iphoneos"
xcodebuild -target "${FRAMEWORK_NAME}" -configuration Release -arch x86_64 -arch i386 only_active_arch=no defines_module=yes -sdk "iphonesimulator"
xcodebuild -target "${FRAMEWORK_NAME}" -configuration Release BITCODE_GENERATION_MODE=bitcode OTHER_CFLAGS="-fembed-bitcode" -arch arm64 -arch armv7 -arch armv7s only_active_arch=no defines_module=yes -sdk "iphoneos"
xcodebuild -target "${FRAMEWORK_NAME}" -configuration Release BITCODE_GENERATION_MODE=bitcode OTHER_CFLAGS="-fembed-bitcode" -arch x86_64 -arch i386 only_active_arch=no defines_module=yes -sdk "iphonesimulator"

# Remove .framework file if exists on Desktop from previous run.
if [ -d "${FRAMEWORK_NAME}.framework" ]; then
rm -rf "${FRAMEWORK_NAME}.framework"
fi

# Copy the device version of framework to Desktop.
cp -r "${SRCROOT}/build/Release-iphoneos/${FRAMEWORK_NAME}.framework" "${FRAMEWORK_NAME}.framework"

# Replace the framework executable within the framework with a new version created by merging the device and simulator frameworks' executables with lipo.
lipo -create -output "${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${SRCROOT}/build/Release-iphoneos/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${SRCROOT}/build/Release-iphonesimulator/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"

# Copy the Swift module mappings for the simulator into the framework.  The device mappings already exist from previous step.
cp -r "${SRCROOT}/build/Release-iphonesimulator/${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule/" "${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule"

# Delete the most recent build.
if [ -d "${SRCROOT}/build" ]; then
rm -rf "${SRCROOT}/build"
fi
