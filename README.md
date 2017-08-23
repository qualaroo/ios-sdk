# iOSMobileSDK

QualarooSDKiOS is framework for iOS. It's used to display and gather data from survey configured by [Qualaroo dashboard](https://app.qualaroo.com).

## How to get started
- Download QualarooSDKiOS(link here!) and try out example app.
- Read FAQ(link here!) at wiki.
- Checkout documentation(link here!).
- Continue reading this page.

## Communication
- If you are a developer and you need help with some  internal SDK issue or you just found a bug write: support@qualaroo.com
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
pod 'QualarooSDKiOS'
end
```
Then, run the following command:
```
$ pod install
```
### Carthage
Not yet supported
### Swift Package Manager
Not  supported yet
### Manually
If you don't want to use any package managers, you can always add QualarooSDKiOS manually as an embedded framework.  
It's quite easy, I'm sure that you've done it few times already.  
1. Drag and drop the framework into your Xcode project. Check "Copy items if needed". Probably you want to use "Frameworks" folder.
2. Now you have to add it to the “Embedded Binaries” by using the “+” button on the "General" tab of your target.
3. Framework is supporting all architectures (so you can use it with simulator for example) but if you want to release you need to add this script to build phases after "Embed Frameworks"
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
Credits goes to Daniel Kennett.

## Requirements
Framework can be used for both iPhones and iPads.  
It supports iOS 9.0 and above.
## Usage
### Import
For swift it's just `import QualarooSDKiOS`  
For Objective-C it's `#import <QualarooSDKiOS/QualarooSDKiOS.h>`
### One-line-setup
If you want SDK to work with your application after integrating SDK is to call
```
Qualaroo.shared().configure(withApiKey: "sampleApiKey")
```
Where to find "sampleApiKey"?
Go to dashboard(link here) and find mobile application section, that should be named as application that you are using.
Press setup on the top right corner of this section.

![where to find setup](https://user-images.githubusercontent.com/8074854/28832928-25c4021c-76de-11e7-86f1-643ddedf0672.png)

Then you should be able to copy API Key, that was just displayed.

![what shows after pressing setup](https://user-images.githubusercontent.com/8074854/28833190-e403a926-76de-11e7-872d-2fcbee759a42.png)

Use that copied key in configuration call.

Finished. Your app is now integrated with Qualaroo SDK.

### What next?
Of course there is something more. We wouldn't leave you with something that easy.
First of all you have probably noticed that `configure(withApiKey:)` throws error. Probably that's why we should rather call it:
```
do {
  try Qualaroo.shared.configure(withApiKey: "sampleApiKey")
} catch {
  print("Probably something went wrong")
}
```
**Possible errors:**  
invalidAPIKey  
invalidSiteId  
dataEncodingException

All of them says that something is wrong with API key that you've provided.
If you can't find any spelling mistake, then probably you should [conntact us](mailto:Mihaly@qualaroo.com) and report that we messed up something with your credentials.

### Features
There is still more to explore :)

#### Autotracking vs survey showing on demand
There are two ways you can display a survey.
- Calling `showSurvey(with alias: String, on viewController: UIViewController)`
- Automatically when  UIViewController matching proper alias will show up.

In first case it's simple: You call a function and if there is a survey with given alias (and it was fetched properly) new UIViewController will be presented on top of given one. No hidden agenda. You exacly know what is happening.  
In second case it's easy: You don't do anything and survey will automatically shows when on viewDidAppear method of controller that name or title match any of active surveys. Under the hood there is some class name extracting and matching, with some viewDidAppear swizzling (*Call the iOS cops! Someone did some unauthorized swizzle!*).  
You can disable second mechanism while initializing Qualaroo framework, by adding autotracking param for configure method.
```
configure(withApiKey: "sampleApiKey", autotracking: false)
```

#### Languages
SDK supports using few languages for surveys.  
If survey have questions written only for one language, then have no worries - this language will be used.  
But if there are more variations of survey then we need to choose which one we should show to current user.
If survey have questions written only for one language, then have no worries - this language will be used.  
How to know how many languages survey support or add new one? After opening edit page of survey from dashboard you should see this view on top of the screen.
How to know how many languages survey support or add new one?  
![Where to check languages](https://user-images.githubusercontent.com/8074854/28914723-09d321cc-783d-11e7-80e7-0d48613e566b.png)  
You can expand languages list and just check how meny currently are supported.

So what happen when we have more then one language and we want to be sure that correct one will be displayed. There is funcion for that.
```
Qualaroo.setPreferredSurveysLanguage("fr")
```
But be warned, function can throw an error if you will try to send language code that is something different then valid ISO Language Code. By example: we support languages like "en", "fr", "hu", etc. But language with country code wont be supported. So "en-UK", "en-AU" or "fr-CA" won't be supported.

What if language that you have specified is not supported by survey? Simple then we will try to use english, and if english is not supported then we will use first one from supported languages list.

#### Theme

We know that you like do things your own way. That's why we allow you fo fully customize colors used for displaying surveys.  
First you need to create ThemeConfigurator with pattern you want to use.
```
 ThemeConfigurator(logo: UIImage(named: "myOwnLogo"),
                   backgroundColor: .white,
                   textColor: .black,
                   dimType: .light,
                   buttonDisabledColor: .gray,
                   buttonEnabledColor: .green,
                   buttonTextColor: .white,
                   borderColor: .black)
```

Or you can use one of default two we've already created by calling `ThemeConfigurator.withStyle(_:logo:)`
Note that logo is optional. If you dont provide one, we will be more then happy to use our Qualaroo logo.
Right now we have two defaults styles:
```
ThemeConfigurator.Style.light
ThemeConfigurator.Style.dark
```
If you want to apply created theme, just call `Qualaroo.setTheme(justCreatedTheme)`  
You can change theme as often as you want to. Just rememer that changing it while survey is currently displayed won't affect this survey. Current one will use previous theme, but next one and every after will use one you jus set. Unless you'll change it again.

#### Targeting
Sometimes you might want to add a targeting conditions that are specific to your product and aplication users.   
For instance, you might decide to display a survey only to users who made a purchase in the past 30 days and only when the shopping cart contains exactly 2 items or client type is trial.
That's not a problem. First you need to name these properties and create valid rule using proper dashboard field.
[Image of new dashboard targeting section here]  
Rule can be created like `(last_purchase_time<30 and shopping_cart_count=2) or client_type="trial"`.  
Then when rule is created and accepted, we can go back to app and set user properties for current user:
```
Qualaroo.shared.setUserProperties(["last_purchase_time": "\(user.lastPurchaseTime)",
                                   "shopping_cart_count": "\(user.cart.items.count)",
                                   "client_type": user.type])
```
Now if user fulfills given rule - survey will show up. It won't show up for any user that is not fulfilling rule or if you didn't provide at least one of needed properties.

It's checked everytime that you ask for the survey or when you open survey revated view (check autotracking), so you can change in a meantime, and next time survey will show up if requested.

This is just an example, but I'm sure, that you already know how you can use it.

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
