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

## Usage

For more detailed information on the Edge APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/edge-network/)

### Importing the extension:

In your Flutter application, import the Edge extension as follows:

```dart
import 'package:flutter_aepedge/flutter_aepedge.dart';
```
### Initializing with SDK:

To initialize the SDK, use the following methods:
- [MobileCore.initializeWithAppId(appId)](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepcore#initializewithappid)
- [MobileCore.initialize(initOptions)](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepcore#initialize)

Refer to the root [Readme](https://github.com/adobe/aepsdk_flutter/blob/main/README.md) for more information about the SDK setup.

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

**Example with Datastream config override**
```dart
Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
Map<String, dynamic> configOverrides = {
      "com_adobe_experience_platform": {
        "datasets": {
          "event": {
            "datasetId": "sampleDatasetID"
          }
        }
      }
    };
final ExperienceEvent experienceEvent = ExperienceEvent({
  "xdmData": xdmData,
  "datastreamConfigOverride": configOverrides
});
List<EventHandle> result = await Edge.sendEvent(experienceEvent);
```
------
### Public classes
#### ExperienceEvent
Experience event is the event to be sent to Adobe Experience Platform Edge Network. The XDM data is required for any Experience event being sent using the Edge extension.

You can create Experience event either by using dictionaries or by utilizing convenience constructors.

**Syntax**
```dart
//Create Experience event from Dictionary
ExperienceEvent(this.eventData) 

//Create Experience event using convenience constructor
ExperienceEvent.createEventWithOverrides(final Map<String, dynamic> xdmData,
    [final Map<String, dynamic>? data, final String? datastreamIdOverride, final Map<String, dynamic>? datastreamConfigOverride])
 
```

**Usage**
##### Create Experience event from Dictionaries:
```dart
// Create Experience event with free form data:
final ExperienceEvent experienceEvent = ExperienceEvent({
  "xdmData": xdmData,
  "data": data
});

// Create Experience event with free form data and datastream ID override:
final ExperienceEvent experienceEvent = ExperienceEvent({
  "xdmData": xdmData,
  "data": data,
  "datastreamIdOverride": "sampleDatastreamId"
});

// Create Experience event with free form data and datastream config override:
final ExperienceEvent experienceEvent = ExperienceEvent({
  "xdmData": xdmData,
  "data": data,
  "datastreamConfigOverride": configOverrides
});
```

##### Create Experience event using convenience constructors:
```dart
// Create Experience event with free form data::
final ExperienceEvent experienceEvent =
      ExperienceEvent.createEventWithOverrides(xdmData, data);

// Create Experience event with free form data and datastream ID override:
final ExperienceEvent experienceEvent =
      ExperienceEvent.createEventWithOverrides(xdmData, data, "sampleDatastreamId");

// Create Experience event with free form data and datastream config override:
final ExperienceEvent experienceEvent =
      ExperienceEvent.createEventWithOverrides(xdmData, data, null, configOverrides);


```

**Example**

Create Experience event using dictionaries

```dart
// example 1
// Create Experience Event with freeform data:
Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
Map<String, dynamic> data = {"free": "form", "data": "example"};
final ExperienceEvent experienceEvent = ExperienceEvent({
  "xdmData": xdmData,
  "data": data
});
```

```dart
// example 2
// Create Experience event with free form data and datastream ID override:
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
// Create Experience event with free form data and datastream config override:
Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
Map<String, dynamic> configOverrides = {
    "com_adobe_experience_platform": {
      "datasets": {
        "event": {
          "datasetId": "sampleDatasetID"
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

## Tests

Run:

```bash
flutter test
```

## Contributing
See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License
See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
