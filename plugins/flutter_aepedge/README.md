# flutter_aepedge

[![pub package](https://img.shields.io/pub/v/flutter_aepedge.svg)](https://pub.dartlang.org/packages/flutter_aepedge) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepedge` is a flutter plugin for the iOS and Android [AEPEdge SDK](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/adobe-experience-platform-edge) to allow for integration with Flutter applications. Functionality to enable the edge extension is provided entirely through Dart documented below.

## Installation

First, make sure that the [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md) and [flutter_aepedgeidentity](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aeedgeidentity/README.md) plugins are installed, as flutter_aepedge depends on them. 

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepedge/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Tests

Run:

```bash
flutter test
```

## Usage
### Edge Network

For more detailed information on the Edge APIs, visit the documentation [here](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/adobe-experience-platform-edge)

##### Registering the extension with AEPCore:

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
...
@implementation AppDelegate

// AppDelegate.m
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AEPMobileCore setWrapperType:AEPWrapperTypeFlutter];

     // TODO: Set up the preferred Environment File ID from your mobile property configured in Data Collection UI
    NSString* ENVIRONMENT_FILE_ID = @"YOUR-APP-ID";
    
    const UIApplicationState appState = application.applicationState;

    NSArray *extensionsToRegister = @[AEPMobileEdgeIdentity.class, 
                                      AEPMobileEdge.class,                                              
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
    MobileCore.start(new AdobeCallback () {
        @Override
        public void call(Object o) {
          MobileCore.configureWithAppID(ENVIRONMENT_FILE_ID);
        }
   });
```
------
#### Importing the SDK:
```dart
import 'package:flutter_aepedge/flutter_aepedge.dart';
```
------
#### Getting edge version:
 ```dart
String version = await edge.extensionVersion;
 ```
------
#### sendEvent
 ```dart
String version = await edge.extensionVersion;
 ```
**Syntax**
```dart
static Future<List<EventHandle>> sendEvent(
    ExperienceEvent experienceEvent,
  )
```

**Example**
```dart
late List<EventHandle> result;
Map<dynamic, dynamic> xdmData = {"eventType": "SampleEventType"};
Map<String, dynamic> data = {"free": "form", "data": "example"};

final ExperienceEvent experienceevent = ExperienceEvent({
  "xdmData": xdmData,
  "data": data,
  "datasetIdentifier": "datasetIdExample"
});
try {
  result = await Edge.sendEvent(experienceevent);
} on PlatformException {
  log("Failed to send experience event");
}
```
------
### Public classes
#### ExperienceEvent

##### Create Experience Event from Dictionary:

```dart
Map<dynamic, dynamic> xdmData = {"eventType": "SampleEventType"};
final ExperienceEvent experienceevent = ExperienceEvent({
  "xdmData": xdmData
});
```

##### Add free form data to the Experience event:

```dart
Map<dynamic, dynamic> xdmData = {"eventType": "SampleEventType"};
Map<String, dynamic> data = {"free": "form", "data": "example"};
final ExperienceEvent experienceevent = ExperienceEvent({
  "xdmData": xdmData,
  "data": data
});
```

##### Set the destination Dataset identifier to the current Experience event:

```dart
Map<dynamic, dynamic> xdmData = {"eventType": "SampleEventType"};
final ExperienceEvent experienceevent = ExperienceEvent({
  "xdmData": xdmData, "data": null, "datasetIdExample"
});
```

##### Create Experience Event with xdmdata, free form data and the destination Dataset identifier:

```dart
Map<dynamic, dynamic> xdmData = {"eventType": "SampleEventType"};
Map<String, dynamic> data = {"free": "form", "data": "example"};

final ExperienceEvent experienceevent = ExperienceEvent({
  "xdmData": xdmData,
  "data": data,
  "datasetIdentifier": "datasetIdExample"
});
```

## Contributing
See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License
See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
