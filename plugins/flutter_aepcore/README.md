# flutter_aepcore

[![pub package](https://img.shields.io/pub/v/flutter_aepcore.svg)](https://pub.dartlang.org/packages/flutter_aepcore) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepcore` is a flutter plugin for the iOS and Android [AEP Core SDK](https://developer.adobe.com/client-sdks/documentation/mobile-core/) to allow for integration with flutter applications. Functionality to enable the Core extension is provided entirely through Dart documented below.

## Contents
- [Installation](#installation)
- [Usage](#usage)
	- [Initializing](#initializing)
	- [Core](#core)
	- [Identity](#identity)
	- [Lifecycle](#lifecycle)
	- [Signal](#signal)
- [Tests](#tests)

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepcore/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Usage

### Initializing

Initializing the SDK should be done in native code (AppDelegate / SceneDelegate for iOS and Application class for Android). Documentation for initializing the SDK can be found [here](https://developer.adobe.com/client-sdks/documentation/getting-started/get-the-sdk/#2-add-initialization-code).

As part of the initialization code, make sure that you set the SDK wrapper type to `Flutter` before you start the SDK.

Refer to the [Initialization](https://github.com/adobe/aepsdk_flutter#initializing) section of the root README for more information about initializing the SDK.

### Core

For more detailed information on the Core APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/mobile-core/)

##### Importing Core:
```dart
import 'package:flutter_aepcore/flutter_aepcore.dart';
```

##### Getting Core version:
 ```dart
String version = await MobileCore.extensionVersion;
 ```

##### Updating the SDK configuration:

```dart
MobileCore.updateConfiguration({"key" : "value"});
```

##### Clearing configuration updates back to original configuration:

```dart
MobileCore.clearUpdatedConfiguration();
```

##### Controlling the log level of the SDK:
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

MobileCore.setLogLevel(LogLevel.error);
MobileCore.setLogLevel(LogLevel.warning);
MobileCore.setLogLevel(LogLevel.debug);
MobileCore.setLogLevel(LogLevel.trace);
```

##### Getting the current privacy status:
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

PrivacyStatus result;

try {
  result = await MobileCore.privacyStatus;
} on PlatformException {
  log("Failed to get privacy status");
}
```

##### Setting the privacy status:
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

MobileCore.setPrivacyStatus(PrivacyStatus.opt_in);
MobileCore.setPrivacyStatus(PrivacyStatus.opt_out);
MobileCore.setPrivacyStatus(PrivacyStatus.unknown);
```

##### Getting the SDK identities:
```dart
String result = "";

try {
  result = await MobileCore.sdkIdentities;
} on PlatformException {
  log("Failed to get sdk identities");
}
```

##### Dispatching an Event Hub event:
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

final Event event = Event({
  "eventName": "testEventName",
  "eventType": "testEventType",
  "eventSource": "testEventSource",
  "eventData": {"eventDataKey": "eventDataValue"}
});
try {
  await MobileCore.dispatchEvent(event);
} on PlatformException catch (e) {
  log("Failed to dispatch event '${e.message}''");
}
```

##### Dispatching an Event Hub event with callback:
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

Event result;
final Event event = Event({
      "eventName": "testEventName",
      "eventType": "testEventType",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });
    try {
      result = await MobileCore.dispatchEventWithResponseCallback(event);
    } on PlatformException catch (e) {
      log("Failed to dispatch event '${e.message}''");
    }
```

##### Reset identities 
```dart
MobileCore.resetIdentities()
```
### Identity

For more information on the Core Identity APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/mobile-core/identity/).

##### Importing Identity:
```dart
import 'package:flutter_aepcore/flutter_aepidentity.dart';
```

##### Getting Identity version:
```dart
String version = await Identity.extensionVersion;
```

##### Sync Identifier:
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

Identity.syncIdentifier("identifierType", "identifier", MobileVisitorAuthenticationState.authenticated);
```

##### Sync Identifiers:
```dart
Identity.syncIdentifiers({"idType1":"idValue1",
                                    "idType2":"idValue2",
                                    "idType3":"idValue3"});
```

##### Sync Identifiers with Authentication State:
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

Identity.syncIdentifiersWithAuthState({"idType1":"idValue1", "idType2":"idValue2", "idType3":"idValue3"}, MobileVisitorAuthenticationState.authenticated);

```

Note: `MobileVisitorAuthenticationState` is defined as:

```dart
enum MobileVisitorAuthenticationState {unknown, authenticated, logged_out}
```

##### Append visitor data to a URL:

```dart
String result = "";

try {
  result = await Identity.appendToUrl("www.myUrl.com");
} on PlatformException {
  log("Failed to append URL");
}
```

##### Setting the advertising identifier:

```dart
MobileCore.setAdvertisingIdentifier("ad-id");
```

##### Get visitor data as URL query parameter string:

```dart
String result = "";

try {
  result = await Identity.urlVariables;
} on PlatformException {
  log("Failed to get url variables");
}
```

##### Get Identifiers:

```dart
List<Identifiable> result;

try {
  result = await Identity.identifiers;
} on PlatformException {
  log("Failed to get identifiers");
}
```

##### Get Experience Cloud IDs:
```dart
String result = "";

try {
  result = await Identity.experienceCloudId;
} on PlatformException {
  log("Failed to get experienceCloudId");
}
```

##### AEPMobileVisitorId Class:
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

class Identifiable {
  String get idOrigin;
  String get idType;
  String get identifier;
  MobileVisitorAuthenticationState get authenticationState;
}
```

### Lifecycle

For more information on the Core Lifecycle APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/mobile-core/lifecycle/)

> Note: It is required to implement Lifecycle in native [Android and iOS code](https://developer.adobe.com/client-sdks/documentation/mobile-core/lifecycle/).

### Signal

For more information on the Core Signal APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/mobile-core/signal/)

##### Importing Signal:
```dart
import 'package:flutter_aepcore/flutter_aepsignal.dart';
```

##### Getting Signal version:
 ```dart
String version = await Signal.extensionVersion;
 ```

## Tests

Run:

```bash
$ cd plugins/flutter_{plugin_name}/
$ flutter test
```

## Contributing
See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License
See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
