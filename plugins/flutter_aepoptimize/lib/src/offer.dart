/*
Copyright 2025 Adobe. All rights reserved.
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

class Offer {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aepoptimize');

  final String id;
  final String etag;
  final double score;
  final String schema;
  final Map<String, dynamic>? meta;
  final OfferType type;
  final List<String>? language;
  final String content;
  final Map<String, String>? characteristics;

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

  Future<void> displayed() {
    return _channel.invokeMethod<void>('offerDisplayed', toMap());
  }

  Future<void> tapped() {
    return _channel.invokeMethod<void>('offerTapped', toMap());
  }

  Future<Map<String, dynamic>?> generateDisplayInteractionXdm() {
    return _channel
        .invokeMapMethod<String, dynamic>(
            'generateDisplayInteractionXdm', toMap())
        .then((value) => value);
  }

  Future<Map<String, dynamic>?> generateTapInteractionXdm() {
    return _channel
        .invokeMapMethod<String, dynamic>(
            'generateTapInteractionXdm', toMap())
        .then((value) => value);
  }

  @override
  String toString() => 'Offer(id: $id, type: $type, content: $content)';
}
