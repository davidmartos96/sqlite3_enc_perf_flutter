import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sqlcipher_method_channel.dart';

abstract class SqlcipherPlatform extends PlatformInterface {
  /// Constructs a SqlcipherPlatform.
  SqlcipherPlatform() : super(token: _token);

  static final Object _token = Object();

  static SqlcipherPlatform _instance = MethodChannelSqlcipher();

  /// The default instance of [SqlcipherPlatform] to use.
  ///
  /// Defaults to [MethodChannelSqlcipher].
  static SqlcipherPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SqlcipherPlatform] when
  /// they register themselves.
  static set instance(SqlcipherPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
