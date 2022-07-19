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

/// EventHandle is the response returned from Adobe Experience Platform Edge Network.
class EventHandle {
  EventHandle(this.data);

  EventHandle.createEvent(
    final String? type,
    final List<dynamic>? payload,
  ) {
    final Map<String, dynamic> eventHandleConstructorData = {
      "type": type,
      "payload": payload
    };
    this.data = eventHandleConstructorData;
  }

  /// The data in the eventHandle response.
  late Map<dynamic, dynamic> data;

  /// The type of the eventHandle response.
  String? get type => data['type'];

  /// The payload of the eventHanlde response.
  List<dynamic>? get payload => data['payload'] ?? {};

  @override
  String toString() => '$runtimeType($data)';
}