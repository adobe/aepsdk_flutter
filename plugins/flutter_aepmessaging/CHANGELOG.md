## 6.0.0

* iOS: Swift Package Manager is now the only supported integration. CocoaPods support (the podspec) is removed.
* Minimum supported iOS version is 15.0.
* iOS: Requires Adobe Experience Platform iOS SDKs 6.x.
* Minimum supported Flutter version is 3.47.0.
* iOS: The Objective-C `FlutterAEPMessagingPlugin` registration class is replaced by a Swift class with the same name, because a Swift package target cannot mix Swift and Objective-C.

## 5.1.0
* Fixed Android `refreshInAppMessages` returning `Unit` instead of `null` over the method channel, causing a type mismatch on the Flutter side.

## 5.0.1
* Add a timeout to the call made from native bridge to custom messaging delegate to allow showing the in-app message if no delegate is provided by the app developer. 

## 5.0.0

* Update to use BOM [(Bill of Materials)](https://central.sonatype.com/artifact/com.adobe.marketing.mobile/sdk-bom) for Android SDK dependencies.
* Update tests to handle the deprecation warning for `setMockMethodCallHandler`.

## 4.0.2

* Update environment dependencies in pubspec.

## 4.0.1

* Add namespace support for Android
* Update Flutter support version to 3.x

## 4.0.0

* Adobe Mobile SDK for iOS 5.x support
* Adobe Mobile SDK for Android 3.x support

## 3.0.0-beta.1

* Initial release candidate
