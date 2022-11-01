<p align="center"><img src="img/logo-dark.png?raw=true" align="center" width="300"/></p>
<h1 align="center">QualarooSDK for iOS</h1>

<p align="center">
  <a href="https://github.com/qualaroo/ios-sdk/">
    <img src="https://img.shields.io/badge/version-1.14.7-blue.svg"/>
  </a>
  <img src="https://img.shields.io/badge/swift-5.1-green.svg"/>
  <a href="https://travis-ci.org/qualaroo/ios-sdk">
    <img src="https://img.shields.io/travis/qualaroo/ios-sdk/master.svg"/>
  </a>  
  <a href="https://github.com/Carthage/Carthage">
    <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/>
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

platform :ios, '9.0'

target 'TargetName' do
  pod 'Qualaroo', :git => 'https://github.com/qualaroo/ios-sdk.git', :tag => '1.14.7'
end
```

To integrate QualarooSDKiOS into your Flutter app using CocoaPods, specify it in your Podfile:
```

platform :ios, '9.0'

target 'TargetName' do
  pod 'Qualaroo', :git => 'https://github.com/qualaroo/ios-sdk.git', :tag => '1.14.7'
  pod 'Qualaroo/Flutter', :git => 'https://github.com/qualaroo/ios-sdk.git', :tag => '1.14.7'
end
```

Then, run the following command:
```
$ pod install
```
### Carthage
Simply add:
```
github "qualaroo/ios-sdk" ~> 1.14.7
```
to your `Cartfile`


### Swift Package Manager(SPM)
```
Step 1: Select File -> Add Packages...
Step 2: Search url https://github.com/qualaroo/ios-sdk
Step 3: Click the button "Add Package" 
Step 4: Check if the package is added at Target -> General -> Framework, Libraries, and Embedded Content
```

## Usage
Framework can be used for both iPhones and iPads.  It supports iOS 9.0 and above.

#### Imports
For Swift it's `import Qualaroo`  
For Objective-C it's `@import Qualaroo;`

Make sure that you have set **Always Embed Swift Standard Libraries** to **YES**

##### Pure Obj-C projects:
If you encounter problems in your project related to Swift symbols not being recognized, please add a new empty Swift file to your project (File->New file->Swift) and make sure you create an Objective C Bridging Header when Xcode prompts you to. 

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

You can also check whether particular survey will be displayed (i.e. SDK is initialized and all of the conditions are met).
```swift
let willShowSurvey = Qualaroo.shared.willSurveyBeShown(with alias: String)
if (willShowSurvey) {
  // do something
}
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

## Debug mode
In order to get additional info and help us with potential bugs and issues, use the following command:
```swift
Qualaroo.shared.setDebugMode(true)
```

## Known issues
If you notice the following log: `Could not load the "logo_ico" image referenced from a nib in the bundle with identifier "org.cocoapods.Qualaroo"` this might be caused by some other library that you are using. 

If possible, share your Podfile with us by creating a [new issue](https://github.com/qualaroo/ios-sdk/issues/new) and we will provide a workaround for you.

## Features
[Check our wiki](https://github.com/qualaroo/QualarooSDKiOS/wiki/How-can-I-use-Qualaroo-SDK%3F) if you want to get familiar with features Qualaroo provide.

## Communication
- If you are a developer and you need help with some internal SDK issue or you found a bug write: support@qualaroo.com
- If you want to know how can you benefit by using this SDK, or how to create survey using Qualaroo Dashboard write: info@qularoo.com
- If you need a feature or piece of functionality that SDK is currently not providing you, write: support@qualaroo.com
