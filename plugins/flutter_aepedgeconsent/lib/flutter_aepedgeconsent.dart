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

/// Adobe Experience Platform Consent API.
class Consent {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aepedgeconsent');

  /// Returns the version of the Consent extension
  static Future<String> get extensionVersion =>
      _channel.invokeMethod('extensionVersion').then((value) => value!);

  /// Retrieves the current consent preferences stored in the Consent extension
  /// Output example: {"consents": {"collect": {"val": "y"}}}
  static Future<Map<dynamic, dynamic>> get consents => _channel
      .invokeMethod<Map<dynamic, dynamic>>('getConsents')
      .then((value) => value!);

  /// Merges the existing consents with the given consents. Duplicate keys will take the value of those passed in the API
  /// Input example: {"consents": {"collect": {"val": "y"}}}
  static Future<void> update(Map<String, dynamic> consents) =>
      _channel.invokeMethod('updateConsents', consents);
}
