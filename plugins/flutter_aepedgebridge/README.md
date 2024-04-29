# flutter_aepedgebridge

[![pub package](https://img.shields.io/pub/v/flutter_aepedgebridge.svg)](https://pub.dartlang.org/packages/flutter_aepedgebridge) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepedgebridge` is a flutter plugin for the iOS and Android Adobe Experience Platform Edge Bridge to allow for integration with flutter applications.

The Edge Bridge mobile extension provides seamless routing of data to the Adobe Experience Platform Edge Network for existing SDK implementations. For applications which already make use of the [MobileCore.trackAction](../flutter_aepcore/README.md#track-app-actions) and/or [MobileCore.trackState](../flutter_aepcore/README.md#track-app-states) APIs to send data to Adobe Analytics, this extension will automatically route those API calls to the Edge Network, making the data available for mapping to a user's XDM schema using the [Data Prep for Data Collection](https://experienceleague.adobe.com/docs/experience-platform/data-prep/home.html).

> [!IMPORTANT]
> Edge Bridge serves primarily as a migration aid for applications that are already using Adobe Analytics within their implementation. 
>
> For new applications being developed with the Adobe Experience Platform Mobile SDKs, it is strongly recommended to use the [`Edge.sendEvent`](../flutter_aepedge/README.md#sendevent) API of the Edge Network extension.

## Prerequisites

The Edge Bridge extension has the following peer dependencies, which must be installed prior to installing the Edge Bridge extension:

- [flutter_aepcore](../flutter_aepcore/README.md)
- [flutter_aepedge](../flutter_aepedge/README.md)
- [flutter_aepedgeidentity](../flutter_aepedgeidentity/README.md)

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepedgebridge/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Tests

Run:

```bash
flutter test
```

## Usage

### Installing and registering the extension with the AEP Mobile Core

Install the Adobe Experience Platform Edge Network extension in your mobile property and configure the default Datastream ID by following the steps in the [Edge Network extension documentation](https://developer.adobe.com/client-sdks/documentation/edge-network).

> **Note**  
Experience Platform Edge Bridge does not have a corresponding extension card in the Data Collection UI; no changes to a Data Collection mobile property are required to use Edge Bridge.

### Registering the extension with AEPCore:

> **Note**  
It is required to initialize the SDK via native code inside your AppDelegate (iOS) and MainApplication class (Android).

As part of the initialization code, make sure that you set the SDK wrapper type to `Flutter` before you start the SDK.

Refer to the [Initialization](https://github.com/adobe/aepsdk_flutter#initializing) section of the root README for more information about initializing the SDK.

**Initialization Example**

iOS
```objc
// AppDelegate.h
@import AEPCore;
@import AEPEdge;
@import AEPEdgeIdentity;
@import AEPEdgeBridge;
...
@implementation AppDelegate

// AppDelegate.m
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AEPMobileCore setWrapperType:AEPWrapperTypeFlutter];

     // TODO: Set up the preferred Environment File ID from your mobile property configured in Data Collection UI
    NSString* ENVIRONMENT_FILE_ID = @"YOUR-APP-ID";
    
    NSArray *extensionsToRegister = @[AEPMobileEdgeIdentity.class, 
                                      AEPMobileEdge.class,                                              
                                      AEPMobileEdgeBridge.class
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
import com.adobe.marketing.mobile.edge.bridge.EdgeBridge
  
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
    MobileCore.configureWithAppID(ENVIRONMENT_FILE_ID);

    MobileCore.registerExtensions(
      Arrays.asList(Identity.EXTENSION, Edge.EXTENSION, EdgeBridge.EXTENSION),
      o -> Log.d("MainApp", "Adobe Experience Platform Mobile SDK was initialized")
    );
  }
}
```

### Importing the SDK:

```dart
import 'package:flutter_aepedgebridge/flutter_aepedgebridge.dart';
```


### Edge Bridge tutorials

For tutorials on implementing Edge Bridge and Data Prep mapping, refer to the [Edge Bridge tutorials](https://github.com/adobe/aepsdk-edgebridge-ios/tree/main/Documentation/tutorials).



## API reference
### extensionVersion
Returns the version of the client-side Edge Bridge extension.

**Syntax**
```dart
static Future<String> get extensionVersion
```

**Example**
```dart
String version = await EdgeBridge.extensionVersion;
```