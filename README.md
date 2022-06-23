# aepsdk-flutter

## About this project

This repository is a monorepo. It contains a collection of Adobe Experience Platform Mobile SDK Flutter plugins listed below. These plugins can be found in the [plugins](./plugins) directory.

| Extension    | Package                                            |
| ------------ | ------------------------------------------------------------ |
| [Core](plugins/flutter_aepcore/README.md) (required)    | [![pub package](https://img.shields.io/pub/v/flutter_aepcore.svg)](https://pub.dartlang.org/packages/flutter_aepcore) |
| [Assurance](plugins/flutter_aepassurance/README.md) | [![pub package](https://img.shields.io/pub/v/flutter_aepassurance.svg)](https://pub.dartlang.org/packages/flutter_aepassurance) |
| [Consent](plugins/flutter_aepconsent/README.md) | [![pub package](https://img.shields.io/pub/v/flutter_aepconsent.svg)](https://pub.dartlang.org/packages/flutter_aepconsent) |

## Installation

First, make sure that `Flutter` is [installed](https://docs.flutter.dev/get-started/install).

Now to install the package, run:

```
$ cd MyFlutterApp
$ flutter pub add flutter_{plugin_name}
```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```
dependencies:
  flutter_{plugin_name}: ^1.0.0
```

Now import the plugin in your Dart code as follows:

```
import 'package:flutter_{extension}/flutter_{plugin_name}.dart'
```

Install instructions for each respective plugin can be found in each plugin's readme: `/plugins/{plugin_name}/README.md`. Start by installing `flutter_aepcore` which is a dependency for all other extensions.

## Usage

### Initializing

Initializing the SDK should be done in native code (AppDelegate / SceneDelegate for iOS and Application class for Android). Documentation for initializing the SDK can be found [here](https://aep-sdks.gitbook.io/docs/getting-started/get-the-sdk#2-add-initialization-code). The linked documentation initalizes the User Profile extension which is not required or supported in Flutter.

As part of the initialization code, make sure that you set the SDK wrapper type to `Flutter` before you start the SDK.

### iOS:

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

See [Contributing](CONTRIBUTING.md)

## License

See [License](LICENSE)
