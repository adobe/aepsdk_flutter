# flutter_aepoptimize

[![pub package](https://img.shields.io/pub/v/flutter_aepoptimize.svg)](https://pub.dartlang.org/packages/flutter_aepoptimize) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepoptimize` is a flutter plugin for the iOS and Android [AEPOptimize SDK](https://developer.adobe.com/client-sdks/documentation/adobe-journey-optimizer-decisioning) to allow for integration with Flutter applications. Functionality to enable the Optimize extension is provided entirely through Dart documented below.

## Prerequisites

The Optimize extension has the following peer dependency, which must be installed prior to installing it:

- [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md)

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepoptimize/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Tests

Run:

```bash
flutter test
```

## Usage

For more detailed information on the Optimize APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/adobe-journey-optimizer-decisioning/api-reference)

### Registering the extension with AEPCore:

 > Note: It is required to initialize the SDK via native code inside your AppDelegate (iOS) and MainApplication class (Android).

As part of the initialization code, make sure that you set the SDK wrapper type to `Flutter` before you start the SDK.

Refer to the [Initialization](https://github.com/adobe/aepsdk_flutter#initializing) section of the root README for more information about initializing the SDK.

**Initialization Example**

iOS
```objc
// AppDelegate.h
@import AEPCore;
@import AEPOptimize;
...
@implementation AppDelegate

// AppDelegate.m
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AEPMobileCore setWrapperType:AEPWrapperTypeFlutter];

     // TODO: Set up the preferred Environment File ID from your mobile property configured in Data Collection UI
    NSString* ENVIRONMENT_FILE_ID = @"YOUR-APP-ID";
    
    NSArray *extensionsToRegister = @[                                             
                                      AEPOptimize.class
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
import com.adobe.marketing.mobile.optimize.Optimize;
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

    Optimize.registerExtension();
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
import 'package:flutter_aepoptimize/flutter_aepoptimize.dart';
```
------
## API reference
### extensionVersion
Returns the SDK version of the Optimize extension.

**Syntax**
```dart
static Future<String> get extensionVersion
```

**Example**
```dart
String version = await Optimize.extensionVersion;
```
------
### getPropositions
This API retrieves the previously fetched propositions, for the provided decision scopes, from the in-memory extension propositions cache. The completion callback is invoked with the decision propositions corresponding to the given decision scopes. If a certain decision scope has not already been fetched prior to this API call, it will not be contained in the returned propositions.

**Syntax**
```dart
static Future<List<Proposition>> getPropositions(List<DecisionScope> decisionScopes)
```

**Example**
```dart
List<Proposition> result = [];
    try {
      DecisionScope decisionScopeOne = DecisionScope('name': "myScope")
      DecisionScope decisionScopeTwo = DecisionScope(
        "xcore:offer-activity:1111111111111111", "xcore:offer-placement:1111111111111111", 2
      )
      result = await Optimize.getPropositions([decisionScopeOne, decisionScopeTwo]);
    } on PlatformException {
      log("Failed to get consent info");
    }
```
------
### updatePropositions
This API dispatches an Event for the Edge network extension to fetch decision propositions, for the provided decision scopes array, from the decisioning services enabled in the Experience Edge. The returned decision propositions are cached in-memory in the Optimize SDK extension and can be retrieved using `getPropositions` API.

**Syntax**
```dart
static Future<void> updatePropositions(List<DecisionScope> decisionScopes)
```

**Example**
```dart

```

## Contributing
See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License
See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
