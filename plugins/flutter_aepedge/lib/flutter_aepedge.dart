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
import 'package:flutter_aepedge/src/aepedge_eventhandle.dart';
import 'package:flutter_aepedge/src/aepedge_experienceevent.dart';

/// Adobe Experience Platform Edge Workflow API.
class Edge {
  static const MethodChannel _channel = const MethodChannel('flutter_aepedge');

  /// Returns the version of the Edge extension
  static Future<String> get extensionVersion =>
      _channel.invokeMethod('extensionVersion').then((value) => value!);

  /// Send an Experience Event to Adobe Experience Edge
  /// @param {experienceEvent} Event to be sent to Adobe Experience Edge
  /// returns the associated response handles received from the Adobe Experience Edge
  /// or rejected if an unexpected error occured; it may return an empty array
  /// if no handles were returned for the given experienceEvent

  static Future<List<EventHandle>> sendEvent(
    ExperienceEvent experienceEvent,
  ) =>
      _channel
          .invokeListMethod<dynamic>('sendEvent', experienceEvent.eventdata)
          .then((value) => (value ?? [])
              .map<EventHandle>((data) => EventHandle(data))
              .toList());
}
