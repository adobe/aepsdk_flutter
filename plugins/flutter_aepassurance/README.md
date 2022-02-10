# flutter_aepassurance

[![pub package](https://img.shields.io/pub/v/flutter_aepassurance.svg)](https://pub.dartlang.org/packages/flutter_aepassurance) ![Build](https://github.com/adobe/flutter_aepassurance/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepassurance` is a flutter plugin for the iOS and Android [AEPAssurance SDK](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/adobe-experience-platform-assurance) to allow for integration with Flutter applications. Functionality to enable the Assurance extension is provided entirely through Dart documented below.

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepassurance/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Tests

Run:

```bash
flutter test
```

## Usage
### [Assurance](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/adobe-experience-platform-assurance)

##### Registering the extension with ACPCore:

 > Note: It is required to initialize the SDK via native code inside your AppDelegate and MainApplication for iOS and Android respectively. For more information see how to initialize [Core](https://aep-sdks.gitbook.io/docs/getting-started/initialize-the-sdk).

 ##### **iOS**
Swift
 ```swift
import AEPAssurance

AEPAssurance.registerExtension()
 ```
Objective-C
 ```objective-c
#import "AEPAssurance.h"

[AEPAssurance registerExtension];
 ```

 ##### **Android:**
 ```java
import com.adobe.marketing.mobile.Assurance;

Assurance.registerExtension();
 ```

##### Importing the SDK:
```dart
import 'package:flutter_aepassurance/flutter_aepassurance.dart';
```

##### Getting Assurance version:
 ```dart
String version = await FlutterAssurance.extensionVersion;
 ```

##### Starting a Assurance session:
 ```dart
FlutterAssurance.startSession(url);
 ```


## Contributing
See [CONTRIBUTING](CONTRIBUTING.md)

## License
See [LICENSE](LICENSE)
