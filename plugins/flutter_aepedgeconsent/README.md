# flutter_aepedgeconsent

[![pub package](https://img.shields.io/pub/v/flutter_aepedgeconsent.svg)](https://pub.dartlang.org/packages/flutter_aepedgeconsent) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepedgeconsent` is a flutter plugin for the iOS and Android [Adobe Experience Platform Edge Consent SDK](https://developer.adobe.com/client-sdks/documentation/consent-for-edge-network/) to allow for integration with Flutter applications. Functionality to enable the Consent for Edge Network extension is provided entirely through Dart documented below.

## Prerequisites

The Consent extension has the following peer dependency, which must be installed prior to installing it:

- [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md)

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepedgeconsent/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Usage

For more detailed information on the Consent APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/consent-for-edge-network/)

------
### Registering the extension with AEPCore:

To initialize the SDK, use <br>
[MobileCore.initializeWithAppId(appId)](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepcore#dispatching-an-event-hub-event-with-callback) or <br>
[MobileCore.initializeWithAppId(initOptions)](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepcore#dispatching-an-event-hub-event-with-callback#initialize) methods.

Refer to the [Initialization](https://github.com/adobe/aepsdk_flutter#initializing) section of the root README for more information about initializing the SDK.

------
### Importing the SDK:

```dart
import 'package:flutter_aepedgeconsent/flutter_aepedgeconsent.dart';
```
------
## API reference
### extensionVersion
Returns the SDK version of the Consent extension.

**Syntax**
```dart
static Future<String> get extensionVersion
```

**Example**
```dart
String version = await Consent.extensionVersion;
```
------
### getConsents
Retrieves the current consent preferences stored in the Consent extension.

**Syntax**
```dart
static Future<Map<String, dynamic>> get consents
```

**Example**
```dart
Map<String, dynamic> result = {};
    try {
      result = await Consent.consents;
    } on PlatformException {
      log("Failed to get consent info");
    }
```
------
### updateConsents
Merges the existing consents with the given consents. Duplicate keys will take the value of those passed in the API.

**Syntax**
```dart
static Future<void> update(Map<String, dynamic> consents)
```

**Example**
```dart
Map<String, dynamic> collectConsents = allowed
        ? {
            "collect": {"val": "y"}
          }
        : {
            "collect": {"val": "n"}
          };
Map<String, dynamic> currentConsents = {"consents": collectConsents};

Consent.update(currentConsents);
```

## Tests

Run:

```bash
flutter test
```

## Contributing
See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License
See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
