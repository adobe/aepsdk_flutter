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

After installing the plugin packages via `flutter pub get`, native iOS dependencies are managed via Swift Package Manager (SPM).

1.  **Add `AdobeFlutterSDK` to Xcode**: In your Xcode project (`ios/Runner.xcodeproj`), add the local `AdobeFlutterSDK` package. Go to `File > Add Packages...`, select "Add Local...", and navigate to the `AdobeLibrary/aepsdk_flutter` folder. Select the `AdobeFlutterSDK` product to be added to your `Runner` target.
2.  **Xcode handles dependency resolution**: Xcode will automatically fetch and manage the external Adobe SDKs (e.g., AEPCore) defined in `AdobeLibrary/aepsdk_flutter/Package.swift`.
3.  **Clean and Build**: Ensure a clean build in Xcode (`Product > Clean Build Folder`) before building (`Product > Build`) or running your application.


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

# Swift Package Manager (SPM) Integration Guide

This section outlines the process of migrating the Adobe Flutter SDK plugins from CocoaPods to Swift Package Manager (SPM) for iOS integration.

## Migration from CocoaPods to SPM (iOS)

To switch the native iOS dependency management for these plugins from CocoaPods to SPM, the following steps were performed:

1.  **SPM-Compatible Plugin Structure**:
    *   Each `flutter_aep*` plugin (`flutter_aepcore`, `flutter_aepassurance`, etc.) within `plugins/` was configured with a `Package.swift` file in its `ios/` directory (e.g., `plugins/flutter_aepcore/ios/Package.swift`).
    *   These individual `Package.swift` files defined the plugin's native code target(s), declared dependencies on external Adobe iOS SDKs (e.g., `AEPCore`, `AEPAssurance`), and specified `publicHeadersPath: "."` for Objective-C headers.
    *   Mixed-language targets (e.g., `flutter_aepmessaging` which had Swift and Objective-C files) were split into separate Objective-C and Swift targets within their `Package.swift`, requiring manual segregation of source files into `ObjC` and `Swift` subdirectories.

2.  **Consolidated `Package.swift` for Local Integration**:
    *   To simplify integration into the main Flutter project, a single, consolidated `Package.swift` was created at the root of `AdobeLibrary/aepsdk_flutter/Package.swift`.
    *   This root `Package.swift` defines a top-level product (`AdobeFlutterSDK`) that includes all `flutter_aep*` targets. It also declares all external Adobe iOS SDKs as its own package dependencies. This allows the main Xcode project to add just *one* local package (`AdobeFlutterSDK`) instead of each individual plugin.

3.  **Flutter `pubspec.yaml` Configuration**:
    *   The main Flutter project's `pubspec.yaml` was updated to use `path` dependencies for all `flutter_aep*` plugins, pointing to their local directories within `AdobeLibrary/aepsdk_flutter/plugins/`. This ensures Flutter's Dart side correctly resolves the plugins.
    *   Inter-plugin dependencies (e.g., `flutter_aepassurance` depending on `flutter_aepcore`) were also updated to `path` dependencies within their respective `pubspec.yaml` files.
    *   The `config: enable-swift-package-manager: true` flag was **removed** from the main `pubspec.yaml` to prevent Flutter from attempting its own problematic SPM wrapper generation (`FlutterGeneratedPluginRegistrant`), relying instead on manual Xcode integration.

4.  **Xcode Integration Steps (Manual)**:
    *   **Remove CocoaPods remnants**: Delete `ios/Podfile`, `ios/Podfile.lock`, `ios/Gemfile`, `ios/Gemfile.lock`, and `ios/Runner.xcworkspace`. Clean up "Pods"-related entries in `ios/.gitignore` and `ios/Flutter/*.xcconfig`.
    *   **Clear Xcode Caches**: Remove all existing Swift Package Dependencies, clear Xcode's SPM caches (`File > Packages > Reset Package Caches`), and delete Derived Data (`File > Project Settings... > Derived Data > Delete`).
    *   **Add Local Package**: In Xcode, `File > Add Packages...`, then "Add Local..." and select the `AdobeLibrary/aepsdk_flutter` directory.
    *   **Select Product(s)**: In the "Choose Package Products" dialog, select the `AdobeFlutterSDK` product (or individual `flutter_aep*` products if not using the consolidated approach) and add it to the `Runner` target.
    *   **GitHub Authentication**: Ensure Xcode is correctly authenticated to GitHub (e.g., via SSH keys or PATs in Xcode's Accounts) to fetch external Adobe SDK dependencies.
    *   **Clean and Build**: Perform `Product > Clean Build Folder` and `Product > Build`.

By following these steps, the Adobe Flutter SDK plugins can be successfully integrated into an iOS Flutter project using Swift Package Manager, completely replacing CocoaPods for their native dependencies.
