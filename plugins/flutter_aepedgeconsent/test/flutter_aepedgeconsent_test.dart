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
import 'package:flutter_aepedgeconsent/flutter_aepedgeconsent.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_aepedgeconsent');

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
      await Consent.extensionVersion;

      expect(log, <Matcher>[
        isMethodCall(
          'extensionVersion',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await Consent.extensionVersion, testVersion);
    });
  });

  group('getConsents', () {
    final Map<String, String> consentPreferenceStringMap = {
      "val": "y",
    };

    final Map<String, dynamic> consentsMap = {
      "collect": consentPreferenceStringMap,
    };

    final Map<String, dynamic> testGetConsent = {
      "consents": consentsMap,
    };

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return testGetConsent;
      });
    });

    test('invokes correct method', () async {
      await Consent.consents;

      expect(log, <Matcher>[
        isMethodCall(
          'getConsents',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await Consent.consents, testGetConsent);
    });
  });

  group('setCollectConsents', () {
    final Map<String, dynamic> testSetConsent = {
      'collect': {'val': 'y'}
    };

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await Consent.update(testSetConsent);

      expect(log, <Matcher>[
        isMethodCall(
          'updateConsents',
          arguments: testSetConsent,
        ),
      ]);
    });
  });
}
