import AEPCore
import AEPMessaging
import AEPServices
import Flutter
import UIKit
import UserNotifications
import WebKit


public class SwiftFlutterAEPMessagingPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_aepmessaging", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterAEPMessagingPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "extensionVersion":
      return result(Messaging.extensionVersion);
    case "refreshInAppMessages":
      Messaging.refreshInAppMessages();
      return result(nil);
    default:
      return result(FlutterMethodNotImplemented);
    }
  }
}