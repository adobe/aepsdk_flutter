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

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_aepoptimize/flutter_aepoptimize_data.dart';
export 'package:flutter_aepoptimize/flutter_aepoptimize_data.dart';

/// Adobe Experience Platform Optimize API.
class Optimize {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aepoptimize');

  static void Function(Map<DecisionScope, OptimizeProposition>)?
      _onPropositionsUpdateCallback;

  static Future<dynamic> Function(MethodCall)? _methodCallHandler =
      (MethodCall call) async {
    switch (call.method) {
      case 'onPropositionsUpdate':
        if (_onPropositionsUpdateCallback != null) {
          final rawMap = call.arguments as Map<dynamic, dynamic>;
          _onPropositionsUpdateCallback!(_decodePropositionsMap(rawMap));
        }
        return null;
      default:
        throw UnimplementedError('${call.method} has not been implemented');
    }
  };

  /// Returns the version of the AEPOptimize extension.
  static Future<String> get extensionVersion =>
      _channel.invokeMethod<String>('extensionVersion').then((value) => value!);

  /// Fetches propositions from the Edge Network for the given [decisionScopes].
  ///
  /// Optional [xdm] and [data] are included in the personalization query request.
  /// Optional [timeout] in seconds overrides the default network timeout.
  /// Returns a map of decision scopes to their propositions on success.
  static Future<Map<DecisionScope, OptimizeProposition>?> updatePropositions(
    List<DecisionScope> decisionScopes, {
    Map<String, dynamic>? xdm,
    Map<String, dynamic>? data,
    double? timeout,
  }) {
    return _channel.invokeMapMethod<dynamic, dynamic>('updatePropositions', {
      'decisionScopes': decisionScopes.map((s) => s.toMap()).toList(),
      'xdm': xdm,
      'data': data,
      'timeout': timeout,
    }).then((value) {
      if (value == null) return null;
      return _decodePropositionsMap(value);
    });
  }

  /// Retrieves previously fetched propositions from the SDK cache for the
  /// given [decisionScopes].
  ///
  /// Optional [timeout] in seconds overrides the default timeout.
  static Future<Map<DecisionScope, OptimizeProposition>?> getPropositions(
    List<DecisionScope> decisionScopes, {
    double? timeout,
  }) {
    return _channel.invokeMapMethod<dynamic, dynamic>('getPropositions', {
      'decisionScopes': decisionScopes.map((s) => s.toMap()).toList(),
      'timeout': timeout,
    }).then((value) {
      if (value == null) return null;
      return _decodePropositionsMap(value);
    });
  }

  /// Registers a persistent listener that is invoked whenever propositions
  /// are updated in the SDK cache.
  static void onPropositionsUpdate(
    void Function(Map<DecisionScope, OptimizeProposition>) callback,
  ) {
    _onPropositionsUpdateCallback = callback;
    _channel.setMethodCallHandler(_methodCallHandler);
    _channel.invokeMethod<void>('registerOnPropositionsUpdate');
  }

  /// Clears the client-side propositions cache.
  static Future<void> clearCachedPropositions() {
    return _channel.invokeMethod<void>('clearCachedPropositions');
  }

  /// Tracks display events for the given [offers] in a single batch.
  ///
  /// Offers can belong to different propositions; the SDK de-duplicates
  /// them into unique propositions before dispatching the tracking event.
  static Future<void> displayed(List<Offer> offers) {
    return _channel.invokeMethod<void>(
        'batchDisplayed', offers.map((o) => o.toTrackingMap()).toList());
  }

  /// Generates XDM-formatted data for display interactions of the given
  /// [offers] in a single batch.
  static Future<Map<String, dynamic>?> generateDisplayInteractionXdm(
      List<Offer> offers) {
    return _channel.invokeMapMethod<String, dynamic>(
        'batchGenerateDisplayInteractionXdm',
        offers.map((o) => o.toTrackingMap()).toList());
  }

  static Map<DecisionScope, OptimizeProposition> _decodePropositionsMap(
    Map<dynamic, dynamic> rawMap,
  ) {
    final result = <DecisionScope, OptimizeProposition>{};
    rawMap.forEach((key, value) {
      final scope = DecisionScope(key as String);
      final proposition = OptimizeProposition.fromMap(
          Map<dynamic, dynamic>.from(value as Map));
      result[scope] = proposition;
    });
    return result;
  }
}
