#if os(macOS)
import FlutterMacOS
#else
import Flutter
import UIKit
#endif

public class SqlcipherPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
  }
}
