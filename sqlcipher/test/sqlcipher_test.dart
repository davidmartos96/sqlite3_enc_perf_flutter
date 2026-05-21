import 'package:flutter_test/flutter_test.dart';
import 'package:sqlcipher/sqlcipher.dart';
import 'package:sqlcipher/sqlcipher_platform_interface.dart';
import 'package:sqlcipher/sqlcipher_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSqlcipherPlatform
    with MockPlatformInterfaceMixin
    implements SqlcipherPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SqlcipherPlatform initialPlatform = SqlcipherPlatform.instance;

  test('$MethodChannelSqlcipher is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSqlcipher>());
  });

  test('getPlatformVersion', () async {
    Sqlcipher sqlcipherPlugin = Sqlcipher();
    MockSqlcipherPlatform fakePlatform = MockSqlcipherPlatform();
    SqlcipherPlatform.instance = fakePlatform;

    expect(await sqlcipherPlugin.getPlatformVersion(), '42');
  });
}
