/*
Copyright 2020 Adobe. All rights reserved.
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
import 'package:flutter_aepcore/flutter_aepcore_data.dart';
export 'package:flutter_aepcore/flutter_aepcore_data.dart';

/// Adobe Experience Platform Core API.
class MobileCore {
  static const MethodChannel _channel = const MethodChannel('flutter_aepcore');

  /// Gets the current Core extension version.
  static Future<String> get extensionVersion =>
      _channel.invokeMethod<String>('extensionVersion').then((value) => value!);

  /// This method sends a generic Analytics action tracking hit with context data.
  static Future<void> trackAction(
    String action, {
    Map<String, String>? data,
  }) =>
      _channel.invokeMethod(
        'track',
        {
          'type': 'action',
          'name': action,
          'data': data ?? {},
        },
      );

  /// This method sends a generic Analytics state tracking hit with context data.
  static Future<void> trackState(
    String state, {
    Map<String, String>? data,
  }) =>
      _channel.invokeMethod(
        'track',
        {
          'type': 'state',
          'name': state,
          'data': data ?? {},
        },
      );

  /// Submits a generic event containing the provided IDFA with event type `generic.identity`.
  static Future<void> setAdvertisingIdentifier(String aid) =>
      _channel.invokeMethod<void>('setAdvertisingIdentifier', aid);

  ///  Called by the extension public API to dispatch an event for other extensions or the internal SDK to consume. Any events dispatched by this call will not be processed until after `start` has been called.
  static Future<void> dispatchEvent(Event event) =>
      _channel.invokeMethod<void>('dispatchEvent', event.data);

  /// You should use this method when the Event being passed is a request and you expect an event in response. Any events dispatched by this call will not be processed until after `start` has been called.
  static Future<Event> dispatchEventWithResponseCallback(
          Event event, int timeoutMS) =>
      _channel.invokeMethod<Map<dynamic, dynamic>>(
          'dispatchEventWithResponseCallback', {
        'eventData': event.data,
        'timeout': timeoutMS,
      }).then((value) => Event(value!));

  /// Calls the provided callback with a JSON string containing all of the user's identities known by the SDK
  ///
  /// @return {String} known identifier as a JSON string
  static Future<String> get sdkIdentities =>
      _channel.invokeMethod<String>('getSdkIdentities').then((value) => value!);

  /// Get the current Adobe Mobile Privacy Status
  static Future<PrivacyStatus> get privacyStatus => _channel
      .invokeMethod<String>('getPrivacyStatus')
      .then((value) => value!.toAEPPrivacyStatus);

  /// Set the logging level of the SDK
  ///
  /// @param {AEPLogLevel} mode AEPLogLevel to be used by the SDK
  static Future<void> setLogLevel(LogLevel mode) =>
      _channel.invokeMethod('setLogLevel', mode.value);

  /// Set the Adobe Mobile Privacy status
  ///
  /// @param {AEPMobilePrivacyStatus} privacyStatus AEPMobilePrivacyStatus to be set to the SDK
  static Future<void> setPrivacyStatus(PrivacyStatus privacyStatus) =>
      _channel.invokeMethod('setPrivacyStatus', privacyStatus.value);

  /// Sets the app group used to sharing user defaults and files among containing app and extension apps.
  /// This must be called in AppDidFinishLaunching and before any other interactions with the Adobe Mobile library have happened.
  ///
  /// @param {String} appGroup to be set
  static Future<void> setAppGroup(String appGroup) =>
      _channel.invokeMethod('setAppGroup', appGroup);

  /// Submits a generic PII collection request event with type `generic.pii`.
  ///
  /// @param {Map<String, String>} a map containing the PII data
  static Future<void> collectPii(Map<String, String> data) =>
      _channel.invokeMethod('collectPii', data);

  /// Update specific configuration parameters
  ///
  /// Update the current SDK configuration with specific key/value pairs. Keys not found in the current
  /// configuration are added.
  ///
  /// Using `null` values is allowed and effectively removes the configuration parameter from the current configuration.
  ///
  /// @param  {Map<String, Object>} configMap configuration key/value pairs to be updated or added. A value of `null` has no effect.
  static Future<void> updateConfiguration(Map<String, Object> configMap) =>
      _channel.invokeMethod('updateConfiguration', configMap);

  /// Clears the changes made by `updateConfigurationWith(configDict:)` and `setPrivacyStatus(_:)` to the initial configuration
  /// provided by either `configureWith(appId:)` or `configureWith(filePath:)`
  static Future<void> clearUpdatedConfiguration() =>
      _channel.invokeMethod('clearUpdatedConfiguration');

  /// Clears all identifiers from Edge extensions and generates a new Experience Cloud ID (ECID).
  static Future<void> resetIdentities() =>
      _channel.invokeMethod('resetIdentities');
}
