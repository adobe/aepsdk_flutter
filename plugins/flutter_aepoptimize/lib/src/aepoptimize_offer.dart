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

/// This class represents the proposition option received from the decisioning services,
/// upon a personalization query to the Experience Edge network.
class Offer {
  static const String _id = 'id';
  static const String _items = 'items';
  static const String _scope = 'scope';
  static const String _scopeDetails = 'scopeDetails';

  late Map<String, dynamic> data;

  Offer(this.data);

  Offer.create(final String? name, final String? activityId,
      final String? placementId, final int? itemCount) {
    final Map<String, dynamic> decisionScopeConstructorData = {
      _id: activityId,
      _items: itemCount,
      _scope: name,
      _scopeDetails: placementId,
    };
    this.data = decisionScopeConstructorData;
  }
}
