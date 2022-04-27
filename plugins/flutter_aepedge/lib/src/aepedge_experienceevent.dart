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
  ExperienceEvent(this.eventdata);

  ExperienceEvent.createEvent(
    final Map<dynamic, dynamic> xdmData,
    final Map<dynamic, dynamic> data,
    final String dataIdenitifer,
  ) {
    final Map<dynamic, dynamic> experienceEventConstructorData = {
      "xdmData": xdmData,
      "data": data,
      "dataIdenitifer": dataIdenitifer
    };
    this.eventdata = experienceEventConstructorData;
  }

  late Map<dynamic, dynamic> eventdata;

  /// The XDM data for this event.
  Map<dynamic, dynamic> get xdmData => eventdata['xdmData'] ?? {};

  /// The free-form data for this event.
  Map<dynamic, dynamic> get data => eventdata['data'] ?? {};

  /// XDM formatted data for this event.
  String? get dataIdenitifer => eventdata['dataIdenitifer'];
}
