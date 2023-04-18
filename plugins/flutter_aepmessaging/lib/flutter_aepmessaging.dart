/*
Copyright 2023 Adobe. All rights reserved.
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
export 'package:flutter_aepmessaging/src/aepmessaging_messaging_edge_event_type.dart';

/// Adobe Experience Platform Messaging
class Messaging {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aepmessaging');

  /// Returns the version of the Messaging extension
  static Future<String> get extensionVersion =>
      _channel.invokeMethod('extensionVersion').then((value) => value!);

  /// Initiates a network call to retrieve remote In-App Message definitions.
  static void refreshInAppMessages() =>
      _channel.invokeMethod('refreshInAppMessages');
}
