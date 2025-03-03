# flutter_aepmessaging

[![pub package](https://img.shields.io/pub/v/flutter_aepmessaging.svg)](https://pub.dartlang.org/packages/flutter_aepmessaging) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepmessaging` is a flutter plugin for the iOS and Android [AEPMessaging SDK](https://developer.adobe.com/client-sdks/documentation/adobe-journey-optimizer/) to allow for integration with Flutter applications. Functionality to enable the Messaging extension is provided entirely through Dart documented below.

## Prerequisites

The Adobe Experience Platform Messaging extension has the following peer dependency, which must be installed prior to installing it:

- [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md)
- [flutter_aepedge](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepedge/README.md)
- [flutter_aepedgeidentity](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepedgeidentity/README.md)

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepmessaging/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Usage

For more detailed information on the Messaging APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/adobe-journey-optimizer/api-reference/)


### Importing the extension

In your Flutter application, import the Messaging extension as follows:

```dart
import 'package:flutter_aepmessaging/flutter_aepmessaging.dart';
```

### Initializing with SDK:

To initialize the SDK use <br>
[MobileCore.initializeWithAppId(appId)](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepcore#initializewithappid) or <br>
[MobileCore.initialize(initOptions)](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepcore#initialize) methods.

Refer to the root [Readme](https://github.com/adobe/aepsdk_flutter/blob/main/README.md) for more information about the SDK setup.


## API reference

### extensionVersion

Returns the SDK version of the Messaging extension.

**Syntax**

```dart
static Future<String> get extensionVersion
```

**Example**

```dart
String version = await Messaging.extensionVersion;
```

---

### getCachedMessages

Returns a list of messages that have currently been cached in-memory using `Messaging.saveMessage()`

**Syntax**

```dart
List<Message> messages = await Messaging.getCachedMessages();
```

---

### refreshInAppMessages

This API retrieves the Experience Cloud ID (ECID) that was generated when the app was initially launched. This ID is preserved between app upgrades, is saved and restored during the standard application backup process, and is removed at uninstall.

**Syntax**

```dart
static Future<void> refreshInAppMessages
```

**Example**

```dart
await Messaging.refreshInAppMessages();
```

## Handling In App Messages using Message Object

> Note: In order to use the methods defined in the Message class, use `getCachedMessages` to retrieve the messages that have been cached in-memory, and then use the Message objects returned.

The `Message` object passed to the `MessagingDelegate` contains the following functions to handle a message:

### show

Signals to the `UIService` that the message should be displayed.

**Syntax**

```dart
show()
```

**Example**

```dart
Message message
message.show()
```

### dismiss

Signals to the `UIService` that the message should be dismissed.

**Syntax**

```dart
dismiss(((suppressAutoTrack: ?boolean) = false))
```

**Example**

```dart
Message message
message.dismiss(true)
```

### track

Generates an Edge Event for the provided interaction and event type.

**Syntax**

```dart
track(String interaction, MessagingEdgeEventType eventType)
```

**Example**

```dart
Message message;
message.track("sample text", MessagingEdgeEventType.IN_APP_DISMISS)
```

### setAutoTrack

Enables/Disables auto-tracking for message events.

**Syntax**

```dart
setAutoTrack(Bool autoTrack)
```

**Example**

```dart
Message message;
message.setAutoTrack(true)
```

### clear

Clears the reference to the in-memory cached `Message` object. This function must be called if a message was saved by calling `shouldSaveMessage` but no longer needed. Failure to call this function leads to memory leaks.

**Syntax**

```dart
clear()
```

**Example**

```dart
Message message
message.clear()
```
## Push Notification Setup

Handling push notifications must be done in native (Android/iOS) code for the Flutter app. To configure push notifications in the native project, follow the instructions provided for their respective platforms:

- [Apple - iOS push notification setup](https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns)
- [Google - Android push notification setup](https://firebase.google.com/docs/cloud-messaging/android/client)

## Push Messaging APIs usage

The AEPMessaging extension's push messaging APIs must be called from the native Android/iOS project of Flutter app.

###### [iOS API usage](https://github.com/adobe/aepsdk-messaging-ios/blob/main/Documentation/sources/usage.md)

##### [Android API usage](https://github.com/adobe/aepsdk-messaging-android/blob/main/Documentation/sources/api-usage.md)

In Android, [MessagingPushPayload](https://github.com/adobe/aepsdk-messaging-android/blob/main/Documentation/sources/messaging-push-payload.md#messagingpushpayload-usage) can be used for getting the notification attributes like title, body, and action. These are useful for push notification creation.

## Tests

Run:

```bash
flutter test
```

## Contributing

See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License

See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
