import UIKit
import Flutter
import GoogleMaps  // ← Add this import (very important!)

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // TODO: Replace with your actual Google Maps API key
    GMSServices.provideAPIKey("AIzaSyApdA5sIEfZoPmhlWuAr5wTgyOXvhl9jsQ")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}