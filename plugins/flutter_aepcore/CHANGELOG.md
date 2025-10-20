## 5.0.1

* Add `MobileCore.setApplication` call in Android FlutterPlugin's `onAttachedToEngine` to accurately register lifecycle callbacks for launcher activity.

## 5.0.0

* Add `MobileCore.initializeWithAppId` and `MobileCore.initialize` APIs to simplify AEP SDK initialization by enabling automatic extension registration and lifecycle tracking.
* Update to use BOM [(Bill of Materials)](https://central.sonatype.com/artifact/com.adobe.marketing.mobile/sdk-bom) for Android SDK dependencies.
* Add Error handling for NSError.
* Update tests to handle the deprecation warning for `setMockMethodCallHandler`.

## 4.0.2

* Update environment dependencies in pubspec.

## 4.0.1

* Add namespace support for Android
* Update Flutter support version to 3.x

## 4.0.0

* Adobe Mobile SDK for iOS 5.x support
* Adobe Mobile SDK for Android 3.x support

## 3.0.0

* Adobe Mobile SDK for iOS 4.x support
* Updated minimum supported version to iOS 11.0

## 2.0.0

* Adobe Mobile SDK for Android 2.x support.
* Fix issues where async calls were not properly completed.

## 1.0.0

* Initial release candidate

