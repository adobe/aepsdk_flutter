import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_aepoptimize/flutter_aepoptimize_data.dart';
export 'package:flutter_aepoptimize/flutter_aepoptimize_data.dart';

/// Adobe Experience Platform Optimize API.
class Optimize {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aepoptimize');

  /// Returns the version of the Optimize extension
  static Future<String> get extensionVersion =>
      _channel.invokeMethod('extensionVersion').then((value) => value!);

  /// Clears out cached Propositions
  static Future<void> clearCachedPropositions() =>
      _channel.invokeMethod('clearCachedPropositions');

  /// Retrieves Propositions for given decision scopes
  static Future<List<Proposition>> getPropositions(
      List<DecisionScope> decisionScopes) {
    return _channel.invokeListMethod<Map<String, dynamic>>('getPropositions', {
      'decisionScopes': decisionScopes.map((ds) => ds.asMap).toList()
    }).then((value) {
      log(value.toString());
      return (value ?? [])
          .map<Proposition>((data) => Proposition(data))
          .toList();
    });
  }

  static Future<void> onPropositionsUpdate() {
    return _channel.invokeMethod('onPropositionsUpdate');
  }

  /// Updates Propositions for given decision scopes
  static Future<void> updatePropositions(List<DecisionScope> decisionScopes,
      Map<String, Object>? xdm, Map<String, Object>? data) {
    var arguments = {
      'decisionScopes': decisionScopes.map((ds) => ds.asMap).toList(),
      'xdm': xdm,
      'data': data,
    };
    return _channel.invokeMethod('updatePropositions', arguments);
  }
}
