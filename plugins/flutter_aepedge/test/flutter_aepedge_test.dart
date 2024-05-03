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

  group('sendEventUsingDictionary', () {
    final Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
    final Map<String, dynamic> data = {"free": "form", "data": "example"};

    final Map<String, dynamic> experienceEventData = {
      "xdmData": xdmData,
      "data": data,
      "datasetIdentifier": "datasetExample",
    };

    //setup experienceEvent
    final ExperienceEvent experienceEvent =
        ExperienceEvent(experienceEventData);

    final String eventHandleType = "state:store";
    final List<dynamic> eventHandlePayload = [
      {"maxAge": 1800, "value": "testValue1", "key": "keyExample1"},
      {"maxAge": 34128000, "value": "testValue2", "key": "keyExample2"}
    ];

    final Map<dynamic, dynamic> expectedEventHandle = {
      "type": eventHandleType,
      "payload": eventHandlePayload
    };

    final List<EventHandle> expectedResponse = [
      EventHandle(expectedEventHandle)
    ];

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return [expectedEventHandle];
      });
    });
    test('invokes correct method', () async {
      await Edge.sendEvent(experienceEvent);

      expect(log, <Matcher>[
        isMethodCall(
          'sendEvent',
          arguments: experienceEventData,
        ),
      ]);
    });

    test('returns correct result', () async {
      final actualEventHandleResponse = await Edge.sendEvent(experienceEvent);
      expect(actualEventHandleResponse[0].payload, expectedResponse[0].payload);
      expect(actualEventHandleResponse[0].type, expectedResponse[0].type);
    });
  });

  group('sendEventUsingDatasetIdentifierConstructor', () {
    final Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
    final Map<String, dynamic> data = {"free": "form", "data": "example"};

    //setup experienceEvent
    final ExperienceEvent experienceEvent =
        ExperienceEvent.createEvent(xdmData, data, "sampleDatasetID");

    test('returns correct result', () async {
    expect(experienceEvent.xdmData, equals(xdmData));
    expect(experienceEvent.data, equals(data));
    expect(experienceEvent.datasetIdentifier, equals("sampleDatasetID"));
    });
 });

 group('sendEventUsingDatastreamIdOverrideConstructor', () {
    final Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
    final Map<String, dynamic> data = {"free": "form", "data": "example"};

    //setup experienceEvent
    final ExperienceEvent experienceEvent =
        ExperienceEvent.createEventWithOverrides(xdmData, data, "sampleDatastreamID");
    
    test('returns correct result', () async {
    expect(experienceEvent.xdmData, equals(xdmData));
    expect(experienceEvent.data, equals(data));
    expect(experienceEvent.datastreamIdOverride, equals("sampleDatastreamID"));
    });
  });

   group('sendEventUsingDatasetConfigConstructor', () {
    final Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
    final Map<String, dynamic> data = {"free": "form", "data": "example"};
    final Map<String, dynamic> configOverrides = {"config": {
      "com_adobe_experience_platform": {
        "datasets": {
          "event": {
            "datasetId": "sampleDatasetID"
          }
        }
      }
    }};

    //setup experienceEvent
    final ExperienceEvent experienceEvent =
        ExperienceEvent.createEventWithOverrides(xdmData, data, "sampleDatastreamID", configOverrides);
    
    test('returns correct result', () async {
    expect(experienceEvent.xdmData, equals(xdmData));
    expect(experienceEvent.data, equals(data));
    expect(experienceEvent.datastreamIdOverride, equals("sampleDatastreamID"));
    expect(experienceEvent.datastreamConfigOverride, equals(configOverrides));
    });
  });

  group('sendEventUsingDatasetConfigConstructorWithDataAndIdNull', () {
    final Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
    final Map<String, dynamic> configOverrides = {"config": {
      "com_adobe_experience_platform": {
        "datasets": {
          "event": {
            "datasetId": "sampleDatasetID"
          }
        }
      }
    }};

    //setup experienceEvent
    final ExperienceEvent experienceEvent =
        ExperienceEvent.createEventWithOverrides(xdmData, null, null, configOverrides);
    
    test('returns correct result', () async {
    expect(experienceEvent.xdmData, equals(xdmData));
    expect(experienceEvent.data, equals({}));
    expect(experienceEvent.datastreamIdOverride, equals(null));
    expect(experienceEvent.datastreamConfigOverride, equals(configOverrides));
    });
  });

  group('sendEventUsingDatasetConfigConstructorWithNull', () {
    final Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};

    //setup experienceEvent
    final ExperienceEvent experienceEvent =
        ExperienceEvent.createEventWithOverrides(xdmData, null, null, null);
    
    test('returns correct result', () async {
    expect(experienceEvent.xdmData, equals(xdmData));
    expect(experienceEvent.data, equals({}));
    expect(experienceEvent.datastreamIdOverride, equals(null));
    expect(experienceEvent.datastreamConfigOverride, equals(null));
    });
  });


  group('sendEvent with nested data and multiple response handles', () {
    final Map<dynamic, dynamic> mapValue = {"keySample": "keyValue"};
    final Map<dynamic, dynamic> dataValue = {"keySample1": "keyValue1"};
    final Map<String, dynamic> xdmData = {"eventType": mapValue};
    final Map<String, dynamic> data = {"free": "form", "data": dataValue};

    final Map<String, dynamic> experienceEventData = {
      "xdmData": xdmData,
      "data": data,
      "datasetIdentifier": "datasetExample",
    };

    //setup experienceEvent
    final ExperienceEvent experienceEvent =
        ExperienceEvent(experienceEventData);

    final String eventHandleType = "state:store";
    final List<dynamic> eventHandlePayload = [
      {"maxAge": 1800, "value": "testValue1", "key": "keyExample1"},
      {"maxAge": 34128000, "value": "testValue2", "key": "keyExample2"}
    ];

    final Map<dynamic, dynamic> expectedEventHandle = {
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

    final Map<dynamic, dynamic> expectedEventHandle2 = {
      "type": eventHandleType2,
      "payload": eventHandlePayload2
    };

    final List<EventHandle> expectedResponse = [
      EventHandle(expectedEventHandle),
      EventHandle(expectedEventHandle2)
    ];

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return [expectedEventHandle, expectedEventHandle2];
      });
    });
    test('invokes correct method happy test', () async {
      await Edge.sendEvent(experienceEvent);

      expect(log, <Matcher>[
        isMethodCall(
          'sendEvent',
          arguments: experienceEventData,
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

  group('setLocationHint', () {
    final String testLocationHint = "irl1";
    final String? testLocationHintNull = null;
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      log.clear();
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await Edge.setLocationHint(testLocationHint);

      expect(log, <Matcher>[
        isMethodCall(
          'setLocationHint',
          arguments: testLocationHint,
        ),
      ]);
    });

    test('invokes correct method with null', () async {
      await Edge.setLocationHint(testLocationHintNull);

      expect(log, <Matcher>[
        isMethodCall(
          'setLocationHint',
          arguments: testLocationHintNull,
        ),
      ]);
    });
  });

  group('getLocationHint', () {
    final String testGetLocationHint = "va6";
    final String? testGetLocationHintNull = null;
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return testGetLocationHint;
      });
    });

    test('invokes correct method', () async {
      await Edge.locationHint;

      expect(log, <Matcher>[
        isMethodCall(
          'getLocationHint',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      String? getLocationHintResult = await Edge.locationHint;
      expect(getLocationHintResult, testGetLocationHint);
    });

    test('returns correct result null', () async {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.clear();
        return testGetLocationHintNull;
      });

      String? getLocationHintResultNull = await Edge.locationHint;
      expect(getLocationHintResultNull, testGetLocationHintNull);
    });
  });
}
