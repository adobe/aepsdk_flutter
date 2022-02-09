/*
Copyright 2020 Adobe. All rights reserved.
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
import 'package:flutter_aepcore/src/aepmobile_visitor_id.dart';

/// Adobe Experience Platform Identity API.
class FlutterAEPIdentity {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aepidentity');

  /// Gets the current Identity extension version.
  static Future<String> get extensionVersion async =>
      await _channel.invokeMethod('extensionVersion');

  /// Appends Adobe visitor information to the query component of the specified URL.
  static Future<String> appendToUrl(String url) =>
      _channel.invokeMethod<String>('appendToUrl', url).then((value) => value!);

  /// Returns all customer identifiers that were previously synced with the Adobe Experience Cloud.
  static Future<List<AEPMobileVisitorId>> get identifiers => _channel
      .invokeListMethod<dynamic>(
        'getIdentifiers',
      )
      .then((value) => (value ?? [])
          .map<AEPMobileVisitorId>((data) => AEPMobileVisitorId(data))
          .toList());

  /// Returns the Experience Cloud ID.
  static Future<String> get experienceCloudId => _channel
      .invokeMethod<String>('getExperienceCloudId')
      .then((value) => value!);

  /// Updates the given customer ID with the Adobe Experience Cloud ID Service.
  static Future<void> syncIdentifier(
    String identifierType,
    String identifier,
    AEPMobileVisitorAuthState authState,
  ) =>
      _channel.invokeMethod<void>('syncIdentifier', {
        'identifierType': identifierType,
        'identifier': identifier,
        'authState': authState.value
      });

  /// Updates the given customer IDs with the Adobe Experience Cloud ID Service.
  static Future<void> syncIdentifiers(Map<String, String> identifiers) =>
      _channel.invokeMethod<void>('syncIdentifiers', identifiers);

  /// Updates the given customer IDs with the Adobe Experience Cloud ID Service.
  static Future<void> syncIdentifiersWithAuthState(
    Map<String, String> identifiers,
    AEPMobileVisitorAuthState authState,
  ) =>
      _channel.invokeMethod<void>(
        'syncIdentifiersWithAuthState',
        {
          'identifiers': identifiers,
          'authState': authState.value,
        },
      );

  /// Gets Visitor ID Service identifiers in URL query string form for consumption in hybrid mobile apps.
  static Future<String> get urlVariables =>
      _channel.invokeMethod<String>('urlVariables').then((value) => value!);
}
