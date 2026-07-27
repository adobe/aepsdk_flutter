# flutter_aepoptimize

[![pub package](https://img.shields.io/pub/v/flutter_aepoptimize.svg)](https://pub.dartlang.org/packages/flutter_aepoptimize) ![Build](https://github.com/adobe/aepsdk_flutter/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepoptimize` is a flutter plugin for the iOS and Android [Adobe Experience Platform Optimize SDK](https://developer.adobe.com/client-sdks/documentation/adobe-journey-optimizer-decisioning/) to allow for integration with Flutter applications. Functionality to enable the Optimize extension is provided entirely through Dart documented below.

The Optimize extension enables real-time personalization workflows in your mobile applications by leveraging Adobe Target and Adobe Journey Optimizer Offer Decisioning.

## Prerequisites

The Optimize extension has the following peer dependencies, which must be installed prior to installing it:

- [flutter_aepcore](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepcore/README.md)
- [flutter_aepedge](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepedge/README.md)

## Installation

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepoptimize/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Usage

For more detailed information on the Optimize APIs, visit the documentation [here](https://developer.adobe.com/client-sdks/documentation/adobe-journey-optimizer-decisioning/)

### Importing the extension:

In your Flutter application, import the Optimize extension as follows:

```dart
import 'package:flutter_aepoptimize/flutter_aepoptimize.dart';
```

### Initializing with SDK:

To initialize the SDK, use the following methods:
- [MobileCore.initializeWithAppId(appId)](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepcore#initializewithappid)
- [MobileCore.initialize(initOptions)](https://github.com/adobe/aepsdk_flutter/tree/main/plugins/flutter_aepcore#initialize)

Refer to the root [Readme](https://github.com/adobe/aepsdk_flutter/blob/main/README.md) for more information about the SDK setup.

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
### updatePropositions
Fetches the propositions for the provided decision scopes from the Adobe Experience Platform Edge Network. The returned propositions are cached in-memory in the Optimize SDK and can be retrieved using `getPropositions`.

**Syntax**
```dart
static Future<Map<DecisionScope, OptimizeProposition>?> updatePropositions(
  List<DecisionScope> decisionScopes,
  {Map<String, dynamic>? xdm,
   Map<String, dynamic>? data,
   double? timeout}
)
```

**Example**
```dart
final decisionScopes = [
  DecisionScope('myMbox'),
  DecisionScope('anotherMbox'),
];

try {
  Map<DecisionScope, OptimizeProposition>? propositions =
      await Optimize.updatePropositions(decisionScopes);
} on PlatformException {
  print("Failed to update propositions");
}
```

**Example with XDM and data**
```dart
final decisionScopes = [DecisionScope('myMbox')];

Map<String, dynamic> xdm = {"eventType": "personalization.request"};
Map<String, dynamic> data = {"key": "value"};

Map<DecisionScope, OptimizeProposition>? propositions =
    await Optimize.updatePropositions(decisionScopes, xdm: xdm, data: data);
```

**Example with timeout**
```dart
final decisionScopes = [DecisionScope('myMbox')];

Map<DecisionScope, OptimizeProposition>? propositions =
    await Optimize.updatePropositions(decisionScopes, timeout: 10.0);
```
------
### getPropositions
Retrieves the previously fetched propositions from the in-memory SDK cache for the provided decision scopes. If a certain decision scope has not been fetched yet in the current session, its entry will not exist in the returned map.

**Syntax**
```dart
static Future<Map<DecisionScope, OptimizeProposition>?> getPropositions(
  List<DecisionScope> decisionScopes,
  {double? timeout}
)
```

**Example**
```dart
final decisionScopes = [
  DecisionScope('myMbox'),
  DecisionScope('anotherMbox'),
];

try {
  Map<DecisionScope, OptimizeProposition>? propositions =
      await Optimize.getPropositions(decisionScopes);
} on PlatformException {
  print("Failed to get propositions");
}
```
------
### onPropositionsUpdate
Registers a persistent listener that is invoked whenever the propositions are updated in the SDK cache. This is useful for listening to real-time proposition changes, such as those triggered by `updatePropositions`.

**Syntax**
```dart
static void onPropositionsUpdate(
  void Function(Map<DecisionScope, OptimizeProposition>) callback
)
```

**Example**
```dart
Optimize.onPropositionsUpdate((propositions) {
  propositions.forEach((scope, proposition) {
    print('Scope: ${scope.name}');
    for (var offer in proposition.offers) {
      print('Offer content: ${offer.content}');
    }
  });
});
```
------
### clearCachedPropositions
Clears the client-side in-memory propositions cache.

**Syntax**
```dart
static Future<void> clearCachedPropositions()
```

**Example**
```dart
await Optimize.clearCachedPropositions();
```
------
### displayed (batch)
Sends display tracking events to the Adobe Experience Platform Edge Network for the provided list of offers. Use this method to report that multiple offers were displayed simultaneously.

**Syntax**
```dart
static Future<void> displayed(List<Offer> offers)
```

**Example**
```dart
// After retrieving propositions, track display for all offers at once
List<Offer> allOffers = [];
propositions?.forEach((scope, proposition) {
  allOffers.addAll(proposition.offers);
});

await Optimize.displayed(allOffers);
```
------
### generateDisplayInteractionXdm (batch)
Generates a map containing XDM-formatted data for `Experience Event - Proposition Interactions` field group, with the display event type for the provided list of offers.

**Syntax**
```dart
static Future<Map<String, dynamic>?> generateDisplayInteractionXdm(List<Offer> offers)
```

**Example**
```dart
List<Offer> allOffers = [];
propositions?.forEach((scope, proposition) {
  allOffers.addAll(proposition.offers);
});

Map<String, dynamic>? xdm = await Optimize.generateDisplayInteractionXdm(allOffers);
```

## Public Classes

### DecisionScope
`DecisionScope` represents a decision scope used to fetch personalization propositions from the Adobe Experience Platform Edge Network. For Target mboxes, the scope name is the mbox name. For Offer Decisioning, the scope name is a base64-encoded JSON string containing activity and placement IDs.

**Syntax**
```dart
// Create with a scope name string (e.g. Target mbox name or encoded ODE scope)
DecisionScope(String name)

// Create from an activity ID and placement ID (for Offer Decisioning)
DecisionScope.fromActivityAndPlacement({
  required String activityId,
  required String placementId,
  int itemCount = 1,
})
```

**Example**
```dart
// Target mbox scope
final mboxScope = DecisionScope('myTargetMbox');

// Offer Decisioning scope using convenience constructor
final odeScope = DecisionScope.fromActivityAndPlacement(
  activityId: 'dps:offer-activity:1a789ada14845b06',
  placementId: 'dps:offer-placement:1a78674ab508506c',
  itemCount: 3,
);

// Offer Decisioning scope using pre-encoded string
final encodedScope = DecisionScope('eyJ4ZG06YWN0aXZpdHlJZCI6Ii4uLiJ9');
```
------
### OptimizeProposition
`OptimizeProposition` represents the response from the Edge Network for a given decision scope. It contains a list of offers along with scope details used for tracking.

**Properties**

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Unique proposition identifier |
| `offers` | `List<Offer>` | List of offers for this proposition |
| `scope` | `String` | The decision scope string |
| `scopeDetails` | `Map<String, dynamic>` | Additional scope details (e.g. activity info, event tokens) |

**Example**
```dart
// Propositions are typically obtained from updatePropositions or getPropositions
Map<DecisionScope, OptimizeProposition>? propositions =
    await Optimize.getPropositions([DecisionScope('myMbox')]);

propositions?.forEach((scope, proposition) {
  print('Proposition ID: ${proposition.id}');
  print('Scope: ${proposition.scope}');
  print('Number of offers: ${proposition.offers.length}');
});
```

#### generateReferenceXdm
Generates a map containing XDM-formatted data for `Experience Event - Proposition Reference` field group for this proposition.

**Syntax**
```dart
Future<Map<String, dynamic>?> generateReferenceXdm()
```

**Example**
```dart
Map<String, dynamic>? referenceXdm = await proposition.generateReferenceXdm();
```
------
### Offer
`Offer` represents an individual personalization offer returned in a proposition. An offer contains content (which may be text, HTML, JSON, or an image URL) and metadata such as its type, schema, and tracking characteristics.

**Properties**

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Unique offer identifier |
| `etag` | `String` | Offer ETag for caching |
| `score` | `double` | Offer priority score |
| `schema` | `String` | Offer schema string |
| `meta` | `Map<String, dynamic>?` | Optional metadata |
| `type` | `OfferType` | Content type of the offer |
| `language` | `List<String>?` | Supported languages |
| `content` | `String` | The offer content |
| `characteristics` | `Map<String, String>?` | Additional characteristics |

**Example**
```dart
propositions?.forEach((scope, proposition) {
  for (var offer in proposition.offers) {
    print('Offer ID: ${offer.id}');
    print('Type: ${offer.type}');
    print('Content: ${offer.content}');
  }
});
```

#### displayed (single)
Sends a display tracking event to the Adobe Experience Platform Edge Network for this offer.

**Syntax**
```dart
Future<void> displayed()
```

**Example**
```dart
Offer offer = proposition.offers.first;
await offer.displayed();
```

#### tapped
Sends a tap/click tracking event to the Adobe Experience Platform Edge Network for this offer.

**Syntax**
```dart
Future<void> tapped()
```

**Example**
```dart
Offer offer = proposition.offers.first;
await offer.tapped();
```

#### generateDisplayInteractionXdm (single)
Generates a map containing XDM-formatted data for `Experience Event - Proposition Interactions` field group, with the display event type for this offer.

**Syntax**
```dart
Future<Map<String, dynamic>?> generateDisplayInteractionXdm()
```

**Example**
```dart
Map<String, dynamic>? xdm = await offer.generateDisplayInteractionXdm();
```

#### generateTapInteractionXdm
Generates a map containing XDM-formatted data for `Experience Event - Proposition Interactions` field group, with the tap event type for this offer.

**Syntax**
```dart
Future<Map<String, dynamic>?> generateTapInteractionXdm()
```

**Example**
```dart
Map<String, dynamic>? xdm = await offer.generateTapInteractionXdm();
```
------
### OfferType
`OfferType` is an enum representing the content type of the offer.

| Value | Raw Value | MIME Type |
|-------|-----------|-----------|
| `unknown` | 0 | `*/*` |
| `json` | 1 | `application/json` |
| `text` | 2 | `text/plain` |
| `html` | 3 | `text/html` |
| `image` | 4 | `image/*` |

**Example**
```dart
for (var offer in proposition.offers) {
  switch (offer.type) {
    case OfferType.json:
      // Parse JSON content
      break;
    case OfferType.html:
      // Render HTML content
      break;
    case OfferType.text:
      // Display text content
      break;
    case OfferType.image:
      // Load image from URL
      break;
    default:
      break;
  }
}
```

## Tests

Run:

```bash
flutter test
```

## Contributing
See [CONTRIBUTING](https://github.com/adobe/aepsdk_flutter/blob/main/CONTRIBUTING.md)

## License
See [LICENSE](https://github.com/adobe/aepsdk_flutter/blob/main/LICENSE)
