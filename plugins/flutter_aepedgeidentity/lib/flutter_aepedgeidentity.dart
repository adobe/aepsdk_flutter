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
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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

  ///To do doc
  /// Returns the identifiers in a URL's query parameters for consumption in hybrid mobile applications.
  /// There is no leading &amp; or ? punctuation as the caller is responsible for placing the variables in their resulting URL in the correct locations.
  /// It will be invoked once the URL Variables are available or rejected if an unexpected error occurred or the request timed out.

  static Future<String> get getUrlVariables =>
      _channel.invokeMethod('getUrlVariables').then((value) => value!);

  ///To do doc
  /// @brief Returns all identifiers, including customer identifiers which were previously added.
  /// If there are no identifiers stored in the `Identity` extension, then an empty `IdentityMap` is returned.
  /// @return promise method which will be invoked once the identifiers are available or rejected if an unexpected error occurred or the request timed out.
  // static Future<Map<dynamic, dynamic>> get getIdentities => _channel
  //     .invokeMethod<Map<dynamic, dynamic>>('getIdentities')
  //     .then((value) => value!);

  static Future<IdentityMap> get getIdentities => _channel
      .invokeMethod<Map<dynamic, dynamic>>('getIdentities')
      .then((value) => toIdentityMap(value));

  ///To do doc
  /// Updates the currently known `IdentityMap` within the SDK.
  /// The Identity extension will merge the received identifiers with the previously saved one in an additive manner, no identifiers will be removed using this API.
  /// Identifiers which have an empty  `id` or empty `namespace` are not allowed and are ignored.

  //****TO Do invokeMethod for instance of identityMap which not supported in writeValue
  static Future<void> updateIdentities(IdentityMap identityMap) =>
      _channel.invokeMethod('updateIdentities', identityMap);

  /// To do doc
  /// Removes the provided identity item from the stored client-side `IdentityMap`. The Identity extension will stop sending this identifier.
  /// - Parameters:
  /// - item: The identity item to remove.
  /// - withNamespace: The namespace of the Identity to remove.

  //****TO Do invokeMethod for two arguments
  static Future<void> removeIdentities(String item, String namespace) =>
      _channel.invokeMethod('removeIdentities', <String, dynamic>{
        'item': item,
        'namespace': namespace,
      });
}

IdentityMap toIdentityMap(value) {
  IdentityMap idMap = new IdentityMap();

  for (MapEntry e in value.entries) {
    e.value.forEach((myitem) {
      if (myitem["authenticatedState"] == "authenticated") {
        myitem["authenticatedState"] = AuthenticatedState.AUTHENTICATED;
      } else if (myitem["authenticatedState"] == "loggedout") {
        myitem["authenticatedState"] = AuthenticatedState.LOGGED_OUT;
      } else if (myitem["authenticatedState"] == "ambiguous") {
        myitem["authenticatedState"] = AuthenticatedState.AMBIGOUS;
      } else {
        myitem["authenticatedState"] = AuthenticatedState.AMBIGOUS;
      }

      IdentityItem identityItem = new IdentityItem(
          myitem["id"], myitem["authenticatedState"], myitem["primary"]);

      idMap.addItem(identityItem, e.key);
    });
  }

  return idMap;
}
