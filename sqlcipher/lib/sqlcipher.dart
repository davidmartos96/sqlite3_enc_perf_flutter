
import 'sqlcipher_platform_interface.dart';

class Sqlcipher {
  Future<String?> getPlatformVersion() {
    return SqlcipherPlatform.instance.getPlatformVersion();
  }
}
