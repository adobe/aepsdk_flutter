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

/// Experience Event is the event to be sent to Adobe Experience Platform Edge Network.
class ExperienceEvent {
  static const String _xdmDataKey = 'xdmData';
  static const String _dataKey = 'data';
  static const String _datasetIdentifierKey = 'datasetIdentifier';
  static const String _datastreamIdOverrideKey = 'datastreamIdOverride';
  static const String _datastreamConfigOverrideKey = 'datastreamConfigOverride';

  /// The data in this experience event.
  late Map<String, dynamic> eventData;

  ExperienceEvent(this.eventData) {
    if (eventData[_datasetIdentifierKey] != null && (eventData[_datastreamIdOverrideKey] != null || eventData[_datastreamConfigOverrideKey] != null)) {
      print('Warning: Using both datasetIdentifier and datastreamIdOverride, or datasetIdentifier and datastreamConfigOverride simultaneously is not supported. It defaults to using the input of datastreamIdOverride or datastreamConfigOverride.');
    }
  }

  ExperienceEvent.createEvent(final Map<String, dynamic> xdmData,
      [final Map<String, dynamic>? data, final String? datasetIdentifier]) {
    final Map<String, dynamic> experienceEventConstructorData = {
      _xdmDataKey: xdmData,
      _dataKey: data,
      _datasetIdentifierKey: datasetIdentifier
    };
    this.eventData = experienceEventConstructorData;
  }

   ExperienceEvent.createEventWithOverrides(final Map<String, dynamic> xdmData,
      [final Map<String, dynamic>? data, final String? datastreamIdOverride, final Map<String, dynamic>? datastreamConfigOverride]) {
    final Map<String, dynamic> experienceEventConstructorData = {
      _xdmDataKey: xdmData,
      _dataKey: data,
      _datastreamIdOverrideKey: datastreamIdOverride,
      _datastreamConfigOverrideKey: datastreamConfigOverride
    };
    this.eventData = experienceEventConstructorData;
  }


  /// The XDM data for this event.
  Map<String, dynamic> get xdmData => eventData[_xdmDataKey] ?? {};

  /// The free-form data for this event.
  Map<String, dynamic>? get data => eventData[_dataKey] ?? {};

  /// The identifier for the Dataset this event belongs to.
  String? get datasetIdentifier => eventData[_datasetIdentifierKey];

  /// The override datastream id for this event.
  String? get datastreamIdOverride => eventData[_datastreamIdOverrideKey];

  /// The override datastream conf for this event.
  Map<String, dynamic>? get datastreamConfigOverride => eventData[_datastreamConfigOverrideKey];
}