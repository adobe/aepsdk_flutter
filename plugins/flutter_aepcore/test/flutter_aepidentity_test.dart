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
import 'package:flutter_aepcore/flutter_aepidentity.dart';
import 'package:flutter_aepcore/src/aepmobile_visitor_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_aepidentity');

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
      await Identity.extensionVersion;

      expect(log, <Matcher>[
        isMethodCall(
          'extensionVersion',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await Identity.extensionVersion, testVersion);
    });
  });

  group('appendToUrl', () {
    final String inputUrl = "https://adobe.com/";
    final String expectedUrl = "https://adobe.com/?testVariable=100";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return expectedUrl;
      });
    });

    test('invokes correct method', () async {
      await Identity.appendToUrl(inputUrl);

      expect(log, <Matcher>[
        isMethodCall(
          'appendToUrl',
          arguments: inputUrl,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await Identity.appendToUrl(inputUrl), expectedUrl);
    });
  });

  group('identifiers', () {
    final Map<String, String> testIdOne = {
      "idOrigin": "testOrigin",
      "idType": "testType",
      "authenticationState": "AEP_VISITOR_AUTH_STATE_AUTHENTICATED"
    };
    final Map<String, String> testIdTwo = {
      "idOrigin": "testOrigin2",
      "idType": "testType2",
      "authenticationState": "AEP_VISITOR_AUTH_STATE_LOGGED_OUT"
    };
    final List<Map<String, String>> serializedIds = [testIdOne, testIdTwo];

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return serializedIds;
      });
    });

    test('invokes correct method', () async {
      await Identity.identifiers;

      expect(log, <Matcher>[
        isMethodCall(
          'getIdentifiers',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      List<Identifiable> ids = await Identity.identifiers;
      expect(ids[0].idOrigin, Identifiable(testIdOne).idOrigin);
      expect(ids[1].idOrigin, Identifiable(testIdTwo).idOrigin);
    });
  });

  group('experienceCloudId', () {
    final String testMcId = "test-mid";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return testMcId;
      });
    });

    test('invokes correct method', () async {
      await Identity.experienceCloudId;

      expect(log, <Matcher>[
        isMethodCall(
          'getExperienceCloudId',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await Identity.experienceCloudId, testMcId);
    });
  });

  group('syncIdentifier', () {
    final String testIdType = "testType";
    final String testId = "testId";
    final MobileVisitorAuthenticationState testState =
        MobileVisitorAuthenticationState.unknown;

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await Identity.syncIdentifier(testIdType, testId, testState);

      expect(log, <Matcher>[
        isMethodCall(
          'syncIdentifier',
          arguments: {
            "identifierType": testIdType,
            "identifier": testId,
            "authState": testState.value
          },
        ),
      ]);
    });
  });

  group('syncIdentifiers', () {
    final Map<String, String> testIds = {
      "idType1": "idValue1",
      "idType2": "idValue2",
      "idType3": "idValue3"
    };

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await Identity.syncIdentifiers(testIds);

      expect(log, <Matcher>[
        isMethodCall(
          'syncIdentifiers',
          arguments: testIds,
        ),
      ]);
    });
  });

  group('syncIdentifiersWithAuthState', () {
    final Map<String, String> testIds = {
      "idType1": "idValue1",
      "idType2": "idValue2",
      "idType3": "idValue3"
    };
    final MobileVisitorAuthenticationState testState =
        MobileVisitorAuthenticationState.logged_out;

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await Identity.syncIdentifiersWithAuthState(testIds, testState);

      expect(log, <Matcher>[
        isMethodCall(
          'syncIdentifiersWithAuthState',
          arguments: {"identifiers": testIds, "authState": testState.value},
        ),
      ]);
    });
  });

  group('urlVariables', () {
    final String expectedVariables = "%20&arg=20";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return expectedVariables;
      });
    });

    test('invokes correct method', () async {
      await Identity.urlVariables;

      expect(log, <Matcher>[
        isMethodCall(
          'urlVariables',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await Identity.urlVariables, expectedVariables);
    });
  });
}
