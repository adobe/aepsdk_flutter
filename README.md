# aepsdk-flutter

## About this project

This repository is a monorepo. It contains a collection of Adobe Experience Platform Mobile SDK Flutter plugins listed below. These plugins can be found in the [plugins](./plugins) directory.

| Extension    | Package                                            |
| ------------ | ------------------------------------------------------------ |
| [Core](plugins/flutter_aepcore/README.md) (required)    | [![pub package](https://img.shields.io/pub/v/flutter_aepcore.svg)](https://pub.dartlang.org/packages/flutter_aepcore) |
| [Assurance](plugins/flutter_aepassurance/README.md) | [![pub package](https://img.shields.io/pub/v/flutter_aepassurance.svg)](https://pub.dartlang.org/packages/flutter_aepassurance) |
| [Edge](plugins/flutter_aepedge/README.md) | [![pub package](https://img.shields.io/pub/v/flutter_aepedge.svg)](https://pub.dartlang.org/packages/flutter_aepedge) |
| [Consent](plugins/flutter_aepedgeconsent/README.md) | [![pub package](https://img.shields.io/pub/v/flutter_aepedgeconsent.svg)](https://pub.dartlang.org/packages/flutter_aepedgeconsent) |
| [EdgeIdentity](plugins/flutter_aepedgeidentity/README.md) | [![pub package](https://img.shields.io/pub/v/flutter_aepedgeidentity.svg)](https://pub.dartlang.org/packages/flutter_aepedgeidentity) |
| [EdgeBridge](plugins/flutter_aepedgebridge/README.md) | [![pub package](https://img.shields.io/pub/v/flutter_aepedgebridge.svg)](https://pub.dartlang.org/packages/flutter_aepedgebridge) |
| [UserProfile](plugins/flutter_aepuserprofile/README.md) | [![pub package](https://img.shields.io/pub/v/flutter_aepuserprofile.svg)](https://pub.dartlang.org/packages/flutter_aepuserprofile) |
| [Messaging](plugins/flutter_aepmessaging/README.md) | [![pub package](https://img.shields.io/pub/v/flutter_aepmessaging.svg)](https://pub.dartlang.org/packages/flutter_aepmessaging) |

## iOS Privacy Manifest

> [!IMPORTANT]  
> Adobe Experience Platform Flutter **4.x** plugins now depend on Experience Platform iOS 5.x SDKs, which have been updated to align with Apple's latest guidelines on [privacy manifest](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files). For further details on how Apple's privacy-related announcements affect the Adobe mobile SDK for iOS, please refer to this [document](https://developer.adobe.com/client-sdks/resources/privacy-manifest/).

## Installation

First, make sure that `Flutter` is [installed](https://docs.flutter.dev/get-started/install).

Now to install the package, run:

```bash
cd MyFlutterApp
flutter pub add flutter_{plugin_name}
```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```
dependencies:
  flutter_{plugin_name}: ^{latest_version}
```

Now import the plugin in your Dart code as follows:

```
import 'package:flutter_{extension}/flutter_{plugin_name}.dart'
```

Install instructions for each respective plugin can be found in each plugin's readme: `/plugins/{plugin_name}/README.md`. Start by installing `flutter_aepcore` which is a dependency for all other extensions.

## Usage

### Initializing

Initializing the SDK should be done in native code (AppDelegate / SceneDelegate for iOS and Application class for Android). Documentation for initializing the SDK can be found [here](https://developer.adobe.com/client-sdks/documentation/getting-started/get-the-sdk/#2-add-initialization-code). The linked documentation initalizes the User Profile extension which is not required or supported in Flutter.

As part of the initialization code, make sure that you set the SDK wrapper type to `Flutter` before you start the SDK.

#### iOS:

Add the initialization code in [AppDelegate.m or AppDelegate.swift](/example/ios/Runner/AppDelegate.m#L9) file of the generated iOS project.

#### Android: 
Create an [Application class](/example/android/app/src/main/java/com/adobe/marketing/mobile/flutter/flutter_aepsdk_example/MyApplication.java) which extends [FlutterApplication](https://api.flutter.dev/javadoc/io/flutter/app/FlutterApplication.html) and add the initialization code. Change your [AndroidManifest.xml](/example/android/app/src/main/AndroidManifest.xml#L9) to reference this new class. 

Once you have added the initialization code to your app, be sure to set the SDK wrapper type to Flutter before you start the SDK.

###### iOS:
Swift:
```swift
MobileCore.setWrapperType(.flutter)
```

Objective-C:
```objective-c
[AEPMobileCore setWrapperType:AEPWrapperTypeFlutter];
```

###### Android:
```java
MobileCore.setWrapperType(WrapperType.FLUTTER);
```

## Tests

Run:

```
$ cd plugins/flutter_{plugin_name}/
$ flutter test
```

## Contributing

If you are creating a plugin for an AEP-prefix (Swift) library, please follow the steps [outlined here](docs/creating_new_plugins.md)

For all other information on contributing see [Contributing](CONTRIBUTING.md)

## Documentation

Additional documentation about migrating from older Flutter libraries (ACP-prefixed Flutter libraries) to the latest Flutter libraries (AEP-prefixed libraries) can be found [here](./docs/migration.md)

## License

See [License](LICENSE)
