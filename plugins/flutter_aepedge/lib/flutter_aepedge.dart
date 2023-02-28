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
import 'package:flutter_aepedge/flutter_aepedge_data.dart';
export 'package:flutter_aepedge/flutter_aepedge_data.dart';

/// Adobe Experience Platform Edge Workflow API.
class Edge {
  static const MethodChannel _channel = const MethodChannel('flutter_aepedge');

  /// Returns the version of the Edge extension
  static Future<String> get extensionVersion =>
      _channel.invokeMethod('extensionVersion').then((value) => value!);

  /// Send an Experience Event to Adobe Experience Edge
  /// @param {experienceEvent} Event to be sent to Adobe Experience Edge
  /// returns the associated response handles received from the Adobe Experience Edge;
  /// it may return an empty array if no handles were returned for the given experienceEvent

  static Future<List<EventHandle>> sendEvent(
    ExperienceEvent experienceEvent,
  ) =>
      _channel
          .invokeListMethod<dynamic>('sendEvent', experienceEvent.eventData)
          .then((value) => (value ?? [])
              .map<EventHandle>((data) => EventHandle(data))
              .toList());

  /// Gets the Edge Network location hint used in requests to the Adobe Experience Platform Edge Network.
  /// The Edge Network location hint may be used when building the URL for Adobe Experience Platform Edge Network
  /// requests to hint at the server cluster to use.
  /// @return the Edge Network location hint, or null if the location hint expired or is not set.
  static Future<String?> get locationHint =>
      _channel.invokeMethod<String?>('getLocationHint').then((value) => value);

  /// Set the Edge Network location hint used in requests to the Adobe Experience Platform Edge Network.
  /// Sets the Edge Network location hint used in requests to the AEP Edge Network causing requests to "stick" to a specific server cluster.
  /// Passing null or an empty string will clear the existing location hint. Edge Network responses may overwrite the location hint to a new value when necessary to manage network traffic.
  /// Use caution when setting the location hint. Only use location hints for the 'EdgeNetwork' scope. An incorrect location hint value will cause all Edge Network requests to fail.
  /// @param {hint} the Edge Network location hint to use when connecting to the Adobe Experience Platform Edge Network
  static Future<void> setLocationHint([String? hint]) =>
      _channel.invokeMethod<void>('setLocationHint', hint);
}
