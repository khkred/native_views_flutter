import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      guard let pluginRegisterar = self.registrar(forPlugin: "plugin-name") else { return false}
      
      let factory = FLNativeViewFactory(messenger: pluginRegisterar.messenger())
      pluginRegisterar.register(factory, withId: "<platform-view-type>")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
