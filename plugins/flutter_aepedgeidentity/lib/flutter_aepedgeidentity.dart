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

/// The Adobe Experience Platform Identity for Edge Network
class Identity {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aepedgeidentity');

  /// Returns the version of the Edge extension
  static Future<String> get extensionVersion =>
      _channel.invokeMethod('extensionVersion').then((value) => value!);

  /// Returns the Experience Cloud ID. An empty string is returned if the Experience Cloud ID was previously cleared.
  static Future<String> get getExperienceCloudId =>
      _channel.invokeMethod('getExperienceCloudId').then((value) => value!);

  /// Returns the identifiers in a URL's query parameters for consumption in hybrid mobile applications.
  /// There is no leading &amp; or ? punctuation as the caller is responsible for placing the variables in their resulting URL in the correct locations.
  //To do
  /// It will be invoked once the URL Variables are available or rejected if an unexpected error occurred or the request timed out.

  static Future<String> get getUrlVariables =>
      _channel.invokeMethod('getUrlVariables').then((value) => value!);
}
