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

import 'dart:async';
import 'package:flutter/services.dart';

/// Adobe Experience Platform UserProfile API.
class UserProfile {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aepuserprofile');

  /// Gets the current User Profile extension version.
  static Future<String> get extensionVersion =>
      _channel.invokeMethod<String>('extensionVersion').then((value) => value!);

  /// Get the user attributes as JSON string
  /// - Parameters:
  ///   - attributeNames: Attribute keys/names which will be used to retrieve user attributes
  static Future<String> getUserAttributes(List<String> attributeKeys) =>
      _channel
          .invokeMethod<String>('getUserAttributes', attributeKeys)
          .then((value) => value!);

  /// Remove the given user attributes.
  /// If the attribute does not exist, then user profile module ignores the event. No shared state or user profile response event is dispatched
  /// If the attribute exists, then the User Attribute will be removed, shared state is updated and user profile response event is dispatched
   /// - Parameter attributeNames: attribute keys/names which have to be removed.
  static Future<void> removeUserAttributes(List<String> attributeName) =>
      _channel.invokeMethod<void>('removeUserAttributes', attributeName);

  ///  Updates user attributes.
  ///  If the attribute does not exist, it will be created.
  ///  If the attribute already exists, then the value will be updated.
  ///
  /// - Parameter attributeDict: the dictionary containing attribute key-value pairs
  static Future<void> updateUserAttributes(Map<String, Object> attributeMap) =>
      _channel.invokeMethod<void>('updateUserAttributes', attributeMap);
}
