# flutter_aepmessaging

[![pub package](https://img.shields.io/pub/v/flutter_aepmessaging.svg)](https://pub.dartlang.org/packages/flutter_aepmessaging) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepmessaging` is a flutter plugin for the iOS and Android [AEPMessaging SDK](https://developer.adobe.com/client-sdks/documentation/adobe-journey-optimizer/) to allow for integration with Flutter applications. Functionality to enable the Messaging extension is provided entirely through Dart documented below.

## Prerequisites

The Adobe Experience Platform Messaging extension has the following peer dependency, which must be installed prior to installing it:

- [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md)

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepmessaging/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Tests

Run:

```bash
flutter test
```

## Usage

For more detailed information on the Messaging APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/adobe-journey-optimizer/api-reference/)

### Registering the extension with AEPCore:

> Note: It is required to initialize the SDK via native code inside your AppDelegate (iOS) and MainApplication class (Android).

As part of the initialization code, make sure that you set the SDK wrapper type to `Flutter` before you start the SDK.

Refer to the [Initialization](https://github.com/adobe/aepsdk_flutter#initializing) section of the root README for more information about initializing the SDK.

**Initialization Example**

iOS

```objc
// AppDelegate.h
@import AEPCore;
@import AEPEdge;
@import AEPMessaging;
...
@implementation AppDelegate

// AppDelegate.m
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AEPMobileCore setWrapperType:AEPWrapperTypeFlutter];

     // TODO: Set up the preferred Environment File ID from your mobile property configured in Data Collection UI
    NSString* ENVIRONMENT_FILE_ID = @'YOUR-APP-ID';

    NSArray *extensionsToRegister = @[AEPMessaging.class,
                                      AEPMobileEdge.class
                                      ];

    [AEPMobileCore registerExtensions:extensionsToRegister completion:^{
    [AEPMobileCore configureWithAppId: ENVIRONMENT_FILE_ID];
    }];
    return YES;
 }
```

Android

```java
import com.adobe.marketing.mobile.MobileCore;
import com.adobe.marketing.mobile.Edge;
import com.adobe.marketing.mobile.messaging.Messaging;
...
import io.flutter.app.FlutterApplication;
...
public class MainApplication extends FlutterApplication {
  ...
  // TODO: Set up the preferred Environment File ID from your mobile property configured in Data Collection UI
   private final String ENVIRONMENT_FILE_ID = "YOUR-APP-ID";

    @Override
    public void onCreate() {
      super.onCreate();
      List<Class<? extends Extension>> extensions = Arrays.asList(   
              Edge.EXTENSION,
              Messaging.EXTENSION
      );
      MobileCore.registerExtensions(extensions, o -> MobileCore.configureWithAppID(ENVIRONMENT_FILE_ID));
    }
}
```

---

### Importing the extension

In your Flutter application, import the Messaging extension as follows:

```dart
import 'package:flutter_aepmessaging/flutter_aepmessaging.dart';
```

---

## API reference

### extensionVersion

Returns the SDK version of the Messaging extension.

**Syntax**

```dart
static Future<String> get extensionVersion
```

**Example**

```dart
String version = await Messaging.extensionVersion;
```

---

### refreshInAppMessages

This API retrieves the Experience Cloud ID (ECID) that was generated when the app was initially launched. This ID is preserved between app upgrades, is saved and restored during the standard application backup process, and is removed at uninstall.

**Syntax**

```dart
static Future<void> refreshInAppMessages
```

**Example**

```dart
await Messaging.refreshInAppMessages();
```


## Contributing

See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License

See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
