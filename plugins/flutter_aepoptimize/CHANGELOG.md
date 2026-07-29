# Changelog

## 5.0.0

* Initial release of flutter_aepoptimize.
* Supports Adobe Experience Platform Optimize SDK for Flutter.
* APIs: `updatePropositions`, `getPropositions`, `onPropositionsUpdate`, `clearCachedPropositions`.
* Models: `DecisionScope`, `OptimizeProposition`, `Offer`, `OfferType`.
* Offer tracking: `displayed()`, `tapped()`, `generateDisplayInteractionXdm()`, `generateTapInteractionXdm()`.
* Proposition XDM: `generateReferenceXdm()`.
* Consolidated API surface with optional `timeout` parameter (covers all native overloads).
