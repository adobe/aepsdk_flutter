/*
Copyright 2026 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

import 'package:flutter/services.dart';
import 'package:flutter_aepoptimize/src/decision_scope.dart';
import 'package:flutter_aepoptimize/src/offer.dart';

/// Represents the propositions received from the Edge Network for a given
/// [DecisionScope].
class OptimizeProposition {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aepoptimize');

  /// Unique proposition identifier.
  final String id;

  /// The list of offers contained in this proposition.
  final List<Offer> offers;

  /// The decision scope string this proposition was returned for.
  final String scope;

  /// Scope details used for tracking this proposition.
  final Map<String, dynamic> scopeDetails;

  /// Activity details associated with this proposition.
  final Map<String, dynamic> activity;

  /// Placement details associated with this proposition.
  final Map<String, dynamic> placement;

  OptimizeProposition({
    required this.id,
    required this.offers,
    required this.scope,
    this.scopeDetails = const {},
    this.activity = const {},
    this.placement = const {},
  });

  /// Creates a proposition from a platform channel [map].
  factory OptimizeProposition.fromMap(Map<dynamic, dynamic> map) {
    final propId = map['id'] as String? ?? '';
    final propScope = map['scope'] as String? ?? '';
    final propScopeDetails = map['scopeDetails'] != null
        ? Map<String, dynamic>.from(map['scopeDetails'] as Map)
        : <String, dynamic>{};
    final propActivity = map['activity'] != null
        ? Map<String, dynamic>.from(map['activity'] as Map)
        : <String, dynamic>{};
    final propPlacement = map['placement'] != null
        ? Map<String, dynamic>.from(map['placement'] as Map)
        : <String, dynamic>{};

    final offersList = (map['items'] as List<dynamic>?)
            ?.map((o) => Offer.fromMap(Map<dynamic, dynamic>.from(o as Map)))
            .toList() ??
        [];

    for (final offer in offersList) {
      offer.setPropositionContext(
          propId, propScope, propScopeDetails, propActivity, propPlacement);
    }

    return OptimizeProposition(
      id: propId,
      offers: offersList,
      scope: propScope,
      scopeDetails: propScopeDetails,
      activity: propActivity,
      placement: propPlacement,
    );
  }

  /// Converts this proposition into a map for the platform channel.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': offers.map((o) => o.toMap()).toList(),
      'scope': scope,
      'scopeDetails': scopeDetails,
      'activity': activity,
      'placement': placement,
    };
  }

  /// Generates XDM-formatted data for the `Experience Event - Proposition
  /// Reference` field group for this proposition.
  Future<Map<String, dynamic>?> generateReferenceXdm() {
    return _channel
        .invokeMapMethod<String, dynamic>('generateReferenceXdm', toMap())
        .then((value) => value);
  }

  @override
  String toString() =>
      'OptimizeProposition(id: $id, scope: $scope, offers: ${offers.length})';
}
