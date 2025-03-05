# Migrate to the Experience Platform SDK libraries (AEP) for Flutter

If you have implemented the older Flutter libraries (ACP-prefixed Flutter libraries) in your mobile app, then the following steps will help you migrate to the latest Flutter libraries (AEP-prefixed libraries).

## Switch plugin dependencies

Update your `pubspec.yml` file to point to the new plugin as so:

```diff
...

dependencies:
-  flutter_acpcore: ^2.0.0
+  flutter_aepcore: ^5.0.0

...
```

Updated plugins can be found in this repository under [plugins/](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/). If they are not there, they are currently not supported.

| Flutter (ACP) | Flutter (AEP) |
| :--- | :--- |
| flutter_acpcore | flutter_aepcore |
| flutter_assurance | flutter_aepassurance |
| flutter_acpuserprofile | flutter_aepuserprofile |
| flutter_acpanalytics | NA, Analytics workflows supported through [Edge Network](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepedge) or [Edge Bridge](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepedgebridge) extensions. |
| Place Services| NA |
| Place Monitor | NA |

## Update import plugins
```diff
-  import 'package:flutter_acpcore/flutter_acpcore.dart';
+  import 'package:flutter_aepcore/flutter_aepcore.dart';
```




## Update SDK initialization

> [!NOTE]  
 > Starting from Adobe Experience Platform Flutter **5.x**,  there is no longer a need to initialize the SDK on the [native platforms](https://github.com/adobe/aepsdk_flutter/tree/v4.x?tab=readme-ov-file#usage), as was required in earlier versions.

Remove all the ACP registration code and the extensions code on the native `Android` and `iOS` platforms.

Initialize AEP SDK in the **Dart** application:

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

    // For more granular control over the initial options, you can use the following sample code:
    // InitOptions initOptions = InitOptions(
    //   appId: "YOUR_APP_ID",
    //   lifecycleAutomaticTrackingEnabled: true,
    //   lifecycleAdditionalContextData: {"key": "value"},
    //   appGroupIOS: "group.com.example",
    // );

    // MobileCore.initialize(initOptions: initOptions);
  }
```

 Refer to the initializing details info [here](https://github.com/adobe/aepsdk_flutter/tree/main?tab=readme-ov-file#initializing).

## Update API usage and references for each extension

### Core

##### Importing Core:
- (ACP)
```dart
import 'package:flutter_acpcore/flutter_acpcore.dart';
```
- (AEP)
```dart
import 'package:flutter_aepcore/flutter_aepcore.dart';
```

##### Getting Core version:
- (ACP)
```dart
String version = await FlutterACPCore.extensionVersion;
```
- (AEP)
```dart
String version = await MobileCore.extensionVersion;
```

##### Updating the SDK configuration:
- (ACP)
```dart
FlutterACPCore.updateConfiguration({"key" : "value"});
```
- (AEP)
```dart
MobileCore.updateConfiguration({"key" : "value"});
```

##### Clearing configuration updates back to original configuration:
- (ACP)
 
 Not supported in ACP 2.x
 
- (AEP)
```dart
MobileCore.clearUpdatedConfiguration();
```

##### Controlling the log level of the SDK:
- (ACP)
```dart
import 'package:flutter_acpcore/src/acpmobile_logging_level.dart';

FlutterACPCore.setLogLevel(ACPLoggingLevel.ERROR);
FlutterACPCore.setLogLevel(ACPLoggingLevel.WARNING);
FlutterACPCore.setLogLevel(ACPLoggingLevel.DEBUG);
FlutterACPCore.setLogLevel(ACPLoggingLevel.VERBOSE);
```

- (AEP)
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

MobileCore.setLogLevel(LogLevel.error);
MobileCore.setLogLevel(LogLevel.warning);
MobileCore.setLogLevel(LogLevel.debug);
MobileCore.setLogLevel(LogLevel.trace);
```

##### Getting the current privacy status:
- (ACP)
```dart
import 'package:flutter_acpcore/src/acpmobile_privacy_status.dart';

ACPPrivacyStatus result;

try {
  result = await FlutterACPCore.privacyStatus;
} on PlatformException {
  log("Failed to get privacy status");
}
```
- (AEP)
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

PrivacyStatus result;

try {
  result = await MobileCore.privacyStatus;
} on PlatformException {
  log("Failed to get privacy status");
}
```

##### Setting the privacy status:
- (ACP)
```dart
import 'package:flutter_acpcore/src/acpmobile_privacy_status.dart';

FlutterACPCore.setPrivacyStatus(ACPPrivacyStatus.OPT_IN);
FlutterACPCore.setPrivacyStatus(ACPPrivacyStatus.OPT_OUT);
FlutterACPCore.setPrivacyStatus(ACPPrivacyStatus.UNKNOWN);
```
- (AEP)
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

MobileCore.setPrivacyStatus(PrivacyStatus.opt_in);
MobileCore.setPrivacyStatus(PrivacyStatus.opt_out);
MobileCore.setPrivacyStatus(PrivacyStatus.unknown);
```

##### Getting the SDK identities:
- (ACP)
```dart
String result = "";

try {
  result = await FlutterACPCore.sdkIdentities;
} on PlatformException {
  log("Failed to get sdk identities");
}
```
- (AEP)
```dart
String result = "";

try {
  result = await MobileCore.sdkIdentities;
} on PlatformException {
  log("Failed to get sdk identities");
}
```

##### Dispatching an Event Hub event:
- (ACP)
```dart
import 'package:flutter_acpcore/src/acpextension_event.dart';

final ACPExtensionEvent event = ACPExtensionEvent.createEvent("eventName", "eventType", "eventSource", {"testDataKey": "testDataValue"});

bool result;
try {
  result = await FlutterACPCore.dispatchEvent(event);
} on PlatformException catch (e) {
  log("Failed to dispatch event '${e.message}''");
}
```
- (AEP)
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

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

##### Dispatching an Event Hub event with callback:
- (ACP)
```dart
import 'package:flutter_acpcore/src/acpextension_event.dart';

ACPExtensionEvent result;
final ACPExtensionEvent event ACPExtensionEvent.createEvent("eventName", "eventType", "eventSource", {"testDataKey": "testDataValue"});

try {
  result = await FlutterACPCore.dispatchEventWithResponseCallback(event);
} on PlatformException catch (e) {
  log("Failed to dispatch event '${e.message}''");
}
```
- (AEP)
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

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

### Identity

##### Importing Identity:
- (ACP)
```dart
import 'package:flutter_acpcore/flutter_acpidentity.dart';
```
- (AEP)
```dart
import 'package:flutter_aepcore/flutter_aepidentity.dart';
```

##### Getting Identity version:
- (ACP)
```dart
String version = await FlutterACPIdentity.extensionVersion;
```
- (AEP)
```dart
String version = await Identity.extensionVersion;
```

##### Sync Identifier:
- (ACP)
```dart
import 'package:flutter_acpcore/src/acpmobile_visitor_id.dart';

FlutterACPIdentity.syncIdentifier("identifierType", "identifier", ACPMobileVisitorAuthenticationState.AUTHENTICATED);
```
- (AEP)
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

Identity.syncIdentifier("identifierType", "identifier", MobileVisitorAuthenticationState.authenticated);
```

##### Sync Identifiers:
- (ACP)
```dart
FlutterACPIdentity.syncIdentifiers({"idType1":"idValue1",
                                    "idType2":"idValue2",
                                    "idType3":"idValue3"});
```
- (AEP)
```dart
Identity.syncIdentifiers({"idType1":"idValue1",
                                    "idType2":"idValue2",
                                    "idType3":"idValue3"});
```

##### Sync Identifiers with Authentication State:
- (ACP)
```dart
import 'package:flutter_acpcore/src/acpmobile_visitor_id.dart';

FlutterACPIdentity.syncIdentifiersWithAuthState({"idType1":"idValue1", "idType2":"idValue2", "idType3":"idValue3"}, ACPMobileVisitorAuthenticationState.AUTHENTICATED);

```
Note: `ACPMobileVisitorAuthenticationState` is defined as:

```dart
enum ACPMobileVisitorAuthenticationState {UNKNOWN, AUTHENTICATED, LOGGED_OUT}
```
- (AEP)
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

Identity.syncIdentifiersWithAuthState({"idType1":"idValue1", "idType2":"idValue2", "idType3":"idValue3"}, MobileVisitorAuthenticationState.authenticated);

```

Note: `MobileVisitorAuthenticationState` is defined as:

```dart
enum MobileVisitorAuthenticationState {unknown, authenticated, logged_out}
```

##### Append visitor data to a URL:
- (ACP)
```dart
String result = "";

try {
  result = await FlutterACPIdentity.appendToUrl("www.myUrl.com");
} on PlatformException {
  log("Failed to append URL");
}
```
- (AEP)
```dart
String result = "";

try {
  result = await Identity.appendToUrl("www.myUrl.com");
} on PlatformException {
  log("Failed to append URL");
}
```

##### Setting the advertising identifier:
- (ACP)
```dart
FlutterACPCore.setAdvertisingIdentifier("ad-id");
```
- (AEP)
```dart
MobileCore.setAdvertisingIdentifier("ad-id");
```

##### Get visitor data as URL query parameter string:
- (ACP)
```dart
String result = "";

try {
  result = await FlutterACPIdentity.urlVariables;
} on PlatformException {
  log("Failed to get url variables");
}
```
- (AEP)
```dart
String result = "";

try {
  result = await Identity.urlVariables;
} on PlatformException {
  log("Failed to get url variables");
}
```

##### Get Identifiers:
- (ACP)
```dart
List<ACPMobileVisitorId> result;

try {
  result = await FlutterACPIdentity.identifiers;
} on PlatformException {
  log("Failed to get identifiers");
}
```
- (AEP)
```dart
List<Identifiable> result;

try {
  result = await Identity.identifiers;
} on PlatformException {
  log("Failed to get identifiers");
}
```

##### Get Experience Cloud IDs:
- (ACP)
```dart
String result = "";

try {
  result = await FlutterACPIdentity.experienceCloudId;
} on PlatformException {
  log("Failed to get experienceCloudId");
}
```
- (AEP)
```dart
String result = "";

try {
  result = await Identity.experienceCloudId;
} on PlatformException {
  log("Failed to get experienceCloudId");
}
```

##### MobileVisitorId Type:
- (ACP)
```dart
import 'package:flutter_acpcore/src/acpmobile_visitor_id.dart';

class ACPMobileVisitorId {
  String get idOrigin;
  String get idType;
  String get identifier;
  ACPMobileVisitorAuthenticationState get authenticationState;
}
```
- (AEP)
```dart
import 'package:flutter_aepcore/flutter_aepcore_data.dart';

class Identifiable {
  String get idOrigin;
  String get idType;
  String get identifier;
  MobileVisitorAuthenticationState get authenticationState;
}
```

### Lifecycle
#### Importing Lifecycle:
- (ACP)
```dart
import 'package:flutter_acpcore/flutter_acplifecycle.dart''
```
- (AEP)
```dart
import 'package:flutter_aepcore/flutter_aeplifecycle.dart''
```

#### Getting Lifecycle version:
- (ACP)
```dart
String version = await FlutterACPLifecycle.extensionVersion;
```
- (AEP)
```dart
String version = await Lifecycle.extensionVersion;
```

### Signal

##### Importing Signal:
- (ACP)
```dart
import 'package:flutter_acpcore/flutter_acpsignal.dart';
```
- (AEP)
```dart
import 'package:flutter_aepcore/flutter_aepsignal.dart';
```

##### Getting Signal version:
- (ACP)
 ```dart
String version = await FlutterACPSignal.extensionVersion;
 ```
- (AEP)
 ```dart
String version = await Signal.extensionVersion;
 ```
 
 ### Assurance
 
 ##### Importing the SDK:
 - (ACP)
 ```dart
import 'package:flutter_assurance/flutter_assurance.dart';
```
 - (AEP)
```dart
import 'package:flutter_aepassurance/flutter_aepassurance.dart';
```

##### Getting Assurance version:
- (ACP)
 ```dart
String version = await FlutterAssurance.extensionVersion;
 ```
- (AEP)
 ```dart
String version = await Assurance.extensionVersion;
 ```

##### Starting a Assurance session:
- (ACP)
```dart
FlutterAssurance.startSession(url);
```
- (AEP)
 ```dart
Assurance.startSession(url);
 ```

### UserProfile
 
##### Importing the SDK:
- (ACP)
```dart
import 'package:flutter_acpuserprofile/flutter_acpuserprofile.dart';
```
- (AEP)
```dart
import 'package:flutter_aepuserprofile/flutter_aepuserprofile.dart';
```

##### Getting UserProfile version:
- (ACP)
 ```dart
String version = await FlutterACPUserProfile.extensionVersion;
```
- (AEP)
```dart
String version = await UserProfile.extensionVersion;
```

##### Get user profile attributes which match the provided keys:
- (ACP)
```dart
try {
  String userAttributes = await FlutterACPUserProfile.getUserAttributes(["attr1", "attr2"]);
} on PlatformException {
   log("Failed to get the user attributes");
}
```
- (AEP)
```dart
try {
	String userAttributes = await UserProfile.getUserAttributes(["attr1", "attr2"]);
} on PlatformException {
	log("Failed to get the user attributes");
}
```

##### Remove provided user profile attributes if they exist:
- (ACP)
```dart
FlutterACPUserProfile.removeUserAttributes(["attr1", "attr2"]);
```
- (AEP)
 ```dart
UserProfile.removeUserAttributes(["attr1", "attr2"]);
 ```

##### Set multiple user profile attributes:
- (ACP)
```dart
FlutterACPUserProfile.updateUserAttributes({"attr1": "attr1Value", "attr2": "attr2Value"});
```
- (AEP)
 ```dart
UserProfile.updateUserAttributes({"attr1": "attr1Value", "attr2": "attr2Value"});
 ```