import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_animated_icon_button_platform_interface.dart';

/// An implementation of [FlutterAnimatedIconButtonPlatform] that uses method channels.
class MethodChannelFlutterAnimatedIconButton extends FlutterAnimatedIconButtonPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_animated_icon_button');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
