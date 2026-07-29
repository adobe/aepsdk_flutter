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

import 'dart:convert';

/// Represents a scope used to fetch personalization decisions (propositions)
/// from the Edge Network.
class DecisionScope {
  /// The encoded scope name.
  final String name;

  /// Creates a decision scope from an already-encoded scope [name].
  DecisionScope(this.name);

  /// Creates a decision scope by base64-encoding the given [activityId],
  /// [placementId], and optional [itemCount].
  DecisionScope.fromActivityAndPlacement({
    required String activityId,
    required String placementId,
    int itemCount = 1,
  }) : name = base64Encode(utf8.encode(jsonEncode({
            'activityId': activityId,
            'placementId': placementId,
            'itemCount': itemCount,
          })));

  /// Converts this decision scope into a map for the platform channel.
  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  /// Creates a decision scope from a platform channel [map].
  factory DecisionScope.fromMap(Map<dynamic, dynamic> map) {
    return DecisionScope(map['name'] as String);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DecisionScope &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'DecisionScope(name: $name)';
}
