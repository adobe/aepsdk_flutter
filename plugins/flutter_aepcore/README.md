# flutter_aepcore

[![pub package](https://img.shields.io/pub/v/flutter_aepcore.svg)](https://pub.dartlang.org/packages/flutter_aepcore) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepcore` is a flutter plugin for the iOS and Android [AEP Core SDK](https://developer.adobe.com/client-sdks/documentation/mobile-core/) to allow for integration with flutter applications. Functionality to enable the Core extension is provided entirely through Dart documented below.

## Contents
- [Installation](#installation)
- [Importing the plugins](#importing-the-plugins)
- [Initializing](#initializing)
- [Core](#core)
- [Identity](#identity)
- [Lifecycle](#lifecycle)
- [Signal](#signal)
- [Tests](#tests)

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepcore/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Importing the Plugins

Import the package in your **Dart** code as follows:

```dart
import 'package:flutter_{extension}/flutter_{plugin_name}.dart'
```

## Initializing

To initialize the SDK, use the following methods:
- [MobileCore.initializeWithAppId(appId)](#initializewithappid)
- [MobileCore.initialize(initOptions)](#initialize)

Refer to the root [Readme](https://github.com/adobe/aepsdk_flutter/blob/main/README.md) for more information about the SDK setup.

## Core

For more detailed information on the Core APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/mobile-core/)

## Importing Core:
In your Flutter application, import the Core package as follows:

```dart
import 'package:flutter_aepcore/flutter_aepcore.dart';
```

## API reference

### extensionVersion
Returns the SDK version of the Core extension.

**Syntax**
```dart
Future<String> get extensionVersion
```

**Example**
```dart
String version = await MobileCore.extensionVersion;
```

### initializeWithAppId
Initialize the AEP SDK by automatically registering all extensions bundled with the application and enabling automatic lifecycle tracking.

appId: Configures the SDK with the provided mobile property environment ID configured from the Data Collection UI.

**Syntax**
```dart
static Future<void> initializeWithAppId({required String appId})
```

**Example**
```dart
class _HomePageState extends State<HomePage> {
  /// Initialize the Adobe Experience Platform Mobile SDK inside the initState method.
  @override
  void initState() {
    super.initState();
    _initializeAEPMobileSdk();
  }

 Future<void> _initializeAEPMobileSdk() async {
    MobileCore.setLogLevel(LogLevel.trace);
    MobileCore.initializeWithAppId(appId:"YOUR_APP_ID");
  }
}
```

> [!NOTE]  
> Starting from Adobe Experience Platform Flutter **5.x**,  there is no longer a need to initialize the SDK on the [native platforms](https://github.com/adobe/aepsdk_flutter/tree/v4.x?tab=readme-ov-file#usage), as was required in earlier versions.

### initialize
Initialize the AEP SDK by automatically registering all extensions bundled with the application and enabling automatic lifecycle tracking. This API also allows further customization by accepting InitOptions.

InitOptions: Allow customization of the default initialization behavior. Refer to the [InitOptions](#initoptions).

**Syntax**
```dart
static Future<void> initialize({required InitOptions initOptions}) 
```

**Example**
```dart

class _HomePageState extends State<HomePage> {
  /// Initialize the Adobe Experience Platform Mobile SDK inside the initState method.
  @override
  void initState() {
    super.initState();
    _initializeAEPMobileSdk();
  }

  Future<void> _initializeAEPMobileSdk() async {
    MobileCore.setLogLevel(LogLevel.trace);
    
    try {
      InitOptions initOptions = InitOptions(
      appId: "YOUR-APP-ID", 
      lifecycleAutomaticTrackingEnabled: true,
      lifecycleAdditionalContextData: {"key": "value"}
      );

      MobileCore.initialize(initOptions: initOptions);
      print("Adobe Experience Platform Mobile SDK was initialized");
    } catch (e) {
        print("Failed to initialize Adobe Experience Platform Mobile SDK: $e");
      }
  }
}
```

#### InitOptions
The InitOptions class defines the options for initializing the AEP SDK. It currently supports the following options:

* appID – The App ID used to retrieve remote configurations from Adobe servers.
* lifecycleAutomaticTrackingEnabled – A boolean flag to enable or disable automatic lifecycle tracking
* lifecycleAdditionalContextData – A map containing extra context data to be sent with the lifecycle start event.
* appGroup (iOS only) – A string representing the App Group identifier for sharing data between app extensions and the main application.

### updateConfiguration
Update the configuration programmatically by passing configuration keys and values to override the existing configuration.

**Syntax**
```dart
static Future<void> updateConfiguration(Map<String, Object> configMap)
```

**Example**
```dart
MobileCore.updateConfiguration({"key" : "value"});
```

### clearUpdatedConfiguration
Clearing configuration updates back to original configuration.

**Syntax**
```dart
static Future<void> clearUpdatedConfiguration()
```

**Example**
```dart
MobileCore.clearUpdatedConfiguration();
```

### setLogLevel
Control the log level of the SDK.

**Syntax**
```dart
static Future<void> setLogLevel(LogLevel mode)
```

**Example**
```dart
MobileCore.setLogLevel(LogLevel.error);
MobileCore.setLogLevel(LogLevel.warning);
MobileCore.setLogLevel(LogLevel.debug);
MobileCore.setLogLevel(LogLevel.trace);
```

### get privacyStatus
Get the current privacy status.

**Syntax**
```dart
static Future<PrivacyStatus> get privacyStatus
```

**Example**
```dart
PrivacyStatus result;

try {
  result = await MobileCore.privacyStatus;
} on PlatformException {
  log("Failed to get privacy status");
}
```

### setPrivacyStatus
Set the privacy status.

**Syntax**
```dart
static Future<void> setPrivacyStatus(PrivacyStatus privacyStatus)
```

**Example**
```dart
MobileCore.setPrivacyStatus(PrivacyStatus.opt_in);
MobileCore.setPrivacyStatus(PrivacyStatus.opt_out);
MobileCore.setPrivacyStatus(PrivacyStatus.unknown);
```

### get sdkIdentities
Get the SDK identities.

**Syntax**
```dart
static Future<String> get sdkIdentities
```

**Example**
```dart
String result = "";

try {
  result = await MobileCore.sdkIdentities;
} on PlatformException {
  log("Failed to get sdk identities");
}
```

### dispatchEvent
Dispatch an Event Hub event.

**Syntax**
```dart
static Future<void> dispatchEvent(Event event)
```

**Example**
```dart
final Event event = Event({
  "eventName": "testEventName",
  "eventType": "testEventType",
  "eventSource": "testEventSource",
  "eventData": {"eventDataKey": "eventDataValue"}
});
try {
  await MobileCore.dispatchEvent(event);
} on PlatformException catch (e) {
  log("Failed to dispatch event '${e.message}''");
}
```

### dispatchEventWithResponseCallback
Dispatch an Event Hub event with callback.

**Syntax**
```dart
static Future<Event> dispatchEventWithResponseCallback
```

**Example**
```dart
Event result;
final Event event = Event({
      "eventName": "testEventName",
      "eventType": "testEventType",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });
    try {
      result = await MobileCore.dispatchEventWithResponseCallback(event, 1000);
    } on PlatformException catch (e) {
      log("Failed to dispatch event '${e.message}''");
    }
```

### resetIdentities
The resetIdentities method requests that each extension resets the identities it owns and each extension responds to this request uniquely.

**Syntax**
```dart
static Future<void> resetIdentities()
```

**Example**
```dart
MobileCore.resetIdentities()
```

### trackAction
Track event actions that occur in your application.

> [!IMPORTANT]  
> trackAction is supported through [Edge Bridge](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepedgebridge) and [Edge Network](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepedge) extensions. 

**Syntax**
```dart
static Future<void> trackAction
```

**Example**
```dart
MobileCore.trackAction("myAction",  data: {"key1": "value1"});
```

### trackState
Track states that represent screens or views in your application.

> [!IMPORTANT]  
> trackState is supported through [Edge Bridge](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepedgebridge) and [Edge Network](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepedge) extensions. 

**Syntax**
```dart
static Future<void> trackState
```

**Example**
```dart
MobileCore.trackState("myState",  data: {"key1": "value1"});
```

### Identity

For more information on the Core Identity APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/mobile-core/identity/).

### Importing Identity:
In your Flutter application, import the Identity package as follows:

```dart
import 'package:flutter_aepcore/flutter_aepidentity.dart';
```

## API reference

### extensionVersion
Returns the SDK version of the Identity extension.

**Syntax**
```dart
Future<String> get extensionVersion
```

**Example**
```dart
String version = await Identity.extensionVersion;
```

### syncIdentifier
Updates the given customer ID with the Adobe Experience Cloud ID Service.

**Syntax**
```dart
static Future<void> syncIdentifier
```

**Example**
```dart
Identity.syncIdentifier("identifierType", "identifier", MobileVisitorAuthenticationState.authenticated);
```

### syncIdentifiers
Updates the given customer IDs with the Adobe Experience Cloud ID Service.

**Syntax**
```dart
static Future<void> syncIdentifiers(Map<String, String> identifiers)
```

**Example**
```dart
Identity.syncIdentifiers({"idType1":"idValue1",
                                    "idType2":"idValue2",
                                    "idType3":"idValue3"});
```

### syncIdentifiersWithAuthState
Updates the given customer IDs with Authentication State using the Adobe Experience Cloud ID Service. 

**Syntax**
```dart
static Future<void> syncIdentifiersWithAuthState
```

**Example**
```dart
Identity.syncIdentifiersWithAuthState({"idType1":"idValue1", "idType2":"idValue2", "idType3":"idValue3"}, MobileVisitorAuthenticationState.authenticated);
```

Note: `MobileVisitorAuthenticationState` is defined as:

```dart
enum MobileVisitorAuthenticationState {unknown, authenticated, logged_out}
```

### appendToUrl
Append visitor data to a URL.

**Syntax**
```dart
static Future<String> appendToUrl(String url)
```

**Example**
```dart
String result = "";

try {
  result = await Identity.appendToUrl("www.myUrl.com");
} on PlatformException {
  log("Failed to append URL");
}
```

### get urlVariables
Get visitor data as URL query parameter string.

**Syntax**
```dart
static Future<String> get urlVariables
```

**Example**
```dart
String result = "";

try {
  result = await Identity.urlVariables;
} on PlatformException {
  log("Failed to get url variables");
}
```

### get identifiers
Returns all customer identifiers that were previously synced with the Adobe Experience Cloud.

**Syntax**
```dart
static Future<List<Identifiable>> get identifiers
```

**Example**
```dart
List<Identifiable> result;

try {
  result = await Identity.identifiers;
} on PlatformException {
  log("Failed to get identifiers");
}
```

### getExperienceCloudId
This API retrieves the Experience Cloud ID (ECID) that was generated when the app was initially launched. This ID is preserved between app upgrades, is saved and restored during the standard application backup process, and is removed at uninstall.

**Syntax**
```dart
static Future<String> get experienceCloudId
```

**Example**
```dart
String result = "";

try {
  result = await Identity.experienceCloudId;
} on PlatformException {
  log("Failed to get experienceCloudId");
}
```

### Lifecycle

For more information about Lifecycle for Edge Network, visit the documentation [here](https://developer.adobe.com/client-sdks/edge/lifecycle-for-edge-network/).

Starting from Adobe Experience Platform Flutter **5.x**, lifecycle tracking is enabled automatically with Initialize APIs by default.

Refer to 
- [MobileCore.initializeWithAppId(appId)](#initializewithappid)
- [MobileCore.initialize(initOptions)](#initialize)

### Signal

For more information on the Core Signal APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/mobile-core/signal/)

### Importing Signal:
In your Flutter application, import the Signal package as follows:

```dart
import 'package:flutter_aepcore/flutter_aepsignal.dart';
```

## API reference

### extensionVersion
Returns the SDK version of the Core extension.

**Syntax**
```
static Future<String> get extensionVersion
```

**Example**
 ```dart
String version = await Signal.extensionVersion;
 ```

## Tests

Run:

```bash
$ cd plugins/flutter_{plugin_name}/
$ flutter test
```

## Contributing
See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License
See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
