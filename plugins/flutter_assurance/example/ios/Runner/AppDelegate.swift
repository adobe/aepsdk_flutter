import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    ACPCore.setLogLevel(ACPMobileLogLevel.verbose)
    ACPCore.configure(withAppId: "94f571f308d5/e30a9514788b/launch-44fec1a705f1-development")
    AEPAssurance.registerExtension()
    ACPAnalytics.registerExtension()
    ACPCore.start {
        ACPCore.lifecycleStart(["extrakey":"extravalue"])
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
