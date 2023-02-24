# flutter_aepedgeconsent

[![pub package](https://img.shields.io/pub/v/flutter_aepedgeconsent.svg)](https://pub.dartlang.org/packages/flutter_aepedgeconsent) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepedgeconsent` is a flutter plugin for the iOS and Android [Adobe Experience Platform Edge Consent SDK](https://developer.adobe.com/client-sdks/documentation/consent-for-edge-network/) to allow for integration with Flutter applications. Functionality to enable the Consent for Edge Network extension is provided entirely through Dart documented below.

## Prerequisites

The Consent extension has the following peer dependency, which must be installed prior to installing it:

- [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md)

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepedgeconsent/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Tests

Run:

```bash
flutter test
```

## Usage

For more detailed information on the Consent APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/consent-for-edge-network/)

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
@import AEPEdgeIdentity;
@import AEPEdgeConsent;
...
@implementation AppDelegate

// AppDelegate.m
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AEPMobileCore setWrapperType:AEPWrapperTypeFlutter];

     // TODO: Set up the preferred Environment File ID from your mobile property configured in Data Collection UI
    NSString* ENVIRONMENT_FILE_ID = @"YOUR-APP-ID";
    
    NSArray *extensionsToRegister = @[AEPMobileEdgeIdentity.class, 
                                      AEPMobileEdge.class,                                              
                                      AEPMobileEdgeConsent.class
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
import com.adobe.marketing.mobile.edge.identity.Identity;
import com.adobe.marketing.mobile.edge.consent.Consent;
  
...
import io.flutter.app.FlutterApplication;
...
public class MainApplication extends FlutterApplication {
  ...
  // TODO: Set up the preferred Environment File ID from your mobile property configured in Data Collection UI
  private final String ENVIRONMENT_FILE_ID = "YOUR-APP-ID";

  @Override
  public void on Create(){
    super.onCreate();
    ...
    MobileCore.setApplication(this);
    MobileCore.setWrapperType(WrapperType.FLUTTER);

    Edge.registerExtension();
    Identity.registerExtension();
    Consent.registerExtension();
    MobileCore.start(new AdobeCallback () {
        @Override
        public void call(Object o) {
          MobileCore.configureWithAppID(ENVIRONMENT_FILE_ID);
        }
   });
```
------
### Importing the SDK:

```dart
import 'package:flutter_aepedgeconsent/flutter_aepedgeconsent.dart';
```
------
## API reference
### extensionVersion
Returns the SDK version of the Consent extension.

**Syntax**
```dart
static Future<String> get extensionVersion
```

**Example**
```dart
String version = await Consent.extensionVersion;
```
------
### getConsents
Retrieves the current consent preferences stored in the Consent extension.

**Syntax**
```dart
static Future<Map<String, dynamic>> get consents
```

**Example**
```dart
Map<String, dynamic> result = {};
    try {
      result = await Consent.consents;
    } on PlatformException {
      log("Failed to get consent info");
    }
```
------
### updateConsents
Merges the existing consents with the given consents. Duplicate keys will take the value of those passed in the API.

**Syntax**
```dart
static Future<void> update(Map<String, dynamic> consents)
```

**Example**
```dart
Map<String, dynamic> collectConsents = allowed
        ? {
            "collect": {"val": "y"}
          }
        : {
            "collect": {"val": "n"}
          };
Map<String, dynamic> currentConsents = {"consents": collectConsents};

Consent.update(currentConsents);
```

## Contributing
See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License
See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
