/*
Copyright 2022 Adobe. All rights reserved.
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
import 'package:flutter_aepedgeidentity/flutter_aepedgeidentity_data.dart';

/// The Adobe Experience Platform Identity for Edge Network

class Identity {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aepedgeidentity');

  /// Returns the version of the Identity for Edge Network extension
  static Future<String> get extensionVersion =>
      _channel.invokeMethod('extensionVersion').then((value) => value!);

  /// Returns the Experience Cloud ID. An empty string is returned if the Experience Cloud ID was previously cleared.
  static Future<String> get getExperienceCloudId =>
      _channel.invokeMethod('getExperienceCloudId').then((value) => value!);

  /// Returns the identifiers in a URL's query parameters for consumption in hybrid mobile applications.
  /// There is no leading &amp; or ? punctuation as the caller is responsible for placing the variables in their resulting URL in the correct locations.
  static Future<String> get getUrlVariables =>
      _channel.invokeMethod('getUrlVariables').then((value) => value!);

  /// Returns all identifiers, including customer identifiers which were previously added.
  ///
  /// If there are no identifiers stored in the `Identity` extension, then an empty `IdentityMap` is returned.
  static Future<IdentityMap> get getIdentities => _channel
      .invokeMethod<Map<dynamic, dynamic>>('getIdentities')
      .then((value) => _toIdentityMap(value));

  /// Updates the currently known `IdentityMap` within the SDK.
  ///
  /// The Identity extension will merge the received identifiers with the previously saved one in an additive manner, no identifiers will be removed using this API.
  /// Identifiers which have an empty  `id` or empty `namespace` are not allowed and are ignored.

  static Future<void> updateIdentities(IdentityMap identityMap) =>
      _channel.invokeMethod<void>('updateIdentities', identityMap.toMap());

  /// Removes the provided identity item from the stored client-side `IdentityMap`. The Identity extension will stop sending this identifier.
  ///
  /// - Parameters:
  /// - item: The identity item to remove.
  /// - namespace: The namespace of the Identity to remove.

  static Future<void> removeIdentity(IdentityItem item, String namespace) =>
      _channel.invokeMethod<void>('removeIdentity', <dynamic, dynamic>{
        'item': item.toMap(),
        'namespace': namespace,
      });
}

IdentityMap _toIdentityMap(value) {
  IdentityMap idMap = new IdentityMap();

  for (MapEntry e in value.entries) {
    e.value.forEach((myitem) {
      AuthenticatedState auth =
          (myitem['authenticatedState'] as String).toAEPAuthState;
      IdentityItem identityItem =
          new IdentityItem(myitem['id'], auth, myitem['primary']);

      idMap.addItem(identityItem, e.key);
    });
  }

  return idMap;
}
