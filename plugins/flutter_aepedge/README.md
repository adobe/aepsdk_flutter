# flutter_aepedge

[![pub package](https://img.shields.io/pub/v/flutter_aepedge.svg)](https://pub.dartlang.org/packages/flutter_aepedge) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepedge` is a flutter plugin for the iOS and Android [Adobe Experience Platform Edge SDK](https://developer.adobe.com/client-sdks/documentation/edge-network/) to allow for integration with Flutter applications. Functionality to enable the Edge extension is provided entirely through Dart documented below.

## Prerequisites

The Edge Network extension has the following peer dependencies, which must be installed prior to installing it:

- [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md)
- [flutter_aepedgeidentity](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepedgeidentity/README.md)

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepedge/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Tests

Run:

```bash
flutter test
```

## Usage

For more detailed information on the Edge APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/edge-network/)

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
...
@implementation AppDelegate

// AppDelegate.m
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AEPMobileCore setWrapperType:AEPWrapperTypeFlutter];

     // TODO: Set up the preferred Environment File ID from your mobile property configured in Data Collection UI
    NSString* ENVIRONMENT_FILE_ID = @"YOUR-APP-ID";
    
    NSArray *extensionsToRegister = @[AEPMobileEdgeIdentity.class, 
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
    MobileCore.configureWithAppID(ENVIRONMENT_FILE_ID);

    MobileCore.registerExtensions(
        Arrays.asList(Edge.EXTENSION, Identity.EXTENSION),
        o -> Log.d("MainApp", "Adobe Experience Platform Mobile SDK was initialized.")
    );
  }
}
```
------
### Importing the extension
In your Flutter application, import the Edge extension as follows:
```dart
import 'package:flutter_aepedge/flutter_aepedge.dart';
```
------
## API reference
### extensionVersion
Returns the SDK version of the Edge Network extension.

**Syntax**
```dart
static Future<String> get extensionVersion
 ```

**Example**
 ```dart
String version = await Edge.extensionVersion;
 ```
------
### getLocationHint
Gets the Edge Network location hint used in requests to the Adobe Experience Platform Edge Network. The Edge Network location hint may be used when building the URL for Adobe Experience Platform Edge Network requests to hint at the server cluster to use.

**Syntax**
```dart
static Future<String?> get locationHint
```

**Example**
```dart
String? result = null;

try {
  result = await Edge.locationHint;
} on PlatformException {
  log("Failed to get location hint");
}
```
------
### resetIdentity
Resets current state of the AEP Edge extension and clears previously cached content related to current identity, if any.
See [MobileCore.resetIdentities](./../flutter_aepcore/README.md) for more details.

------
### setLocationHint
Sets the Edge Network location hint used in requests to the Adobe Experience Platform Edge Network. Passing null or an empty string clears the existing location hint. Edge Network responses may overwrite the location hint to a new value when necessary to manage network traffic.

>Warning: Use caution when setting the location hint. Only use location hints for the "EdgeNetwork" scope. An incorrect location hint value will cause all Edge Network requests to fail with 404 response code.

**Syntax**
```dart
static Future<void> setLocationHint([String? hint])
```

**Example**
```dart
Edge.setLocationHint('va6');
```
------
### sendEvent
Sends an Experience event to Adobe Experience Platform Edge Network.

**Syntax**
```dart
static Future<List<EventHandle>> sendEvent(
    ExperienceEvent experienceEvent,
  )
```

**Example**
```dart
Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
Map<String, dynamic> data = {"free": "form", "data": "example"};
final ExperienceEvent experienceEvent = ExperienceEvent({
  "xdmData": xdmData,
  "data": data
});
List<EventHandle> result = await Edge.sendEvent(experienceEvent);
```

**Example with Datastream ID override**
```dart
Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
final ExperienceEvent experienceEvent = ExperienceEvent({
  "xdmData": xdmData,
  "datastreamIdOverride": "SampleDatastreamId"
});
List<EventHandle> result = await Edge.sendEvent(experienceEvent);
```

**Example with Datastream confg override**
```dart
Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
Map<String, dynamic> configOverrides = {"config": {
      "com_adobe_experience_platform": {
        "datasets": {
          "event": {
            "datasetId": "sampleDatasetID"
          }
        }
      }
    }};
final ExperienceEvent experienceEvent = ExperienceEvent({
  "xdmData": xdmData,
  "datastreamConfigOverride": configOverrides
});
List<EventHandle> result = await Edge.sendEvent(experienceEvent);
```
------
### Public classes
#### ExperienceEvent
Experience Event is the event to be sent to Adobe Experience Platform Edge Network. The XDM data is required for any Experience Event being sent using the Edge extension.

You can create Experience Event either by using dictionaries or by utilizing convenience constructors.

**Syntax**
```dart
//Create Experience Event from Dictionary
ExperienceEvent(this.eventData) 

//Create Experience event using convenience constructor
ExperienceEvent.createEventWithOverrides(final Map<String, dynamic> xdmData,
    [final Map<String, dynamic>? data, final String? datastreamIdOverride, final Map<String, dynamic>? datastreamConfigOverride])
 
```

**Usage**
##### Create Experience Event from Dictionaries:
```dart
// set free form data to the Experience event:
final ExperienceEvent experienceEvent = ExperienceEvent({
  "xdmData": xdmData,
  "data": data
});

// Set free form data and datastream id override to the current Experience event:
final ExperienceEvent experienceEvent = ExperienceEvent({
  "xdmData": xdmData,
  "data": data,
  "datastreamIdOverride": "sampleDatastreamId"
});

// Set free form data and datastream config override to the current Experience event:
final ExperienceEvent experienceEvent = ExperienceEvent({
  "xdmData": xdmData,
  "data": data,
  "datastreamConfigOverride": configOverrides
});
```

##### Create Experience event using convenience constructors:
```dart
// set free form data to the Experience event:
final ExperienceEvent experienceEvent =
      ExperienceEvent.createEventWithOverrides(xdmData, data);

// Set free form data and datastream id override to the current Experience event:
final ExperienceEvent experienceEvent =
      ExperienceEvent.createEventWithOverrides(xdmData, data, "sampleDatastreamId");

// Set free form data and datastream config override to the current Experience event:
final ExperienceEvent experienceEvent =
      ExperienceEvent.createEventWithOverrides(xdmData, data, null, configOverrides);


```

**Example**

Examples of Creating Experience Event Using Dictionaries.

```dart
// example 1
// set free form data to the Experience event:
Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
Map<String, dynamic> data = {"free": "form", "data": "example"};
final ExperienceEvent experienceEvent = ExperienceEvent({
  "xdmData": xdmData,
  "data": data
});
```

```dart
// example 2
// Set free form data and datastream id override to the current Experience event:
Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
Map<String, dynamic> data = {"free": "form", "data": "example"};
final ExperienceEvent experienceEvent = ExperienceEvent({
  "xdmData": xdmData,
  "data": data,
  "datastreamIdOverride": "sampleDatastreamId"
});
```

```dart
// example 3
// Set datastream config override to the current Experience event:
Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
Map<String, dynamic> configOverrides = {"config": {
      "com_adobe_experience_platform": {
        "datasets": {
          "event": {
            "datasetId": "sampleDatasetID"
          }
        }
      }
   } 
}

final ExperienceEvent experienceEvent = ExperienceEvent({
  "xdmData": xdmData,
  "datastreamConfigOverride": configOverrides
});
```
#### EventHandle
The EventHandle is a response fragment from Adobe Experience Platform Edge Network for a sent XDM Experience Event. One event can receive none, one or multiple EdgeEventHandle(s) as a response.

```dart
static const String _type = 'type';
static const String _payload = 'payload';
```
## Next steps - Schemas setup and validation with Assurance
For examples on XDM schemas and datasets setup and tips on validating with Assurance, refer to the [Edge Network tutorial](https://github.com/adobe/aepsdk-edge-ios/blob/main/Documentation/Tutorials).

## Contributing
See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License
See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
