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
  ExperienceEvent(this.eventData);

  ExperienceEvent.createEvent(final Map<String, dynamic> xdmData,
      [final Map<String, dynamic>? data, final String? datasetIdentifier]) {
    final Map<String, dynamic> experienceEventConstructorData = {
      "xdmdata": xdmData,
      "data": data,
      "dataIdentifier": datasetIdentifier
    };
    this.eventData = experienceEventConstructorData;
  }

  /// The data in this experience event.
  late Map<String, dynamic> eventData;

  /// The XDM data for this event.
  Map<String, dynamic> get xdmData => eventData['xdmData'] ?? {};

  /// The free-form data for this event.
  Map<String, dynamic>? get data => eventData['data'] ?? {};

  /// The identifier for the Dataset this event belongs to.
  String? get datasetIdentifier => eventData['datasetIdentifier'];
}
