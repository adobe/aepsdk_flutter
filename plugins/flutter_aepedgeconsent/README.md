# flutter_aepedgeconsent

[![pub package](https://img.shields.io/pub/v/flutter_aepedgeconsent.svg)](https://pub.dartlang.org/packages/flutter_aepedgeconsent) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepedgeconsent` is a flutter plugin for the iOS and Android [AEPEdgeConsent SDK](https://aep-sdks.gitbook.io/docs/foundation-extensions/consent-for-edge-network) to allow for integration with Flutter applications. Functionality to enable the Consent extension is provided entirely through Dart documented below.

## Installation

First, make sure that the [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md) plugin is installed, as flutter_aepedgeconsent depends on it. 

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepedgeconsent/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Tests

Run:

```bash
flutter test
```

## Usage
### Consent

For more detailed information on the Consent APIs, visit the documentation [here](https://aep-sdks.gitbook.io/docs/foundation-extensions/consent-for-edge-network)

#### Registering the extension with AEPCore:

 > Note: It is required to initialize the SDK via native code inside your AppDelegate and MainApplication for iOS and Android respectively.

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
    
    const UIApplicationState appState = application.applicationState;

    NSArray *extensionsToRegister = @[AEPMobileIdentity.class, 
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
    MobileCore.setLogLevel(LoggingMode.DEBUG);
    MobileCore.setWrapperType(WrapperType.FLUTTER);

    try {
        Edge.registerExtension();
        Identity.registerExtension();
        Consent.registerExtension();
        MobileCore.start(new AdobeCallback () {
            @Override
            public void call(Object o) {
                MobileCore.configureWithAppID(ENVIRONMENT_FILE_ID);
            }
        });
    } catch (InvalidInitException e) {
        Log.e("MyApplication", String.format("Error while registering extensions %s", e.getLocalizedMessage()));
    }
```


#### Importing the SDK:

```dart
import 'package:flutter_aepedgeconsent/flutter_aepedgeconsent.dart';
```

#### Getting Consent version:

**Syntax**
```dart
static Future<String> get extensionVersion
```

**Example**
```dart
String version = await Consent.extensionVersion;
```

#### Getting Current Consent Preference:

**Syntax**
```dart
static Future<Map<dynamic, dynamic>> get consents
```

**Example**
```dart
Map<dynamic, dynamic> result = {};
    try {
      result = await Consent.consents;
    } on PlatformException {
      log("Failed to get consent info");
    }
```

#### Update Consent:

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
