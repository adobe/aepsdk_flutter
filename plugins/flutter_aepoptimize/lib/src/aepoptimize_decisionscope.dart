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

/// Represents a decision scope used to fetch personalized offers from the Experience Edge network.
class DecisionScope {
  static const String _name = 'name';
  static const String _activityId = 'activityId';
  static const String _placementId = 'placementId';
  static const String _itemCount = 'itemCount';

  late Map<String, dynamic> data;

  DecisionScope(this.data);

  String? get activityId => data[_activityId];

  Map<String, dynamic> get asMap => data;

  int? get itemCount => data[_itemCount];

  String? get name => data[_name];

  String? get placementId => data[_placementId];
}
