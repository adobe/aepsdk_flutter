# flutter_aepcore

[![pub package](https://img.shields.io/pub/v/flutter_aepcore.svg)](https://pub.dartlang.org/packages/flutter_aepcore) ![Build](https://github.com/adobe/flutter_aepcore/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepcore` is a flutter plugin for the iOS and Android [AEP Core SDK](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/mobile-core) to allow for integration with flutter applications. Functionality to enable the Core extension is provided entirely through Dart documented below.

## Contents
- [Installation](#installation)
- [Tests](#tests)
- [Usage](#usage)
	- [Initializing](#initializing)
	- [Core](#core)
	- [Identity](#identity)
	- [Lifecycle](#lifecycle)
	- [Signal](#signal)

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepcore#-installing-tab-).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

After you have installed Core, you can install additional AEP Flutter extensions.

| Extension    | Package                                            |
| ------------ | ------------------------------------------------------------ |
| Analytics    | [![pub package](https://img.shields.io/pub/v/flutter_aepanalytics.svg)](https://pub.dartlang.org/packages/flutter_aepanalytics) |
| Assurance | [![pub package](https://img.shields.io/pub/v/flutter_assurance.svg)](https://pub.dartlang.org/packages/flutter_assurance) |

## Tests

Run:

```bash
flutter test
```

## Usage

### Initializing:

Initializing the SDK should be done in native code, documentation on how to initalize the SDK can be found [here](https://aep-sdks.gitbook.io/docs/getting-started/get-the-sdk#2-add-initialization-code). The linked documentation initalizes the User Profile extension which is not required or supported in Flutter. 

Once you have added the initialization code to your app, be sure to set the SDK wrapper type to Flutter before you start the SDK.

###### iOS:
Swift:
```swift
AEPCore.setWrapperType(.flutter)
```

Objective-C:
```objective-c
[AEPCore setWrapperType:AEPMobileWrapperTypeFlutter];
```

###### Android:
```java
MobileCore.setWrapperType(WrapperType.FLUTTER);
```

### [Core](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/mobile-core)

##### Importing Core:
```dart
import 'package:flutter_aepcore/flutter_aepcore.dart';
```

##### Getting Core version:
 ```dart
String version = await FlutterAEPCore.extensionVersion;
 ```

##### Updating the SDK configuration:

```dart
FlutterAEPCore.updateConfiguration({"key" : "value"});
```

##### Controlling the log level of the SDK:
```dart
import 'package:flutter_aepcore/src/aepmobile_logging_level.dart';

FlutterAEPCore.setLogLevel(AEPLoggingLevel.ERROR);
FlutterAEPCore.setLogLevel(AEPLoggingLevel.WARNING);
FlutterAEPCore.setLogLevel(AEPLoggingLevel.DEBUG);
FlutterAEPCore.setLogLevel(AEPLoggingLevel.VERBOSE);
```

##### Getting the current privacy status:
```dart
import 'package:flutter_aepcore/src/aepmobile_privacy_status.dart';

AEPPrivacyStatus result;

try {
  result = await FlutterAEPCore.privacyStatus;
} on PlatformException {
  log("Failed to get privacy status");
}
```

##### Setting the privacy status:
```dart
import 'package:flutter_aepcore/src/aepmobile_privacy_status.dart';

FlutterAEPCore.setPrivacyStatus(AEPPrivacyStatus.OPT_IN);
FlutterAEPCore.setPrivacyStatus(AEPPrivacyStatus.OPT_OUT);
FlutterAEPCore.setPrivacyStatus(AEPPrivacyStatus.UNKNOWN);
```

##### Getting the SDK identities:
```dart
String result = "";

try {
  result = await FlutterAEPCore.sdkIdentities;
} on PlatformException {
  log("Failed to get sdk identities");
}
```

##### Dispatching an Event Hub event:
```dart
import 'package:flutter_aepcore/src/aepextension_event.dart';

final AEPExtensionEvent event = AEPExtensionEvent.createEvent("eventName", "eventType", "eventSource", {"testDataKey": "testDataValue"});

bool result;
try {
  result = await FlutterAEPCore.dispatchEvent(event);
} on PlatformException catch (e) {
  log("Failed to dispatch event '${e.message}''");
}
```

##### Dispatching an Event Hub event with callback:
```dart
import 'package:flutter_aepcore/src/aepextension_event.dart';

AEPExtensionEvent result;
final AEPExtensionEvent event AEPExtensionEvent.createEvent("eventName", "eventType", "eventSource", {"testDataKey": "testDataValue"});

try {
  result = await FlutterAEPCore.dispatchEventWithResponseCallback(event);
} on PlatformException catch (e) {
  log("Failed to dispatch event '${e.message}''");
}
```

##### Dispatching an Event Hub response event:
```dart
import 'package:flutter_aepcore/src/aepextension_event.dart';

bool result;
final AEPExtensionEvent responseEvent = AEPExtensionEvent.createEvent("eventName", "eventType", "eventSource", {"testDataKey": "testDataValue"});
final AEPExtensionEvent requestEvent = AEPExtensionEvent.createEvent("eventName", "eventType", "eventSource", {"testDataKey": "testDataValue"});

try {
  result = await FlutterAEPCore.dispatchResponseEvent(responseEvent, requestEvent);
} on PlatformException catch (e) {
  log("Failed to dispatch events '${e.message}''");
}
```

### [Identity](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/mobile-core/identity)
##### Importing Identity:
```dart
import 'package:flutter_aepcore/flutter_aepidentity.dart';
```

##### Getting Identity version:
```dart
String version = await FlutterAEPIdentity.extensionVersion;
```

##### Sync Identifier:
```dart
import 'package:flutter_aepcore/src/aepmobile_visitor_id.dart';

FlutterAEPIdentity.syncIdentifier("identifierType", "identifier", AEPMobileVisitorAuthenticationState.AUTHENTICATED);
```

##### Sync Identifiers:
```dart
FlutterAEPIdentity.syncIdentifiers({"idType1":"idValue1",
                                    "idType2":"idValue2",
                                    "idType3":"idValue3"});
```

##### Sync Identifiers with Authentication State:
```dart
import 'package:flutter_aepcore/src/aepmobile_visitor_id.dart';

FlutterAEPIdentity.syncIdentifiersWithAuthState({"idType1":"idValue1", "idType2":"idValue2", "idType3":"idValue3"}, AEPMobileVisitorAuthenticationState.AUTHENTICATED);

```

Note: `AEPMobileVisitorAuthenticationState` is defined as:

```dart
enum AEPMobileVisitorAuthenticationState {UNKNOWN, AUTHENTICATED, LOGGED_OUT}
```

##### Append visitor data to a URL:

```dart
String result = "";

try {
  result = await FlutterAEPIdentity.appendToUrl("www.myUrl.com");
} on PlatformException {
  log("Failed to append URL");
}
```

##### Setting the advertising identifier:

```dart
FlutterAEPCore.setAdvertisingIdentifier("ad-id");
```

##### Get visitor data as URL query parameter string:

```dart
String result = "";

try {
  result = await FlutterAEPIdentity.urlVariables;
} on PlatformException {
  log("Failed to get url variables");
}
```

##### Get Identifiers:

```dart
List<AEPMobileVisitorId> result;

try {
  result = await FlutterAEPIdentity.identifiers;
} on PlatformException {
  log("Failed to get identifiers");
}
```

##### Get Experience Cloud IDs:
```dart
String result = "";

try {
  result = await FlutterAEPIdentity.experienceCloudId;
} on PlatformException {
  log("Failed to get experienceCloudId");
}
```

##### AEPMobileVisitorId Class:
```dart
import 'package:flutter_aepcore/src/aepmobile_visitor_id.dart';

class AEPMobileVisitorId {
  String get idOrigin;
  String get idType;
  String get identifier;
  AEPMobileVisitorAuthenticationState get authenticationState;
}
```

### [Lifecycle](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/mobile-core/lifecycle)

> Note: It is required to implement Lifecycle in native [Android and iOS code](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/mobile-core/lifecycle).

### [Signal](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/mobile-core/signals)
##### Importing Signal:
```dart
import 'package:flutter_aepcore/flutter_aepsignal.dart';
```

##### Getting Signal version:
 ```dart
String version = await FlutterAEPSignal.extensionVersion;
 ```


## Contributing
See [CONTRIBUTING](CONTRIBUTING.md)

## License
See [LICENSE](LICENSE)
