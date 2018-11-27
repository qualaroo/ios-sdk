### Release guide
- edit version number in `Qualaroo/Info.plist` file.
- edit version number in `Qualaroo.podspec` file.
- run `pod lib lint` to verify that everything is in order
- commit your recent changes
- `git tag X.Y.Z` where X.Y.Z is your version number
- `git push origin master --tags`
- when ready to release: `pod trunk push Qualaroo.podspec`

#### Owners:
- `Krzysztof K. <krzysztof at qualaroo.com>`