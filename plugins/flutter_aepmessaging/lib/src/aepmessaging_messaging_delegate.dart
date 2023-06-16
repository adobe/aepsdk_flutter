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

import 'package:flutter_aepmessaging/src/aepmessaging_showable.dart';

/// UI Message delegate which is used to listen for current message lifecycle events
abstract class MessagingDelegate {
  /// Invoked when any [message] is dismissed
  void onDismiss(Showable message);

  /// Invoked when the any [message] is displayed
  void onShow(Showable message);

  /// Used to determine whether a [message] should be cached in-memory;
  /// If the result of the function of true, the [message] will be cached
  ///
  /// Note: In order to use any of the functionality of the [message], message
  /// must be cached
  bool shouldSaveMessage(Showable message);

  /// Used to find whether a [message] should be shown or not.
  /// If the result of the function is true, the [message] will be shown.
  bool shouldShowMessage(Showable message);

  /// Called when [message] loads a [URL]
  void urlLoaded(String url, Showable message);
}
