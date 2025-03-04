/*
Copyright 2025 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

/// Configuration options for initializing the Adobe Mobile SDK. 
class InitOptions {
  /// The App ID for the Adobe SDK configuration.
  String? appId;
  /// Flag indicating whether automatic lifecycle tracking is enabled
  bool? lifecycleAutomaticTrackingEnabled;
  /// Additional context data to be included in lifecycle start event.
  Map<String, String>? lifecycleAdditionalContextData;
  /// App group used to share user defaults and files among containing app and extension apps on iOS
  String? appGroupIOS;

  /// Constructor with named optional parameters.
  InitOptions({
    this.appId,
    this.lifecycleAutomaticTrackingEnabled = null,
    this.lifecycleAdditionalContextData = null, 
    this.appGroupIOS = null,
  });

  /// Converts the [InitOptions] instance to a [Map].
  Map<String, dynamic> toMap() {
    Map<String, dynamic> retMap = {};
    retMap['appId'] = appId;
    retMap['lifecycleAutomaticTrackingEnabled'] = lifecycleAutomaticTrackingEnabled;
    retMap['lifecycleAdditionalContextData'] = lifecycleAdditionalContextData;
    retMap['appGroupIOS'] = appGroupIOS;

    return retMap;
  }
}
