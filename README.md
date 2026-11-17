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
| [Optimize](plugins/flutter_aepoptimize/README.md) | [![pub package](https://img.shields.io/pub/v/flutter_aepoptimize.svg)](https://pub.dartlang.org/packages/flutter_aepoptimize) |

> [!NOTE]  
> The Flutter plugins within this repository are specifically designed to support the Android and iOS platforms only.

## iOS Privacy Manifest

> [!IMPORTANT]  
> Adobe Experience Platform Flutter **4.x** plugins now depend on Experience Platform iOS 5.x SDKs, which have been updated to align with Apple's latest guidelines on [privacy manifest](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files). For further details on how Apple's privacy-related announcements affect the Adobe mobile SDK for iOS, please refer to this [document](https://developer.adobe.com/client-sdks/resources/privacy-manifest/).

## Installation

First, make sure that `Flutter` is [installed](https://docs.flutter.dev/get-started/install).

### Installing using Terminal:

Install the package, run:

```bash
cd MyFlutterApp
flutter pub add flutter_{plugin_name}
```

This will automatically update your package's pubspec.yaml with the dependency, and run an implicit `flutter pub get`.

### Installing Manually:

Alternatively, Editing pubspec.yaml manually with dependencies.

```
dependencies:
  flutter_{plugin_name}: ^{latest_version}
```
Run:

```
flutter pub get
```

#### iOS development

Starting with version 6.0.0, the iOS plugins support [Swift Package Manager](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers) only. CocoaPods is no longer supported.

Requirements:
- Flutter 3.47.0 or later (Swift Package Manager is enabled by default).
- iOS 15.0 or later.
- Adobe Experience Platform iOS SDKs 6.x (resolved automatically).

No extra steps are required: the Adobe Experience Platform iOS SDKs are resolved automatically as Swift packages when you build your app. To update them to the latest compatible versions, use **File > Packages > Update to Latest Package Versions** in Xcode.

If your app uses additional Adobe Experience Platform iOS SDKs from native code (for example, AEPAnalytics), add them with Swift Package Manager too, and remove any `AEP*` pods from your `Podfile`. Integrating the same SDK with both CocoaPods and Swift Package Manager results in duplicate copies of the SDK.
## Importing the Plugin

For both installation methods, you need to import the package in your **Dart** code as follows:

```
import 'package:flutter_{extension}/flutter_{plugin_name}.dart'
```

## Initializing

Then, initialize the SDK using the following methods:
- [MobileCore.initializeWithAppId(appId)](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepcore#initializewithappid)
- [MobileCore.initialize(initOptions)](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepcore#initialize)

> [!NOTE]  
> Starting from Adobe Experience Platform Flutter **5.x**,  there is no longer a need to initialize the SDK on the [native platforms](https://github.com/adobe/aepsdk_flutter/tree/v4.x?tab=readme-ov-file#usage), as was required in earlier versions.

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
