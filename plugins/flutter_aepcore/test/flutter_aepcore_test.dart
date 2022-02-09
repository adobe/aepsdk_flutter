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

import 'package:flutter/services.dart';
import 'package:flutter_aepcore/flutter_aepcore.dart';
import 'package:flutter_aepcore/src/aepextension_event.dart';
import 'package:flutter_aepcore/src/aepmobile_logging_level.dart';
import 'package:flutter_aepcore/src/aepmobile_privacy_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_aepcore');

  TestWidgetsFlutterBinding.ensureInitialized();

  group('extensionVersion', () {
    final String testVersion = "2.5.0";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return testVersion;
      });
    });

    test('invokes correct method', () async {
      await FlutterAEPCore.extensionVersion;

      expect(log, <Matcher>[
        isMethodCall(
          'extensionVersion',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await FlutterAEPCore.extensionVersion, testVersion);
    });
  });

  group('trackAction', () {
    final String testAction = "myTestAction";
    final Map<String, String> testContextData = {
      "context1Key": "context1Value"
    };
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await FlutterAEPCore.trackAction(testAction, data: testContextData);

      expect(log, <Matcher>[
        isMethodCall(
          'track',
          arguments: {
            "type": "action",
            "name": testAction,
            "data": testContextData
          },
        ),
      ]);
    });
  });

  group('trackState', () {
    final String testState = "myTestState";
    final Map<String, String> testContextData = {
      "context1Key": "context1Value"
    };
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await FlutterAEPCore.trackState(testState, data: testContextData);

      expect(log, <Matcher>[
        isMethodCall(
          'track',
          arguments: {
            "type": "state",
            "name": testState,
            "data": testContextData
          },
        ),
      ]);
    });
  });

  group('setAdvertisingIdentifier', () {
    final String testAdId = "test-aid";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await FlutterAEPCore.setAdvertisingIdentifier(testAdId);

      expect(log, <Matcher>[
        isMethodCall(
          'setAdvertisingIdentifier',
          arguments: testAdId,
        ),
      ]);
    });
  });

  group('dispatchEvent', () {
    final Map<dynamic, dynamic> eventConstructorData = {
      "eventName": "testresponseEvent",
      "eventType": "testresponseEvent",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    };
    final AEPEvent expectedEvent =
        AEPEvent(eventConstructorData);
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return true;
      });
    });

    test('invokes correct method', () async {
      await FlutterAEPCore.dispatchEvent(expectedEvent);

      expect(log, <Matcher>[
        isMethodCall(
          'dispatchEvent',
          arguments: eventConstructorData,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await FlutterAEPCore.dispatchEvent(expectedEvent), true);
    });
  });

  group('dispatchEventWithResponseCallback', () {
    final Map<dynamic, dynamic> eventConstructorData = {
      "eventName": "testresponseEvent",
      "eventType": "testresponseEvent",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    };
    final AEPEvent expectedEvent =
        AEPEvent(eventConstructorData);
    final AEPEvent returnedEvent = AEPEvent({
      "eventName": "testrequestEvent",
      "eventType": "testrequestEvent",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return returnedEvent.data;
      });
    });

    test('invokes correct method', () async {
      await FlutterAEPCore.dispatchEventWithResponseCallback(expectedEvent);

      expect(log, <Matcher>[
        isMethodCall(
          'dispatchEventWithResponseCallback',
          arguments: eventConstructorData,
        ),
      ]);
    });

    test('returns correct result', () async {
      final actualEvent =
          await FlutterAEPCore.dispatchEventWithResponseCallback(expectedEvent);
      expect(actualEvent.eventName, returnedEvent.eventName);
    });
  });

  group('AEPEvent', () {
    final String eventName = "testEventName";
    final String eventType = "testEventType";
    final String eventSource = "testEventSource";
    final Map<dynamic, dynamic> eventData = {"testEventKey": "testEventValue"};
    final Map<dynamic, dynamic> eventConstructorData = {
      "eventName": eventName,
      "eventType": eventType,
      "eventSource": eventSource,
      "eventData": eventData
    };

    final AEPEvent event = AEPEvent.createEvent(
        eventName, eventType, eventSource, eventData);

    test('returns correct result', () async {
      expect(event.eventName, eventName);
      expect(event.eventType, eventType);
      expect(event.eventSource, eventSource);
      expect(event.eventData, eventData);
      expect(event.data, eventConstructorData);
    });
  });

  group('getSdkIdentities', () {
    final String testSdkIdentities = "sdkIdentities";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return testSdkIdentities;
      });
    });

    test('invokes correct method', () async {
      await FlutterAEPCore.sdkIdentities;

      expect(log, <Matcher>[
        isMethodCall(
          'getSdkIdentities',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      String? sdkIdentitiesResult = await FlutterAEPCore.sdkIdentities;
      expect(sdkIdentitiesResult, testSdkIdentities);
    });
  });

  group('getPrivacyStatus', () {
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return AEPPrivacyStatus.opt_in.value;
      });
    });

    test('invokes correct method', () async {
      await FlutterAEPCore.privacyStatus;

      expect(log, <Matcher>[
        isMethodCall(
          'getPrivacyStatus',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      AEPPrivacyStatus privacyStatus = await FlutterAEPCore.privacyStatus;
      expect(privacyStatus.value, AEPPrivacyStatus.opt_in.value);
    });
  });

  group('setLogLevel', () {
    final AEPLogLevel logLevel = AEPLogLevel.error;
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await FlutterAEPCore.setLogLevel(logLevel);

      expect(log, <Matcher>[
        isMethodCall(
          'setLogLevel',
          arguments: logLevel.value,
        ),
      ]);
    });
  });

  group('setPrivacyStatus', () {
    final AEPPrivacyStatus privacyStatus = AEPPrivacyStatus.opt_in;
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await FlutterAEPCore.setPrivacyStatus(privacyStatus);

      expect(log, <Matcher>[
        isMethodCall(
          'setPrivacyStatus',
          arguments: privacyStatus.value,
        ),
      ]);
    });
  });

  group('updateConfiguration', () {
    final Map<String, String> testConfig = {"configKey": "configValue"};
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await FlutterAEPCore.updateConfiguration(testConfig);

      expect(log, <Matcher>[
        isMethodCall(
          'updateConfiguration',
          arguments: testConfig,
        ),
      ]);
    });
  });

  group('clearUpdatedConfiguration', () {
    final List<MethodCall> log = <MethodCall>[];

    setUp((){
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await FlutterAEPCore.clearUpdatedConfiguration();

      expect(log, <Matcher>[
        isMethodCall('clearUpdatedConfiguration', arguments: null),
      ]);
    });
  });
}
