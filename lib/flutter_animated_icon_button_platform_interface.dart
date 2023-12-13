import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_animated_icon_button_method_channel.dart';

abstract class FlutterAnimatedIconButtonPlatform extends PlatformInterface {
  /// Constructs a FlutterAnimatedIconButtonPlatform.
  FlutterAnimatedIconButtonPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAnimatedIconButtonPlatform _instance = MethodChannelFlutterAnimatedIconButton();

  /// The default instance of [FlutterAnimatedIconButtonPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAnimatedIconButton].
  static FlutterAnimatedIconButtonPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAnimatedIconButtonPlatform] when
  /// they register themselves.
  static set instance(FlutterAnimatedIconButtonPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
