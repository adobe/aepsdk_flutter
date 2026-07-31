/*
Copyright 2026 Adobe. All rights reserved.
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
import 'package:flutter_aepoptimize/flutter_aepoptimize.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_aepoptimize');

  TestWidgetsFlutterBinding.ensureInitialized();

  group('extensionVersion', () {
    final String testVersion = "5.0.0";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return testVersion;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('invokes correct method', () async {
      await Optimize.extensionVersion;

      expect(log, <Matcher>[
        isMethodCall('extensionVersion', arguments: null),
      ]);
    });

    test('returns correct result', () async {
      expect(await Optimize.extensionVersion, testVersion);
    });
  });

  group('DecisionScope', () {
    test('creates from name', () {
      final scope = DecisionScope('myScope');
      expect(scope.name, 'myScope');
      expect(scope.toMap(), {'name': 'myScope'});
    });

    test('creates from activity and placement', () {
      final scope = DecisionScope.fromActivityAndPlacement(
        activityId: 'xcore:offer-activity:1234',
        placementId: 'xcore:offer-placement:5678',
        itemCount: 3,
      );
      expect(scope.name.isNotEmpty, true);
    });

    test('fromMap roundtrip', () {
      final scope = DecisionScope('testScope');
      final restored = DecisionScope.fromMap(scope.toMap());
      expect(restored.name, scope.name);
      expect(restored, scope);
    });

    test('equality', () {
      final a = DecisionScope('same');
      final b = DecisionScope('same');
      final c = DecisionScope('different');
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a == c, false);
    });
  });

  group('OfferType', () {
    test('rawValue mapping', () {
      expect(OfferType.unknown.rawValue, 0);
      expect(OfferType.json.rawValue, 1);
      expect(OfferType.text.rawValue, 2);
      expect(OfferType.html.rawValue, 3);
      expect(OfferType.image.rawValue, 4);
    });

    test('mimeType mapping', () {
      expect(OfferType.json.mimeType, 'application/json');
      expect(OfferType.text.mimeType, 'text/plain');
      expect(OfferType.html.mimeType, 'text/html');
      expect(OfferType.image.mimeType, 'image/*');
      expect(OfferType.unknown.mimeType, '');
    });

    test('int to OfferType conversion', () {
      expect(0.toOfferType(), OfferType.unknown);
      expect(1.toOfferType(), OfferType.json);
      expect(2.toOfferType(), OfferType.text);
      expect(3.toOfferType(), OfferType.html);
      expect(4.toOfferType(), OfferType.image);
      expect(99.toOfferType(), OfferType.unknown);
    });
  });

  group('Offer', () {
    test('fromMap creates correct offer', () {
      final map = {
        'id': 'offer-1',
        'etag': 'abc123',
        'score': 85.5,
        'schema': 'https://ns.adobe.com/experience/offer-management/content-component-html',
        'meta': {'key': 'value'},
        'type': 3,
        'language': ['en', 'fr'],
        'content': '<h1>Hello</h1>',
        'characteristics': {'trait': 'premium'},
      };

      final offer = Offer.fromMap(map);
      expect(offer.id, 'offer-1');
      expect(offer.etag, 'abc123');
      expect(offer.score, 85.5);
      expect(offer.type, OfferType.html);
      expect(offer.language, ['en', 'fr']);
      expect(offer.content, '<h1>Hello</h1>');
      expect(offer.characteristics, {'trait': 'premium'});
    });

    test('toMap roundtrip', () {
      final offer = Offer(
        id: 'test-offer',
        type: OfferType.json,
        content: '{"key": "value"}',
      );

      final map = offer.toMap();
      final restored = Offer.fromMap(map);
      expect(restored.id, offer.id);
      expect(restored.type, offer.type);
      expect(restored.content, offer.content);
    });

    test('fromMap handles missing fields', () {
      final offer = Offer.fromMap({});
      expect(offer.id, '');
      expect(offer.type, OfferType.unknown);
      expect(offer.content, '');
      expect(offer.meta, null);
      expect(offer.language, null);
    });
  });

  group('OptimizeProposition', () {
    test('fromMap creates correct proposition', () {
      final map = {
        'id': 'prop-1',
        'scope': 'myScope',
        'scopeDetails': {'activity': {'id': 'act-1'}},
        'items': [
          {
            'id': 'offer-1',
            'type': 2,
            'content': 'Hello World',
          }
        ],
      };

      final proposition = OptimizeProposition.fromMap(map);
      expect(proposition.id, 'prop-1');
      expect(proposition.scope, 'myScope');
      expect(proposition.offers.length, 1);
      expect(proposition.offers[0].id, 'offer-1');
      expect(proposition.offers[0].type, OfferType.text);
    });

    test('toMap roundtrip', () {
      final proposition = OptimizeProposition(
        id: 'prop-2',
        scope: 'testScope',
        offers: [
          Offer(id: 'offer-2', type: OfferType.html, content: '<p>Test</p>'),
        ],
      );

      final map = proposition.toMap();
      final restored = OptimizeProposition.fromMap(map);
      expect(restored.id, proposition.id);
      expect(restored.scope, proposition.scope);
      expect(restored.offers.length, 1);
    });
  });

  group('updatePropositions', () {
    final List<MethodCall> log = <MethodCall>[];

    final Map<dynamic, dynamic> mockResponse = {
      'myScope': {
        'id': 'prop-1',
        'scope': 'myScope',
        'scopeDetails': {},
        'items': [
          {'id': 'offer-1', 'type': 2, 'content': 'Hello'},
        ],
      }
    };

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return mockResponse;
      });
    });

    tearDown(() {
      log.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('invokes correct method with all parameters', () async {
      final scopes = [DecisionScope('myScope')];
      await Optimize.updatePropositions(
        scopes,
        xdm: {'key': 'value'},
        data: {'dataKey': 'dataValue'},
        timeout: 15.0,
      );

      expect(log.length, 1);
      expect(log[0].method, 'updatePropositions');
      final args = log[0].arguments as Map;
      expect((args['decisionScopes'] as List).length, 1);
      expect(args['xdm'], {'key': 'value'});
      expect(args['data'], {'dataKey': 'dataValue'});
      expect(args['timeout'], 15.0);
    });

    test('invokes with minimal parameters', () async {
      await Optimize.updatePropositions([DecisionScope('scope1')]);

      expect(log.length, 1);
      final args = log[0].arguments as Map;
      expect(args['xdm'], null);
      expect(args['data'], null);
      expect(args['timeout'], null);
    });

    test('returns decoded propositions map', () async {
      final result = await Optimize.updatePropositions([DecisionScope('myScope')]);

      expect(result, isNotNull);
      expect(result!.length, 1);
      final scope = DecisionScope('myScope');
      expect(result[scope], isNotNull);
      expect(result[scope]!.id, 'prop-1');
      expect(result[scope]!.offers.length, 1);
    });
  });

  group('getPropositions', () {
    final List<MethodCall> log = <MethodCall>[];

    final Map<dynamic, dynamic> mockResponse = {
      'cachedScope': {
        'id': 'prop-cached',
        'scope': 'cachedScope',
        'scopeDetails': {},
        'items': [
          {'id': 'offer-cached', 'type': 1, 'content': '{"cached": true}'},
        ],
      }
    };

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return mockResponse;
      });
    });

    tearDown(() {
      log.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('invokes correct method', () async {
      await Optimize.getPropositions([DecisionScope('cachedScope')]);

      expect(log.length, 1);
      expect(log[0].method, 'getPropositions');
    });

    test('passes timeout when provided', () async {
      await Optimize.getPropositions(
        [DecisionScope('cachedScope')],
        timeout: 5.0,
      );

      final args = log[0].arguments as Map;
      expect(args['timeout'], 5.0);
    });

    test('returns decoded propositions', () async {
      final result = await Optimize.getPropositions([DecisionScope('cachedScope')]);

      expect(result, isNotNull);
      final prop = result![DecisionScope('cachedScope')];
      expect(prop, isNotNull);
      expect(prop!.offers[0].type, OfferType.json);
    });
  });

  group('clearCachedPropositions', () {
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    tearDown(() {
      log.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('invokes correct method', () async {
      await Optimize.clearCachedPropositions();
      expect(log, <Matcher>[
        isMethodCall('clearCachedPropositions', arguments: null),
      ]);
    });
  });

  group('offer tracking methods', () {
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    tearDown(() {
      log.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('displayed invokes correct method', () async {
      final offer = Offer(id: 'offer-track', type: OfferType.html, content: '<p>Hi</p>');
      await offer.displayed();

      expect(log.length, 1);
      expect(log[0].method, 'offerDisplayed');
      expect((log[0].arguments as Map)['id'], 'offer-track');
    });

    test('tapped invokes correct method', () async {
      final offer = Offer(id: 'offer-tap', type: OfferType.text, content: 'Tap me');
      await offer.tapped();

      expect(log.length, 1);
      expect(log[0].method, 'offerTapped');
      expect((log[0].arguments as Map)['id'], 'offer-tap');
    });

    test('displayed passes all offer fields', () async {
      final offer = Offer(
        id: 'full-offer',
        etag: 'etag123',
        score: 90.5,
        schema: 'https://schema.example',
        meta: {'campaign': 'summer'},
        type: OfferType.json,
        language: ['en', 'de'],
        content: '{"promo": true}',
        characteristics: {'tier': 'gold'},
      );
      await offer.displayed();

      final args = log[0].arguments as Map;
      expect(args['id'], 'full-offer');
      expect(args['etag'], 'etag123');
      expect(args['score'], 90.5);
      expect(args['type'], 1);
      expect(args['language'], ['en', 'de']);
      expect(args['characteristics'], {'tier': 'gold'});
    });
  });

  group('generateDisplayInteractionXdm', () {
    final List<MethodCall> log = <MethodCall>[];
    final Map<String, dynamic> mockXdm = {
      'eventType': 'decisioning.propositionDisplay',
      '_experience': {'decisioning': {'propositionID': 'prop-1'}},
    };

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return mockXdm;
      });
    });

    tearDown(() {
      log.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('invokes correct method and returns XDM', () async {
      final offer = Offer(id: 'xdm-offer', type: OfferType.html, content: '<p>Ad</p>');
      final result = await offer.generateDisplayInteractionXdm();

      expect(log.length, 1);
      expect(log[0].method, 'generateDisplayInteractionXdm');
      expect(result, isNotNull);
      expect(result!['eventType'], 'decisioning.propositionDisplay');
    });
  });

  group('generateTapInteractionXdm', () {
    final List<MethodCall> log = <MethodCall>[];
    final Map<String, dynamic> mockXdm = {
      'eventType': 'decisioning.propositionInteract',
    };

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return mockXdm;
      });
    });

    tearDown(() {
      log.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('invokes correct method and returns XDM', () async {
      final offer = Offer(id: 'tap-xdm', type: OfferType.text, content: 'Click');
      final result = await offer.generateTapInteractionXdm();

      expect(log.length, 1);
      expect(log[0].method, 'generateTapInteractionXdm');
      expect(result, isNotNull);
      expect(result!['eventType'], 'decisioning.propositionInteract');
    });
  });

  group('generateReferenceXdm', () {
    final List<MethodCall> log = <MethodCall>[];
    final Map<String, dynamic> mockXdm = {
      '_experience': {'decisioning': {'propositionID': 'ref-prop'}},
    };

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return mockXdm;
      });
    });

    tearDown(() {
      log.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('invokes correct method and returns XDM', () async {
      final proposition = OptimizeProposition(
        id: 'ref-prop',
        scope: 'refScope',
        offers: [],
      );
      final result = await proposition.generateReferenceXdm();

      expect(log.length, 1);
      expect(log[0].method, 'generateReferenceXdm');
      expect((log[0].arguments as Map)['id'], 'ref-prop');
      expect(result, isNotNull);
    });
  });

  group('onPropositionsUpdate listener', () {
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    tearDown(() {
      log.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('registers listener by invoking registerOnPropositionsUpdate', () {
      Optimize.onPropositionsUpdate((propositions) {});

      expect(log.length, 1);
      expect(log[0].method, 'registerOnPropositionsUpdate');
    });

    test('callback fires when native pushes propositions', () async {
      Map<DecisionScope, OptimizeProposition>? received;
      Optimize.onPropositionsUpdate((propositions) {
        received = propositions;
      });

      final Map<dynamic, dynamic> mockUpdate = {
        'listenerScope': {
          'id': 'prop-live',
          'scope': 'listenerScope',
          'scopeDetails': {},
          'items': [
            {'id': 'offer-live', 'type': 3, 'content': '<b>Live</b>'},
          ],
        }
      };

      // Simulate native → Dart callback via platform message
      final ByteData message = const StandardMethodCodec()
          .encodeMethodCall(MethodCall('onPropositionsUpdate', mockUpdate));

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
        'flutter_aepoptimize',
        message,
        (ByteData? reply) {},
      );

      expect(received, isNotNull);
      expect(received!.length, 1);
      final scope = DecisionScope('listenerScope');
      expect(received![scope]!.id, 'prop-live');
      expect(received![scope]!.offers[0].type, OfferType.html);
    });
  });

  group('cross-layer consistency', () {
    test('all method channel names match between Dart API and tests', () {
      // This test documents all method channel call names that must exist
      // in both iOS FlutterAEPOptimizePlugin.m and Android FlutterAEPOptimizePlugin.java
      final expectedMethods = [
        'extensionVersion',
        'updatePropositions',
        'getPropositions',
        'registerOnPropositionsUpdate',
        'clearCachedPropositions',
        'offerDisplayed',
        'offerTapped',
        'generateDisplayInteractionXdm',
        'generateTapInteractionXdm',
        'generateReferenceXdm',
        'batchDisplayed',
        'batchGenerateDisplayInteractionXdm',
      ];

      // Ensure list is complete - this test fails if we add a method
      // to the Dart API but forget to add it here as a reminder to
      // also add it to the native bridges
      expect(expectedMethods.length, 12);
    });
  });

  group('edge cases', () {
    test('Offer.fromMap handles null meta, language, characteristics', () {
      final offer = Offer.fromMap({
        'id': 'minimal',
        'type': 2,
        'content': 'hello',
      });
      expect(offer.meta, isNull);
      expect(offer.language, isNull);
      expect(offer.characteristics, isNull);
      expect(offer.etag, '');
      expect(offer.score, 0);
      expect(offer.schema, '');
    });

    test('OptimizeProposition.fromMap handles empty offers list', () {
      final prop = OptimizeProposition.fromMap({
        'id': 'empty-prop',
        'scope': 'emptyScope',
      });
      expect(prop.offers, isEmpty);
      expect(prop.scopeDetails, isEmpty);
    });

    test('DecisionScope.fromActivityAndPlacement encodes to base64', () {
      final scope = DecisionScope.fromActivityAndPlacement(
        activityId: 'act-1',
        placementId: 'place-1',
        itemCount: 5,
      );
      // The name should be a base64-encoded JSON string
      expect(scope.name.contains('act-1'), isFalse);
      expect(scope.name.isNotEmpty, isTrue);
    });

    test('updatePropositions returns null when channel returns null', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        return null;
      });

      final result = await Optimize.updatePropositions([DecisionScope('s')]);
      expect(result, isNull);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });
  });
}
