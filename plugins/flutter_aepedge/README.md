# flutter_aepedge

[![pub package](https://img.shields.io/pub/v/flutter_aepedge.svg)](https://pub.dartlang.org/packages/flutter_aepedge) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepedge` is a flutter plugin for the iOS and Android [AEPedge SDK](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/adobe-experience-platform-edge) to allow for integration with Flutter applications. Functionality to enable the edge extension is provided entirely through Dart documented below.

## Installation

First, make sure that the [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md) plugin is installed, as flutter_aepedge depends on it. 

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepedge/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Tests

Run:

```bash
flutter test
```

## Usage
### edge

For more detailed information on the edge APIs, visit the documentation [here](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/adobe-experience-platform-edge)

##### Registering the extension with AEPCore:

 > Note: It is required to initialize the SDK via native code inside your AppDelegate and MainApplication for iOS and Android respectively.

As part of the initialization code, make sure that you set the SDK wrapper type to `Flutter` before you start the SDK.

Refer to the [Initialization](https://github.com/adobe/aepsdk_flutter#initializing) section of the root README for more information about initializing the SDK.

##### Importing the SDK:
```dart
import 'package:flutter_aepedge/flutter_aepedge.dart';
```

##### Getting edge version:
 ```dart
String version = await edge.extensionVersion;
 ```

## Contributing
See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License
See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
