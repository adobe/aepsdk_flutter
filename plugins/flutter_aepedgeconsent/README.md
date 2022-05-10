# flutter_aepedgeconsent

[![pub package](https://img.shields.io/pub/v/flutter_aepassurance.svg)](https://pub.dartlang.org/packages/flutter_aepedgeconsent) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepedgeconsent` is a flutter plugin for the iOS and Android [AEPEdgeConsent SDK](https://aep-sdks.gitbook.io/docs/foundation-extensions/consent-for-edge-network) to allow for integration with Flutter applications. Functionality to enable the Assurance extension is provided entirely through Dart documented below.

## Installation

First, make sure that the [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md) plugin is installed, as flutter_aepassurance depends on it. 

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepedgeconsent/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Tests

Run:

```bash
flutter test
```

## Usage
### Consent

For more detailed information on the Consent APIs, visit the documentation [here](https://aep-sdks.gitbook.io/docs/foundation-extensions/consent-for-edge-network)

##### Registering the extension with AEPCore:

 > Note: It is required to initialize the SDK via native code inside your AppDelegate and MainApplication for iOS and Android respectively.

As part of the initialization code, make sure that you set the SDK wrapper type to `Flutter` before you start the SDK.

Refer to the [Initialization](https://github.com/adobe/aepsdk_flutter#initializing) section of the root README for more information about initializing the SDK.

##### Importing the SDK:
```dart
import 'package:flutter_aepedgeconsent/flutter_aepedgeconsent.dart';
```

##### Getting Consent version:
 ```dart
String version = await Consent.extensionVersion;
 ```

## Contributing
See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License
See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
