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

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_aepedge/flutter_aepedge.dart';
import 'package:flutter_aepedge/src/aepedge_experienceevent.dart';
import 'package:flutter_aepedge/src/aepedge_eventhandle.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_aepedge');

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
      await Edge.extensionVersion;

      expect(log, <Matcher>[
        isMethodCall(
          'extensionVersion',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await Edge.extensionVersion, testVersion);
    });
  });

  group('sendEvent', () {
    final Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
    final Map<String, dynamic> data = {"free": "form", "data": "example"};

    final Map<String, dynamic> experienceeventData = {
      "xdmData": xdmData,
      "data": data,
      "datasetIdentifier": "datasetExample",
    };

    //setup experienceEvent
    final ExperienceEvent experienceEvent =
        ExperienceEvent(experienceeventData);

    final String eventHandleType = "state:store";
    final List<dynamic> eventHandlePayload = [
      {"maxAge": 1800, "value": "testValue1", "key": "keyExample1"},
      {"maxAge": 34128000, "value": "testValue2", "key": "keyExample2"}
    ];

    final Map<String, dynamic> expectedEventHandle = {
      "type": eventHandleType,
      "payload": eventHandlePayload
    };

    //setup returned and expected EventHandles
    final EventHandle expectedEvent = EventHandle(expectedEventHandle);
    final EventHandle returnedEvent = EventHandle(expectedEventHandle);

    final List<EventHandle> expectedResponse = [expectedEvent];
    final List<dynamic> returnedResponse = [returnedEvent.data];

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return returnedResponse;
      });
    });
    test('invokes correct method', () async {
      await Edge.sendEvent(experienceEvent);

      expect(log, <Matcher>[
        isMethodCall(
          'sendEvent',
          arguments: experienceeventData,
        ),
      ]);
    });

    test('returns correct result', () async {
      final actualEventHandleResponse = await Edge.sendEvent(experienceEvent);
      expect(actualEventHandleResponse[0].payload, expectedResponse[0].payload);
      expect(actualEventHandleResponse[0].type, expectedResponse[0].type);
    });
  });

  group('sendEvent with nested data and multiple response handles', () {
    final Map<dynamic, dynamic> mapValue = {"keySample": "keyValue"};
    final Map<dynamic, dynamic> dataValue = {"keySample1": "keyValue1"};
    final Map<String, dynamic> xdmData = {"eventType": mapValue};
    final Map<String, dynamic> data = {"free": "form", "data": dataValue};

    final Map<String, dynamic> experienceeventData = {
      "xdmData": xdmData,
      "data": data,
      "datasetIdentifier": "datasetExample",
    };

    //setup experienceEvent
    final ExperienceEvent experienceEvent =
        ExperienceEvent(experienceeventData);

    final String eventHandleType = "state:store";
    final List<dynamic> eventHandlePayload = [
      {"maxAge": 1800, "value": "testValue1", "key": "keyExample1"},
      {"maxAge": 34128000, "value": "testValue2", "key": "keyExample2"}
    ];

    final Map<String, dynamic> expectedEventHandle = {
      "type": eventHandleType,
      "payload": eventHandlePayload
    };

    final String eventHandleType2 = "state:store";
    final List<dynamic> eventHandlePayload2 = [
      {
        "type": "samplestore#",
        "destinationId": "345",
        "alias": "auto",
        "segments": [
          {"id": "00001234-7nfj-78u0-0ne7-nju348098jd1"},
          {"id": "78947208-yuj6-78nh-672m-k8792d7v9wnb"}
        ]
      },
    ];

    final Map<String, dynamic> expectedEventHandle2 = {
      "type": eventHandleType2,
      "payload": eventHandlePayload2
    };

    //setup returned and expected EventHandles
    final EventHandle expectedEvent = EventHandle(expectedEventHandle);
    final EventHandle returnedEvent = EventHandle(expectedEventHandle);

    final EventHandle expectedEvent2 = EventHandle(expectedEventHandle2);
    final EventHandle returnedEvent2 = EventHandle(expectedEventHandle2);

    final List<EventHandle> expectedResponse = [expectedEvent, expectedEvent2];
    final List<dynamic> returnedResponse = [
      returnedEvent.data,
      returnedEvent2.data
    ];

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return returnedResponse;
      });
    });
    test('invokes correct method happy test', () async {
      await Edge.sendEvent(experienceEvent);

      expect(log, <Matcher>[
        isMethodCall(
          'sendEvent',
          arguments: experienceeventData,
        ),
      ]);
    });

    test('returns correct result', () async {
      final actualEventHandleResponse = await Edge.sendEvent(experienceEvent);
      expect(actualEventHandleResponse[0].payload, expectedResponse[0].payload);
      expect(actualEventHandleResponse[0].type, expectedResponse[0].type);
      expect(actualEventHandleResponse[1].payload, expectedResponse[1].payload);
      expect(actualEventHandleResponse[1].type, expectedResponse[1].type);
    });
  });
}
