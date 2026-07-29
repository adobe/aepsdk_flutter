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
import 'package:flutter_aepoptimize/src/offer_type.dart';

/// Represents a decision option (offer) contained within an
/// [OptimizeProposition].
class Offer {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aepoptimize');

  /// Unique offer identifier.
  final String id;

  /// Offer revision detail at the time of the request.
  final String etag;

  /// Offer priority score.
  final double score;

  /// The schema string describing the offer content.
  final String schema;

  /// Optional offer metadata.
  final Map<String, dynamic>? meta;

  /// The type of the offer content, see [OfferType].
  final OfferType type;

  /// Optional list of language codes for the offer content.
  final List<String>? language;

  /// The offer content string.
  final String content;

  /// Optional offer characteristics.
  final Map<String, String>? characteristics;

  String _propositionId = '';
  String _propositionScope = '';
  Map<String, dynamic> _propositionScopeDetails = {};
  Map<String, dynamic> _propositionActivity = {};
  Map<String, dynamic> _propositionPlacement = {};

  Offer({
    required this.id,
    this.etag = '',
    this.score = 0,
    this.schema = '',
    this.meta,
    this.type = OfferType.unknown,
    this.language,
    this.content = '',
    this.characteristics,
  });

  /// Creates an offer from a platform channel [map].
  factory Offer.fromMap(Map<dynamic, dynamic> map) {
    return Offer(
      id: map['id'] as String? ?? '',
      etag: map['etag'] as String? ?? '',
      score: (map['score'] as num?)?.toDouble() ?? 0,
      schema: map['schema'] as String? ?? '',
      meta: map['meta'] != null
          ? Map<String, dynamic>.from(map['meta'] as Map)
          : null,
      type: (map['type'] as int? ?? 0).toOfferType(),
      language: map['language'] != null
          ? List<String>.from(map['language'] as List)
          : null,
      content: map['content'] as String? ?? '',
      characteristics: map['characteristics'] != null
          ? Map<String, String>.from(map['characteristics'] as Map)
          : null,
    );
  }

  /// Stores the parent proposition context on this offer so it can be sent
  /// back to the native SDK when tracking. Set internally when a proposition
  /// is decoded; not intended to be called directly.
  void setPropositionContext(String propositionId, String scope,
      Map<String, dynamic> scopeDetails, Map<String, dynamic> activity,
      Map<String, dynamic> placement) {
    _propositionId = propositionId;
    _propositionScope = scope;
    _propositionScopeDetails = scopeDetails;
    _propositionActivity = activity;
    _propositionPlacement = placement;
  }

  /// Converts this offer into a map for the platform channel.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'etag': etag,
      'score': score,
      'schema': schema,
      'meta': meta,
      'type': type.rawValue,
      'language': language,
      'content': content,
      'characteristics': characteristics,
    };
  }

  /// Converts this offer, along with its parent proposition context, into a
  /// map used by the native SDK for tracking.
  Map<String, dynamic> toTrackingMap() {
    return {
      ...toMap(),
      'propositionId': _propositionId,
      'propositionScope': _propositionScope,
      'propositionScopeDetails': _propositionScopeDetails,
      'propositionActivity': _propositionActivity,
      'propositionPlacement': _propositionPlacement,
    };
  }

  /// Tracks a display interaction for this offer with the Edge Network.
  Future<void> displayed() {
    return _channel.invokeMethod<void>('offerDisplayed', toTrackingMap());
  }

  /// Tracks a tap interaction for this offer with the Edge Network.
  Future<void> tapped() {
    return _channel.invokeMethod<void>('offerTapped', toTrackingMap());
  }

  /// Generates XDM-formatted data for a display interaction of this offer.
  Future<Map<String, dynamic>?> generateDisplayInteractionXdm() {
    return _channel
        .invokeMapMethod<String, dynamic>(
            'generateDisplayInteractionXdm', toTrackingMap())
        .then((value) => value);
  }

  /// Generates XDM-formatted data for a tap interaction of this offer.
  Future<Map<String, dynamic>?> generateTapInteractionXdm() {
    return _channel
        .invokeMapMethod<String, dynamic>(
            'generateTapInteractionXdm', toTrackingMap())
        .then((value) => value);
  }

  @override
  String toString() => 'Offer(id: $id, type: $type, content: $content)';
}
