import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animated_icon_button/flutter_animated_icon_button.dart';
import 'package:flutter_animated_icon_button/flutter_animated_icon_button_platform_interface.dart';
import 'package:flutter_animated_icon_button/flutter_animated_icon_button_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterAnimatedIconButtonPlatform
    with MockPlatformInterfaceMixin
    implements FlutterAnimatedIconButtonPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterAnimatedIconButtonPlatform initialPlatform = FlutterAnimatedIconButtonPlatform.instance;

  test('$MethodChannelFlutterAnimatedIconButton is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterAnimatedIconButton>());
  });

  test('getPlatformVersion', () async {
    FlutterAnimatedIconButton flutterAnimatedIconButtonPlugin = FlutterAnimatedIconButton();
    MockFlutterAnimatedIconButtonPlatform fakePlatform = MockFlutterAnimatedIconButtonPlatform();
    FlutterAnimatedIconButtonPlatform.instance = fakePlatform;

    expect(await flutterAnimatedIconButtonPlugin.getPlatformVersion(), '42');
  });
}
