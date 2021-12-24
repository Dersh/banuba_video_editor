import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:banuba_video_editor/banuba_video_editor.dart';

void main() {
  const MethodChannel channel = MethodChannel('banuba_video_editor');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    
  });
}
