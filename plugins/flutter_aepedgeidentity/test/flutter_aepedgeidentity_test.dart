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
import 'package:flutter_aepedgeidentity/flutter_aepedgeidentity.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_aepedgeidentity');

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

  group('getExperienceCloudId', () {
    final String testECID = "test-ecid";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return testECID;
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
      expect(await Identity.experienceCloudId, testECID);
    });
  });

  group('getUrlVariables', () {
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
          'getUrlVariables',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await Identity.urlVariables, expectedVariables);
    });
  });

  group('getIdentities with addItem', () {
    IdentityItem item1 =
        new IdentityItem('id1', AuthenticatedState.AUTHENTICATED, false);
    IdentityItem item2 =
        new IdentityItem('id2', AuthenticatedState.LOGGED_OUT, true);

    Map<dynamic, dynamic> expectedMap = {
      'namespace1': [item1],
      'namespace2': [item2]
    };

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return {};
      });
    });

    test('returns correct result', () async {
      IdentityMap currentIdentity = await Identity.identities;
      currentIdentity.addItem(item1, "namespace1");
      currentIdentity.addItem(item2, "namespace2");

      expect(currentIdentity.identityMap.toString(), expectedMap.toString());
      expect(currentIdentity.getNamespaces().length, equals(2));
      expect(currentIdentity.isEmpty(), equals(false));
      expect(currentIdentity.getIdentityItemsForNamespace('namespace1').length,
          equals(1));
    });
  });

  group('getIdentities with removeItem', () {
    IdentityItem item1 =
        new IdentityItem('id1', AuthenticatedState.AUTHENTICATED, false);
    IdentityItem item2 =
        new IdentityItem('id2', AuthenticatedState.LOGGED_OUT, true);

    Map<dynamic, dynamic> expectedMap = {
      'namespace1': [item1],
    };

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return {};
      });
    });

    test('returns correct result', () async {
      IdentityMap currentIdentity = await Identity.identities;
      currentIdentity.addItem(item1, "namespace1");
      currentIdentity.addItem(item2, "namespace2");

      currentIdentity.removeItem(item2, "namespace2");

      expect(currentIdentity.identityMap.toString(), expectedMap.toString());
      expect(currentIdentity.getNamespaces().length, equals(1));
      expect(currentIdentity.isEmpty(), equals(false));
      expect(currentIdentity.getIdentityItemsForNamespace('namespace1').length,
          equals(1));
    });
  });

  group('updateIdentities', () {
    IdentityItem item1 = new IdentityItem('id1');
    IdentityItem item2 =
        new IdentityItem('id2', AuthenticatedState.AUTHENTICATED, true);

    IdentityMap idmap = new IdentityMap();

    Map<dynamic, dynamic> expectedMap = {
      'identityMap': {
        'namespace1': [
          {'id': 'id1', 'authenticatedState': 'ambiguous', 'primary': false}
        ],
        'namespace2': [
          {'id': 'id2', 'authenticatedState': 'authenticated', 'primary': true}
        ]
      }
    };

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return expectedMap;
      });
    });

    test('invokes correct method', () async {
      idmap.addItem(item1, "namespace1");
      idmap.addItem(item2, "namespace2");

      await Identity.updateIdentities(idmap);

      expect(log, <Matcher>[
        isMethodCall(
          'updateIdentities',
          arguments: expectedMap,
        ),
      ]);
    });
  });

  group('removeIdentities', () {
    IdentityItem item1 = new IdentityItem('id1');

    Map<dynamic, dynamic> expectedMap = {
      'item': {
        'id': 'id1',
        'authenticatedState': 'ambiguous',
        'primary': false
      },
      'namespace': 'namespace1'
    };

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('invokes correct method', () async {
      await Identity.removeIdentity(item1, 'namespace1');

      expect(log, <Matcher>[
        isMethodCall('removeIdentity', arguments: expectedMap),
      ]);
    });
  });
}
