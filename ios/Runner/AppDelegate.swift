import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import GoogleMaps  // ← Add this import (very important!)

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    
    // TODO: Replace with your actual Google Maps API key
    GMSServices.provideAPIKey("AIzaSyApdA5sIEfZoPmhlWuAr5wTgyOXvhl9jsQ")

    // This is required to receive local notifications in background
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}