// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_aepoptimize/flutter_aepoptimize.dart';
// import 'package:flutter_aepoptimize/flutter_aepoptimize_platform_interface.dart';
// import 'package:flutter_aepoptimize/flutter_aepoptimize_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockFlutterAepOptimizePlatform
//     with MockPlatformInterfaceMixin
//     implements FlutterAepOptimizePlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   test('$MethodChannelFlutterAepOptimize is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelFlutterAepOptimize>());
//   });

//   test('getPlatformVersion', () async {
//     FlutterAEPOptimize flutterAepoptimizePlugin = FlutterAEPOptimize();
//     MockFlutterAepOptimizePlatform fakePlatform =
//         MockFlutterAepOptimizePlatform();
//     FlutterAepOptimizePlatform.instance = fakePlatform;

//     expect(await flutterAepoptimizePlugin.getPlatformVersion(), '42');
//   });
// }
