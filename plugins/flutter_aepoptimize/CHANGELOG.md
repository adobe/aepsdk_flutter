# Changelog

## 6.0.0

* iOS: Swift Package Manager is now the only supported integration. CocoaPods support (the podspec) is removed.
* Minimum supported iOS version is 15.0.
* iOS: Requires Adobe Experience Platform iOS SDKs 6.x.
* Minimum supported Flutter version is 3.47.0.

## 5.0.0

* Initial release of flutter_aepoptimize.
* Supports Adobe Experience Platform Optimize SDK for Flutter.
* APIs: `updatePropositions`, `getPropositions`, `onPropositionsUpdate`, `clearCachedPropositions`.
* Models: `DecisionScope`, `OptimizeProposition`, `Offer`, `OfferType`.
* Offer tracking: `displayed()`, `tapped()`, `generateDisplayInteractionXdm()`, `generateTapInteractionXdm()`.
* Proposition XDM: `generateReferenceXdm()`.
* Consolidated API surface with optional `timeout` parameter (covers all native overloads).
