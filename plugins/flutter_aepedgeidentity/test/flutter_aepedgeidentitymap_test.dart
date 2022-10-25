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
import 'package:flutter_aepedgeidentity/flutter_aepedgeidentity_data.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_aepedgeidentity');

  TestWidgetsFlutterBinding.ensureInitialized();

  group('IdentityMap addItem', () {
    IdentityItem item1 =
        new IdentityItem('id1', AuthenticatedState.AMBIGUOUS, true);
    IdentityItem item2 =
        new IdentityItem('id2', AuthenticatedState.AUTHENTICATED, false);
    IdentityItem item3 = new IdentityItem('id3', AuthenticatedState.LOGGED_OUT);
    IdentityItem item4 = new IdentityItem('id4');

    IdentityMap idMap = new IdentityMap();
    idMap.addItem(item1, 'namespace1');
    idMap.addItem(item2, 'namespace1');
    idMap.addItem(item3, 'namespace2');
    idMap.addItem(item4, 'namespace2');

    List<IdentityItem> expectedItemsForNamespace1 = <IdentityItem>[
      item1,
      item2
    ];

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return expectedItemsForNamespace1;
      });
    });

    test('is validated', () async {
      //test with getNamespaces()
      final int actualGetNameSpacesLength = idMap.getNamespaces().length;
      expect(actualGetNameSpacesLength, equals(2));

      final List<IdentityItem> actualItemsForNamespace1 =
          idMap.getIdentityItemsForNamespace('namespace1');

      //test identityItems in namespace, getIdentityItemsForNamespace()
      final int actualItemsForNamespace1Length =
          idMap.getIdentityItemsForNamespace('namespace1').length;

      expect(actualItemsForNamespace1Length, equals(2));

      expect(actualItemsForNamespace1[0].id, expectedItemsForNamespace1[0].id);
      expect(actualItemsForNamespace1[0].authenticatedState,
          expectedItemsForNamespace1[0].authenticatedState);
      expect(actualItemsForNamespace1[0].primary,
          expectedItemsForNamespace1[0].primary);
      expect(actualItemsForNamespace1[1].id, expectedItemsForNamespace1[1].id);
      expect(actualItemsForNamespace1[1].authenticatedState,
          expectedItemsForNamespace1[1].authenticatedState);
      expect(actualItemsForNamespace1[1].primary,
          expectedItemsForNamespace1[1].primary);
    });
  });

  group('IdentityMap getIdentityItemsForNamespace', () {
    IdentityItem item1 =
        new IdentityItem('id1', AuthenticatedState.AMBIGUOUS, true);
    IdentityItem item2 =
        new IdentityItem('id2', AuthenticatedState.AUTHENTICATED, false);
    IdentityItem item3 = new IdentityItem('id3', AuthenticatedState.LOGGED_OUT);
    IdentityItem item4 = new IdentityItem('id4');

    IdentityMap idMap = new IdentityMap();
    idMap.addItem(item1, 'namespace1');
    idMap.addItem(item2, 'namespace1');
    idMap.addItem(item3, 'namespace2');
    idMap.addItem(item4, 'namespace2');

    List<IdentityItem> expectedItemsForNamespace1 = <IdentityItem>[
      item1,
      item2
    ];

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return expectedItemsForNamespace1;
      });
    });

    test('test a non-existed namespace', () async {
      final int actualItemsForNamespace3Length =
          idMap.getIdentityItemsForNamespace('namespace3').length;
      expect(actualItemsForNamespace3Length, equals(0));
    });

    test('test an invalid namespace', () async {
      final int actualItemsForNamespaceInvalidLength =
          idMap.getIdentityItemsForNamespace('invalid').length;
      expect(actualItemsForNamespaceInvalidLength, equals(0));
    });

    test('test an empty namespace', () async {
      final int actualItemsForNamespaceInvalidLength =
          idMap.getIdentityItemsForNamespace('invalid').length;
      expect(actualItemsForNamespaceInvalidLength, equals(0));
    });
  });

  group('IdentityMap addItem', () {
    IdentityItem item1 =
        new IdentityItem('id1', AuthenticatedState.AMBIGUOUS, true);

    IdentityItem item2 =
        new IdentityItem('id1', AuthenticatedState.AUTHENTICATED, false);

    IdentityMap idMap = new IdentityMap();
    idMap.addItem(item1, 'namespace1');
    idMap.addItem(item1, 'namespace1'); // same item, should be ignored

    List<IdentityItem> expectedSameIdSameItem = <IdentityItem>[
      item1,
    ];

    List<IdentityItem> expectedSameIdDiffItem = <IdentityItem>[
      item2,
    ];

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return {};
      });
    });

    test('same id and same item, should ignore the new added item', () async {
      final List<IdentityItem> actualSameIdSameItem =
          idMap.getIdentityItemsForNamespace('namespace1');

      final int actualSameIdSameItemLength =
          idMap.getIdentityItemsForNamespace('namespace1').length;

      expect(actualSameIdSameItemLength, equals(1));
      expect(actualSameIdSameItem[0].id, expectedSameIdSameItem[0].id);
      expect(actualSameIdSameItem[0].authenticatedState,
          expectedSameIdSameItem[0].authenticatedState);
      expect(
          actualSameIdSameItem[0].primary, expectedSameIdSameItem[0].primary);
    });

    test('same id but different item, should replace existing item', () async {
      idMap.addItem(item2, 'namespace1');
      final int actualSameIdDiffItemLength =
          idMap.getIdentityItemsForNamespace('namespace1').length;
      final List<IdentityItem> actualSameIdDiffItem =
          idMap.getIdentityItemsForNamespace('namespace1');

      expect(actualSameIdDiffItemLength, equals(1));
      expect(actualSameIdDiffItem[0].id, expectedSameIdDiffItem[0].id);
      expect(actualSameIdDiffItem[0].authenticatedState,
          expectedSameIdDiffItem[0].authenticatedState);
      expect(
          actualSameIdDiffItem[0].primary, expectedSameIdDiffItem[0].primary);
    });
  });
  group('IdentityMap removeItem', () {
    IdentityItem item1 =
        new IdentityItem('id1', AuthenticatedState.AMBIGUOUS, true);
    IdentityItem item2 =
        new IdentityItem('id2', AuthenticatedState.AUTHENTICATED, false);
    IdentityItem item3 = new IdentityItem('id3', AuthenticatedState.LOGGED_OUT);

    IdentityMap idMap = new IdentityMap();
    idMap.addItem(item1, 'namespace1');
    idMap.addItem(item2, 'namespace2');
    idMap.addItem(item3, 'namespace2');

    idMap.removeItem(item1, "namespace1");
    idMap.removeItem(
        new IdentityItem('id2'), "namespace2"); // remove item based on id only

    List<IdentityItem> expectedItemsForNamespace2 = <IdentityItem>[item3];

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return expectedItemsForNamespace2;
      });
    });

    test('is validated', () async {
      //test with getNamespaces()
      final int actualGetNameSpacesLength = idMap.getNamespaces().length;
      expect(actualGetNameSpacesLength, equals(1));

      final List<IdentityItem> actualItemsForNamespace2 =
          idMap.getIdentityItemsForNamespace('namespace2');

      //test identityItems in namespace, getIdentityItemsForNamespace()
      final int actualItemsForNamespace2Length =
          idMap.getIdentityItemsForNamespace('namespace2').length;

      expect(actualItemsForNamespace2Length, equals(1));
      expect(idMap.isEmpty(), false);

      expect(actualItemsForNamespace2[0].id, expectedItemsForNamespace2[0].id);
      expect(actualItemsForNamespace2[0].authenticatedState,
          expectedItemsForNamespace2[0].authenticatedState);
      expect(actualItemsForNamespace2[0].primary,
          expectedItemsForNamespace2[0].primary);
    });
    test('test removeAllItems in namespace2, namespace2 should be removed',
        () async {
      //test with getNamespaces()
      idMap.removeItem(item3, 'namespace2');
      expect(
          idMap.getIdentityItemsForNamespace('namespace2').length, equals(0));
    });
  });

  group('IdentityMap isEmpty', () {
    IdentityItem item1 =
        new IdentityItem('id1', AuthenticatedState.AMBIGUOUS, true);

    IdentityMap idMap = new IdentityMap();

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    test('is validated', () async {
      //test isEmpty false
      expect(idMap.isEmpty(), true);

      //test isEmpty true
      idMap.addItem(item1, 'namespace1');
      expect(idMap.isEmpty(), false);
    });
  });
}
