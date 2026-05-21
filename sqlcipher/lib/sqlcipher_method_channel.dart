import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sqlcipher_platform_interface.dart';

/// An implementation of [SqlcipherPlatform] that uses method channels.
class MethodChannelSqlcipher extends SqlcipherPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sqlcipher');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
