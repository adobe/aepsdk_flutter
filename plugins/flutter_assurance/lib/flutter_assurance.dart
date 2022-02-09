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

/// Adobe Experience Platform Assurance API.
class FlutterAssurance {
  static const MethodChannel _channel = const MethodChannel('flutter_assurance');

  /// Gets the current AEPAssurance extension version.
  static Future<String> get extensionVersion =>
      _channel.invokeMethod('extensionVersion').then((value) => value!);


  /// Starts a AEPAssurance session.
  static Future<void> startSession(String url) {
    return _channel.invokeMethod('startSession', url);
  }
}
