import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_aepuserprofile/flutter_aepuserprofile.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_aepuserprofile');

  TestWidgetsFlutterBinding.ensureInitialized();

  group('extensionVersion', () {
    final String testVersion = "2.0.0";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return testVersion;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    });

    test('invokes correct method', () async {
      await UserProfile.extensionVersion;

      expect(log, <Matcher>[
        isMethodCall(
          'extensionVersion',
          arguments: null,
        ),
      ]);
    });

    test('returns correct result', () async {
      expect(await UserProfile.extensionVersion, testVersion);
    });
  });

  tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    });

  group('getUserAttributes', () {
    final String testUserAttributes = "userAttributes";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return testUserAttributes;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    });

    test('invokes correct method', () async {
      await UserProfile.getUserAttributes([testUserAttributes]);

      expect(log, <Matcher>[
        isMethodCall(
          'getUserAttributes',
          arguments: [testUserAttributes],
        ),
      ]);
    });

    test('returns correct result', () async {
      String userAttributes =
          await UserProfile.getUserAttributes([testUserAttributes]);
      expect(userAttributes, testUserAttributes);
    });
  });

  group('removeUserAttributes', () {
    final String testUserAttribute = "userAttribute";
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    });

    test('invokes correct method', () async {
      await UserProfile.removeUserAttributes([testUserAttribute]);

      expect(log, <Matcher>[
        isMethodCall(
          'removeUserAttributes',
          arguments: [testUserAttribute],
        ),
      ]);
    });
  });

  group('updateUserAttributes', () {
    final Map<String, Object> testUserAttribute = {"testKey": "testValue"};
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return null;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    });

    test('invokes correct method', () async {
      await UserProfile.updateUserAttributes(testUserAttribute);

      expect(log, <Matcher>[
        isMethodCall(
          'updateUserAttributes',
          arguments: testUserAttribute,
        ),
      ]);
    });
  });
}