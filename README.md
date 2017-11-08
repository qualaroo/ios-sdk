# iOSMobileSDK

QualarooSDKiOS is framework for iOS. It's used to display and gather data from survey configured by [Qualaroo dashboard](https://app.qualaroo.com).

## How to get started
- Download [QualarooSDKiOS](https://github.com/qualaroo/QualarooSDKiOS/archive/master.zip) and try out example app.
- Check our [wiki page](https://github.com/qualaroo/QualarooSDKiOS/wiki).
- Checkout documentation - It's in `Documentation` folder. 
- Continue reading this page.
- [Changelog](https://github.com/qualaroo/QualarooSDKiOS/wiki/What-changed-in-the-last-version%3F)

## Communication
- If you are a developer and you need help with some internal SDK issue or you found a bug write: support@qualaroo.com
- If you want to know how can you benefit by using this SDK, or how to create survey using Qualaroo Dashboard write: info@qularoo.com
- If you need a feature or piece of functionality that SDK is currently not providing you, write: support@qualaroo.com

## Installation:
Preferred and supported installation method right now is using CocoaPods.
### CocoaPods
[CocoaPods](http://cocoapods.org/) is a dependency manager for Swift and Objective-C, which automates and simplifies the process of using 3rd-party libraries like QualarooSDK in your projects. You can install it with the following command:
```
$ gem install cocoapods
```
To integrate QualarooSDKiOS into your Xcode project using CocoaPods, specify it in your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'Qualaroo'
end
```
Then, run the following command:
```
$ pod install
```
### Manually
If you don't want to use any package managers, you can always add QualarooSDKiOS manually as an embedded framework.  
 
1. Drag and drop the framework into your Xcode project. Check "Copy items if needed". You will want to use "Frameworks" folder.
2. Now you have to add it to the “Embedded Binaries” by using the “+” button on the "General" tab of your target.
### IMPORTANT
Framework is supporting all architectures (so you can use it with simulator for example). Apple is currently not supporting application that include dynamic frameworks containing `x86_64`/`i386` architectures. So if you want to release your application you need to remove them from framework. Easiest way to do it is to add this script to build phases after "Embed Frameworks" phase.
```
APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

# This script loops through the frameworks embedded in the application and
# removes unused architectures.
find "$APP_PATH" -name 'Qualaroo.framework' -type d | while read -r FRAMEWORK
do
FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"

EXTRACTED_ARCHS=()

for ARCH in $ARCHS
do
echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
done

echo "Merging extracted architectures: ${ARCHS}"
lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
rm "${EXTRACTED_ARCHS[@]}"

echo "Replacing original executable with thinned version"
rm "$FRAMEWORK_EXECUTABLE_PATH"
mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"

done
```
Credit goes to Daniel Kennett.

## Requirements
Framework can be used for both iPhones and iPads.  
It supports iOS 8.0 and above.

## Usage
### Import
For swift it's just `import QualarooSDKiOS`  
For Objective-C it's `#import <QualarooSDKiOS/QualarooSDKiOS.h>`
### One-line-setup
If you want SDK to work with your application after integrating SDK is to call
```
Qualaroo.shared().configure(withApiKey: "sampleApiKey")
```
Where can I find "sampleApiKey"?

Go to your Qualaroo dashboard and find the mobile application that you're using.
Press setup on the top right corner of this section.

![where to find setup](https://user-images.githubusercontent.com/8074854/28832928-25c4021c-76de-11e7-86f1-643ddedf0672.png)

Then you should be able to copy API Key, that was just displayed.

![what shows after pressing setup](https://user-images.githubusercontent.com/8074854/28833190-e403a926-76de-11e7-872d-2fcbee759a42.png)

Use that copied key in configuration call.

Finished. Your app is now integrated with Qualaroo SDK.

### Features

[Check our wiki](https://github.com/qualaroo/QualarooSDKiOS/wiki/How-can-I-use-Qualaroo-SDK%3F) if you want to get familiar with features Qualaroo provide.

## License
MIT License

Copyright (c) 2017 Qualaroo, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
