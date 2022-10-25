# flutter_aepedgeidentity

[![pub package](https://img.shields.io/pub/v/flutter_aepedgeidentity.svg)](https://pub.dartlang.org/packages/flutter_aepedgeidentity) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepedgeidentity` is a flutter plugin for the iOS and Android [AEPEdgeIdentity SDK](https://aep-sdks.gitbook.io/docs/foundation-extensions/identity-for-edge-network) to allow for integration with Flutter applications. Functionality to enable the Edge Identity extension is provided entirely through Dart documented below.

## Prerequisites

The Adobe Experience Platform Identity for Edge Network extension has the following peer dependency, which must be installed prior to installing it:

- [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md)

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepedgeidentity/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Tests
Run:

```
$ flutter test
```

## Usage

For more detailed information on the Edge Identity APIs, visit the documentation [here](https://aep-sdks.gitbook.io/docs/foundation-extensions/identity-for-edge-network)

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
    NSString* ENVIRONMENT_FILE_ID = @'YOUR-APP-ID';
    
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
  private final String ENVIRONMENT_FILE_ID = 'YOUR-APP-ID';

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
### Importing the extension
In your Flutter application, import the Edge Identity extension as follows:
```dart
import 'package:flutter_aepedgeidentity/flutter_aepedgeidentity.dart';
```
------
## API reference
### extensionVersion
Returns the SDK version of the Identity for Edge Network extension.

**Syntax**
```dart
static Future<String> get extensionVersion.
 ```

**Example**
 ```dart
String version = await Identity.extensionVersion;
 ```
------
### getExperienceCloudId
This API retrieves the Experience Cloud ID (ECID) that was generated when the app was initially launched. This ID is preserved between app upgrades, is saved and restored during the standard application backup process, and is removed at uninstall.

**Syntax**
```dart
static Future<String> get experienceCloudId
```

**Example**
```dart
String result = await Identity.experienceCloudId;
```
------
### getIdentities
Get all identities in the Identity for Edge Network extension, including customer identifiers which were previously added.

**Syntax**
```dart
static Future<IdentityMap> get identities
```

**Example**
```dart
IdentityMap result = await Identity.identities;
```
------
### getUrlVariables
Returns the identifiers in a URL's query parameters for consumption in hybrid mobile applications. The response will not return any leading & or ?, since the caller is responsible for placing the variables in the resulting URL in the correct locations. If an error occurs while retrieving the URL variables, the callback handler will return a null value. Otherwise, the encoded string is returned.
An example of an encoded string is as follows: 'adobe_mc=TS%3DTIMESTAMP_VALUE%7CMCMID%3DYOUR_ECID%7CMCORGID%3D9YOUR_EXPERIENCE_CLOUD_ID'

* MCID: This is also known as the Experience Cloud ID (ECID).
* MCORGID: This is also known as the Experience Cloud Organization ID.
* TS: The timestamp that is taken when the request was made.

**Syntax**
```dart
static Future<String> get urlVariables
```

**Example**
```dart
String result = await Identity.urlVariables
```
------
### removeIdentity
Remove the identity from the stored client-side IdentityMap. The Identity extension will stop sending the identifier to the Edge Network. Using this API does not remove the identifier from the server-side User Profile Graph or Identity Graph.

Identities with an empty id or namespace are not allowed and are ignored.

Removing identities using a reserved namespace is not allowed using this API. The reserved namespaces are:
* ECID
* IDFA
* GAID

**Syntax**
```dart
static Future<void> removeIdentity(IdentityItem item, String namespace)
```

**Example**
```dart
IdentityItem item = new IdentityItem('user@example.com');

Identity.removeIdentity(item, 'Email');
```
------
### resetIdentity

Clears all identities stored in the Identity extension and generates a new Experience Cloud ID (ECID) . Using this API does not remove the identifiers from the server-side User Profile Graph or Identity Graph.

This is a destructive action, since once an ECID is removed it cannot be reused. The new ECID generated by this API can increase metrics like unique visitors when a new user profile is created.

Some example use cases for this API are:
* During debugging, to see how new ECIDs (and other identifiers paired with it) behave with existing rules and metrics.
* A last-resort reset for when an ECID should no longer be used.

This API is not recommended for:
* Resetting a user's consent and privacy settings; see [Privacy and GDPR](https://aep-sdks.gitbook.io/docs/resources/privacy-and-gdpr).
* Removing existing custom identifiers; use the [removeIdentity](README.md#removeidentity) API instead.
* Removing a previously synced advertising identifier after the advertising tracking settings were changed by the user; use the [setAdvertisingIdentifier](README.md#setadvertisingidentifier) API instead.

:information_source: The Identity for Edge Network extension does not read the Mobile SDK's privacy status and therefor setting the SDK's privacy status to opt-out will not clear the identities from the Identity for Edge Network extension.

**Syntax**

```dart
static Future<void> resetIdentities()
```

**Example**

```dart
MobileCore.resetIdentities()
```
------
### setAdvertisingIdentifier:
When this API is called with a valid advertising identifier, the Identity for Edge Network extension includes the advertising identifier in the XDM Identity Map using the namespace GAID (Google Advertising ID) in Android and IDFA (Identifier for Advertisers) in iOS. If the API is called with the empty string (''), null/nil, or the all-zeros UUID string values, the advertising identifier is removed from the XDM Identity Map (if previously set).
The advertising identifier is preserved between app upgrades, is saved and restored during the standard application backup process, and is removed at uninstall.

**Syntax**

```dart
static Future<void> setAdvertisingIdentifier(String aid)
```

**Example**

```dart
MobileCore.setAdvertisingIdentifier('ad-id');
```
------
### updateIdentities:

Update the currently known identities within the SDK. The Identity extension will merge the received identifiers with the previously saved ones in an additive manner, no identities are removed from this API.

Identities with an empty id or namespace are not allowed and are ignored.

Updating identities using a reserved namespace is not allowed using this API. The reserved namespaces are:

* ECID
* IDFA
* GAID

**Syntax**

```dart
static Future<IdentityMap> get getIdentities
```

**Example**

```dart
IdentityItem item = new IdentityItem('user@example.com');
IdentityMap identityMap = new IdentityMap();
identityMap.addItem(item, 'email');
Identity.updateIdentities(identityMap);
```
------
## Public Classes
### IdentityMap

Defines a map containing a set of end user identities, keyed on either namespace integration code or the namespace ID of the identity. The values of the map are an array list, meaning that more than one identity of each namespace may be carried.
The format of the IdentityMap class is defined by the [XDM Identity Map Schema](https://github.com/adobe/xdm/blob/master/docs/reference/mixins/shared/identitymap.schema.md).

For more information, please read an overview of the [AEP Identity Service](https://experienceleague.adobe.com/docs/experience-platform/identity/home.html).

```
'identityMap' : {
    'Email' : [
      {
        'id' : 'user@example.com',
        'authenticatedState' : 'authenticated',
        'primary' : false
      }
    ],
    'Phone' : [
      {
        'id' : '1234567890',
        'authenticatedState' : 'ambiguous',
        'primary' : false
      },
      {
        'id' : '5557891234',
        'authenticatedState' : 'ambiguous',
        'primary' : false
      }
    ],
    'ECID' : [
      {
        'id' : '44809014977647551167356491107014304096',
        'authenticatedState' : 'ambiguous',
        'primary' : true
      }
    ]
  }
```
**Example**
```dart
IdentityMap map = new IdentityMap();

// Add an item
IdentityItem identityItem  = new IdentityItem('user@example.com');
map.addItem(identityItem, 'Email');

// Remove an item
IdentityItem identityItem  = new IdentityItem('user@example.com');
map.removeItem(identityItem, 'Email');

//Get a list of items for a given namespace

List<IdentityItem> namespacecheck = map.getIdentityItemsForNamespace('Email');

//Get a list of all namespaces used in current IdentityMap
List<dynamic> namespaces = map.getNamespaces();

//Check if IdentityMap has no identities
bool hasNoIdentities = map.isEmpty();
```

### IdentityItem
Defines an identity to be included in an [IdentityMap](README.md#IdentityMap).

The format of the IdentityItem class is defined by the [XDM Identity Item Schema](https://experienceleague.adobe.com/docs/experience-platform/identity/home.html).

**Example**

```dart
// Initialize
IdentityItem item  = new IdentityItem('identifier');

IdentityItem item  = new IdentityItem('identifier', AuthenticatedState.AUTHENTICATED, false);

//Getters
String id = item.id;
AuthenticatedState state = item.authenticatedState;
bool primary = item.primary
```

### AuthenticatedState
Defines the state an [Identity Item](README.md#IdentityItem) is authenticated for.

The possible authenticated states are:
* AMBIGUOUS - the state is ambiguous or not defined
* AUTHENTICATED - the user is identified by a login or similar action
* LOGGED_OUT - the user was identified by a login action at a previous time, but is not logged in now

**Syntax**

```dart
enum AuthenticatedState { AUTHENTICATED, LOGGED_OUT, AMBIGUOUS }
```

**Example**
```dart
IdentityItem item  = new IdentityItem('identifier', AuthenticatedState.AUTHENTICATED, false);
```


## Frequently Asked Questions (FAQ)
For more details, refer to the [frequently asked questions page](https://aep-sdks.gitbook.io/docs/foundation-extensions/identity-for-edge-network/identity-faq) 

## Contributing
See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License
See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
