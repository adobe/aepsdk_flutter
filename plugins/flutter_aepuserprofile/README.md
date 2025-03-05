# flutter_aepuserprofile

[![pub package](https://img.shields.io/pub/v/flutter_aepuserprofile.svg)](https://pub.dartlang.org/packages/flutter_aepuserprofile) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepuserprofile` is a flutter plugin for the iOS and Android [Adobe Experience Platform UserProfile SDK](https://developer.adobe.com/client-sdks/documentation/profile/) to allow for integration with Flutter applications. Functionality to enable the UserProfile extension is provided entirely through Dart documented below.

## Prerequisites

The Userprofile plugin has the following peer dependency, which must be installed prior to installing it:

- [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md)

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepuserprofile/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Usage

For more detailed information on the UserProfile APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/profile/api-reference/)

### Importing the extension:

In your Flutter application, import the Userprofile package as follows:

```dart
import 'package:flutter_aepuserprofile/flutter_aepuserprofile.dart';
```
### Initializing with SDK:

To initialize the SDK, use the following methods:
- [MobileCore.initializeWithAppId(appId)](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepcore#initializewithappid)
- [MobileCore.initialize(initOptions)](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepcore#initialize)

Refer to the root [Readme](https://github.com/adobe/aepsdk_flutter/blob/main/README.md) for more information about the SDK setup.

## API reference

### extensionVersion
Returns the SDK version of the User Proilfe extension.

**Syntax**
```dart
static Future<String> get extensionVersion
```
**Example**
```dart
String version = await UserProfile.extensionVersion;
```

### getUserAttributes
Get user profile attributes which match the provided keys.

**Syntax**
```dart
static Future<String> getUserAttributes(List<String> attributeKeys)
```

**Example**
```dart
try {
	String userAttributes = await UserProfile.getUserAttributes(["attr1", "attr2"]);
} on PlatformException {
	log("Failed to get the user attributes");
}
```

### removeUserAttributes
Remove provided user profile attributes if they exist.

**Syntax**
```dart
static Future<void> removeUserAttributes(List<String> attributeName)
```

**Example**
 ```dart
UserProfile.removeUserAttributes(["attr1", "attr2"]);
 ```

### updateUserAttributes
Set multiple user profile attributes.

**Syntax**
```dart
static Future<void> updateUserAttributes(Map<String, Object> attributeMap)
```

**Example**
 ```dart
UserProfile.updateUserAttributes({"attr1": "attr1Value", "attr2": "attr2Value"});
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
