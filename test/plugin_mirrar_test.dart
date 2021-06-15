import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirrar_sdk/mirrar_sdk.dart';

void main() {
  const MethodChannel channel = MethodChannel('plugin_mirrar');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  // test('getPlatformVersion', () async {
  //   expect(await Mirr, '42');
  // });
}
