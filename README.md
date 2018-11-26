<p align="center"><img src="img/logo-dark.png?raw=true" align="center" width="300"/></p>
<h1 align="center">QualarooSDK for iOS</h1>

<p align="center">
  <a href="https://github.com/qualaroo/android-sdk/blob/dev/CHANGELOG.md">
    <img src="https://img.shields.io/badge/version-1.9.0-blue.svg">
  </a>
</p>

<p align="center">
  Qualaroo helps companies identify and capitalize on mobile visitor revenue opportunities.
</p>

## How to get started
- Download [QualarooSDKiOS](https://github.com/qualaroo/QualarooSDKiOS/archive/master.zip) and try out example app.
- Check our [wiki page](https://github.com/qualaroo/QualarooSDKiOS/wiki).
- Checkout documentation - It's in `Documentation` folder. 
- Continue reading this page.
- [Changelog](https://github.com/qualaroo/QualarooSDKiOS/wiki/What-changed-in-the-last-version%3F)

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

## Usage
Framework can be used for both iPhones and iPads.  It supports iOS 8.0 and above.

#### Imports
For Swift it's `import Qualaroo`  
For Objective-C it's `#import <Qualaroo/Qualaroo.h>`

#### Initialize the Client
In order to be able to use Qualaroo SDK you need to to initialize it first.
```swift
Qualaroo.shared.configure(with: "<your_key_here>")       
```
After initialization, the SDK will be accessible via `Qualaroo.shared` field.

#### Display survey with a given alias.
The survey will be displayed if all conditions configured in our dashboard are met
```swift
//Show survey with "your_survey_alias" alias
Qualaroo.shared.showSurvey(with: "your_survey_alias")
```
#### Set user properties
```swift
//Set unique user id
Qualaroo.shared.setUserID("HAL_9000")
//Add or replace user property "name" to "Hal"
Qualaroo.shared.addUserProperty("name", withValue: "Hal")
//remove property "name"
Qualaroo.shared.removeUserProperty("name")
```

#### Set preferred language
You can set preferred language that you want to use when displaying surveys.
```swift
//Set preferred display language to French
Qualaroo.shared.setPreferredSurveysLanguage("fr");
```
Language that you provide should be an ISO 639-1 compatible language code (two lowercase letters)

#### Configure options for displaying survey
```swift
//Omit targetting options
Qualaroo.shared.showSurvey(
    with: "your_survey_alias",
    forced: true
)
```

#### Observe survey related events
In order to be able to listen to events, you need to create your own implementation of a `SurveyDelegate` protocol:

```swift
public protocol SurveyDelegate: class {
  /// Survey view has loaded.
  func surveyDidStart()

  /// User has dismissed survey before finishing it.
  func surveyDidDismiss()

  /// User finished survey (or dismissed it on last message).
  func surveyDidFinish()

  /// Some internal error occured. Survey was closed and probably not finished.
  func surveyDidClose(errorMessage: String)

  /// Some question will be sending callbacks after user has responded. This method is optional.
  @objc optional func userDidAnswerQuestion(_ response: UserResponse)
}
```

To register a survey delegate for a given survey, use the `showSurvey` call:

```swift
class Foo {
    let surveyDelegate = YourSurveyDelegateImpl()

    func showMySurvey() {
        // show "your_survey_alias" survey and register a delagate
        Qualaroo.shared.showSurvey(
            with: "your_survey_alias",
            delegate: surveyDelegate
        )    
    }
}
```

#### Run AB tests [experimental!]
You might want to test multiple surveys at once and verify which performs best.
Out of surveys provided, one will be chosen on a random basis and presented to the user.
This choice will be stored throught multiple app launches.

To run an AB test out of surveys "A", "B" and "C":
```swift
Qualaroo.shared.abTestSurveys(
    with: ["my_survey_A", "my_survey_B", "my_survey_C"]
)
```
Keep in mind that this is an experimental feature and it's implementation might change in future releases.

## Release
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

## Features
[Check our wiki](https://github.com/qualaroo/QualarooSDKiOS/wiki/How-can-I-use-Qualaroo-SDK%3F) if you want to get familiar with features Qualaroo provide.

## Communication
- If you are a developer and you need help with some internal SDK issue or you found a bug write: support@qualaroo.com
- If you want to know how can you benefit by using this SDK, or how to create survey using Qualaroo Dashboard write: info@qularoo.com
- If you need a feature or piece of functionality that SDK is currently not providing you, write: support@qualaroo.com
