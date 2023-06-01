# flutter_aepuserprofile

[![pub package](https://img.shields.io/pub/v/flutter_aepuserprofile.svg)](https://pub.dartlang.org/packages/flutter_aepuserprofile) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepuserprofile` is a flutter plugin for the iOS and Android [Adobe Experience Platform UserProfile SDK](https://developer.adobe.com/client-sdks/documentation/profile/) to allow for integration with Flutter applications. Functionality to enable the UserProfile extension is provided entirely through Dart documented below.

## Installation

First, make sure that the [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md) plugin is installed, as flutter_aepuserprofile depends on it. 

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepuserprofile/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Tests

Run:

```bash
flutter test
```

## Usage
### UserProfile

For more detailed information on the UserProfile APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/profile/api-reference/)

##### Registering the extension with AEPCore:

 > Note: It is required to initialize the SDK via native code inside your AppDelegate and MainApplication for iOS and Android respectively.

As part of the initialization code, make sure that you set the SDK wrapper type to `Flutter` before you start the SDK.

Refer to the [Initialization](https://github.com/adobe/aepsdk_flutter#initializing) section of the root README for more information about initializing the SDK.

##### Importing the SDK:
```dart
import 'package:flutter_aepuserprofile/flutter_aepuserprofile.dart';
```

##### Getting UserProfile version:
 ```dart
String version = await UserProfile.extensionVersion;
 ```

##### Get user profile attributes which match the provided keys:

 ```dart
try {
	String userAttributes = await UserProfile.getUserAttributes(["attr1", "attr2"]);
} on PlatformException {
	log("Failed to get the user attributes");
}
 ```

 ##### Remove provided user profile attributes if they exist:

 ```dart
UserProfile.removeUserAttributes(["attr1", "attr2"]);
 ```

 ##### Set multiple user profile attributes:

 ```dart
UserProfile.updateUserAttributes({"attr1": "attr1Value", "attr2": "attr2Value"});
 ```

## Contributing
See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License
See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
