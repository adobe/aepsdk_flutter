/// Copyright 2023 Adobe. All rights reserved.
/// This file is licensed to you under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License. You may obtain a copy
/// of the License at http://www.apache.org/licenses/LICENSE-2.0
/// Unless required by applicable law or agreed to in writing, software distributed under
/// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
/// OF ANY KIND, either express or implied. See the License for the specific language
/// governing permissions and limitations under the License.

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter_aepmessaging/src/aepmessaging_message.dart';
import 'package:flutter_aepmessaging/src/aepmessaging_messaging_delegate.dart';
export 'package:flutter_aepmessaging/src/aepmessaging_message.dart';
export 'package:flutter_aepmessaging/src/aepmessaging_messaging_edge_event_type.dart';
export 'package:flutter_aepmessaging/src/aepmessaging_messaging_delegate.dart';
export 'package:flutter_aepmessaging/src/aepmessaging_showable.dart';

/// Adobe Experience Platform Messaging
class Messaging {
  static const MethodChannel _channel = MethodChannel('flutter_aepmessaging');

  static MessagingDelegate? _delegate;

  static Future<dynamic> Function(MethodCall)? _methodCallHandler =
      (MethodCall call) async {
    Map<dynamic, dynamic> arguments = call.arguments;
    switch (call.method) {
      case 'onDismiss':
        _delegate?.onDismiss(Message.fromMap(arguments['message']));
        return null;
      case 'onShow':
        _delegate?.onShow(Message.fromMap(arguments['message']));
        return null;
      case 'shouldSaveMessage':
        return _delegate
                ?.shouldSaveMessage(Message.fromMap(arguments['message'])) ??
            false;
      case 'shouldShowMessage':
        return _delegate
                ?.shouldShowMessage(Message.fromMap(arguments['message'])) ??
            true;
      case 'urlLoaded':
        if (Platform.isIOS) {
          _delegate?.urlLoaded(
              arguments['url'], Message.fromMap(arguments['message']));
        }
        return null;
      case 'onContentLoaded':
        if (Platform.isAndroid) {
          _delegate?.onContentLoaded(Message.fromMap(arguments['message']));
        }
        return null;
      default:
        throw UnimplementedError('${call.method} has not been implemented');
    }
  };

  /// Returns the version of the Messaging extension
  static Future<String> get extensionVersion =>
      _channel.invokeMethod('extensionVersion').then((value) => value!);

  /// Returns a list of messages currently cached in-memory
  static Future<List<Message>> getCachedMessages() =>
      _channel.invokeListMethod('getCachedMessages').then((result) =>
          (result ?? []).map((val) => Message.fromMap(val)).toList());

  /// Initiates a network call to retrieve remote In-App Message definitions.
  static void refreshInAppMessages() =>
      _channel.invokeMethod('refreshInAppMessages');

  static void setMessagingDelegate(MessagingDelegate? delegate) {
    _delegate = delegate;
    _channel.setMethodCallHandler(_methodCallHandler);
  }
}
