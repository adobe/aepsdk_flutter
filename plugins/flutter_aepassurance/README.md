# flutter_aepassurance

[![pub package](https://img.shields.io/pub/v/flutter_aepassurance.svg)](https://pub.dartlang.org/packages/flutter_aepassurance) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepassurance` is a flutter plugin for the iOS and Android [Adobe Experience Platform Assurance SDK](https://developer.adobe.com/client-sdks/documentation/platform-assurance/) to allow for integration with Flutter applications. Functionality to enable the Assurance extension is provided entirely through Dart documented below.

## Installation

First, make sure that the [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md) plugin is installed, as flutter_aepassurance depends on it. 

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepassurance/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Usage

For more detailed information on the Assurance APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/platform-assurance/)

### Importing the extension:
```dart
import 'package:flutter_aepassurance/flutter_aepassurance.dart';
```
### Initializing with AEPCore:

Then initialize the SDK use <br>
[MobileCore.initializeWithAppId(appId)](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepcore#initializewithappid) or <br>
[MobileCore.initialize(initOptions)](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepcore#initialize) methods.

Refer to the root [Readme](https://github.com/adobe/aepsdk_flutter) for more information about the SDK setup.

## API reference

### extensionVersion
Returns the SDK version of the Assurance extension.

**Syntax**
```dart
static Future<String> get extensionVersion
```
**Example**
```dart
String version = await Assurance.extensionVersion;
```

### startSession
Starting a Assurance session:

**Syntax**
```
static Future<void> startSession(String url)
```
**Example**
```dart
Assurance.startSession(url);
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
