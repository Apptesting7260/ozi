import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/storage/user_preference.dart';
import '../../modules/user/navigation tab/view/navigation_tab_screen.dart';
import '../../modules/vendor/navigation tab/view/vendor_navigation_tab_screen.dart';
import '../../routes/app_routes.dart';
import '../utils/get_utils.dart';
import '../../../firebase_options.dart';

// ─── BACKGROUND HANDLER ──────────────────────────────────────────────────────
// ⚠️  iOS IMPORTANT:
//   On iOS, this handler runs in a SEPARATE background isolate.
//   flutter_local_notifications CANNOT show notifications from a background
//   isolate on iOS — Apple forbids it. The APNs system notification
//   (sent by Firebase via your server payload) is what iOS users will see
//   in background/terminated state. We only suppress it in foreground (step 2).
//
// ✅  Android:
//   We CAN show a local notification from here. Firebase suppresses its own
//   system tray notification when onBackgroundMessage is registered, so we
//   must show one manually to ensure it appears.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log("Background Notification: ${message.notification?.body}");

  // Only show local notification on Android — iOS handles it via APNs system
  if (!Platform.isIOS) {
    await PushNotificationService.initLocalNotification();
    await PushNotificationService.showNotification(
      message.notification,
      message.data,
      messageId: message.messageId,
    );
  }
}

// ─── BACKGROUND TAP HANDLER (Android only) ───────────────────────────────────
// iOS does NOT support onDidReceiveBackgroundNotificationResponse.
// On iOS, background taps are handled via onMessageOpenedApp (Firebase)
// or getInitialMessage (terminated). Do NOT register this for iOS.
@pragma('vm:entry-point')
void backgroundNotificationTap(NotificationResponse notificationResponse) {
  final String? payload = notificationResponse.payload;
  debugPrint("🔙 Background Notification tapped. Payload: $payload");
  if (payload == null) return;

  try {
    final Map<String, dynamic> data = jsonDecode(payload);
    PushNotificationService.navigateFromNotification(
      screen: data['screen'] ?? '',
      bookingId: data['booking_id'] ?? '',
      type: data['type'] ?? '',
    );
  } catch (e) {
    debugPrint("❌ Background payload parse error: $e");
  }
}

// ─── PUSH NOTIFICATION SERVICE ───────────────────────────────────────────────
class PushNotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static final Set<String> _handledMessageIds = {};
  static bool _isInitialized = false;

  static String? fcmToken;
  static String? apnsToken;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> firebaseNotification() async {
    if (_isInitialized) {
      debugPrint("PushNotificationService already initialized. Skipping.");
      return;
    }
    _isInitialized = true;

    // ── 1. Request permissions ───────────────────────────────────────────────
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    // ── 2. Suppress Firebase's own banner in iOS FOREGROUND only ────────────
    //    - Foreground: We show our own local notification (full control).
    //    - Background/Terminated: APNs system notification shows automatically
    //      (we cannot intercept it on iOS — Apple restriction).
    //    Setting all false prevents a DUPLICATE banner in foreground on iOS.
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: false, // ← was true  (caused duplicate on iOS)
      badge: false, // ← was true
      sound: false, // ← was true
    );

    // ── 2.1 Request Android Notification Permission explicitly for Android 13+ ─
    if (Platform.isAndroid) {
      await _requestAndroidPermission();
    }

    // ── 3. Init local notifications ──────────────────────────────────────────
    await initLocalNotification();

    // ── 4. Register background handler ──────────────────────────────────────
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // ── 5. Foreground messages ───────────────────────────────────────────────
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.messageId != null) {
        if (_handledMessageIds.contains(message.messageId)) {
          debugPrint(
            "♻️ Duplicate foreground message ignored: ${message.messageId}",
          );
          return;
        }
        _handledMessageIds.add(message.messageId!);
      }

      debugPrint("📨 Foreground Message ID: ${message.messageId}");
      debugPrint('🔔 Title: ${message.notification?.title}');
      debugPrint('📝 Body : ${message.notification?.body}');
      debugPrint('📦 Data : ${message.data}');

      // Log reception for debugging
      log("🔔 Foreground Message Received: ${message.notification?.title}");

      // Show ONLY via local notifications — Firebase does NOT auto-show
      // anything in foreground on Android, and we disabled it on iOS above.
      await showNotification(
        message.notification,
        message.data,
        messageId: message.messageId,
      );
    });

    // ── 6. App opened from background via notification tap ───────────────────
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.messageId != null) {
        if (_handledMessageIds.contains(message.messageId)) return;
        _handledMessageIds.add(message.messageId!);
      }

      debugPrint("🔔 Notification tapped (background → foreground)");
      debugPrint("Data: ${message.data}");

      final String screen = message.data['screen'] ?? '';
      final String bookingId = message.data['booking_id'] ?? '';
      final String type = message.data['type'] ?? '';

      if (screen.isNotEmpty && bookingId.isNotEmpty) {
        await navigateFromNotification(
          screen: screen,
          bookingId: bookingId,
          type: type,
        );
      }
    });

    // ── 7. FCM Token ─────────────────────────────────────────────────────────
    // IMPORTANT: await the token so it's available before any login/API call
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        debugPrint('FCM token is null');
      } else {
        fcmToken = token;
        debugPrint('🔔 FCM token: $token');
      }
    } catch (error) {
      debugPrint('❌ Error getting FCM token: $error');
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      fcmToken = newToken;
      debugPrint("🔄 FCM Token Refreshed: $newToken");
      // Update the server with the new token
      _updateFcmTokenOnServer(newToken);
    });

    // ── 8. APNs token (iOS only) ─────────────────────────────────────────────
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      String? token = await FirebaseMessaging.instance.getAPNSToken();
      apnsToken = token;
      debugPrint('APNs token: $token');
    }

    // ── 9. App opened from terminated state ──────────────────────────────────
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      debugPrint("📩 App opened via notification (terminated state)");

      final String screen = initialMessage.data['screen'] ?? '';
      final String bookingId = initialMessage.data['booking_id'] ?? '';
      final String type = initialMessage.data['type'] ?? '';

      if (screen.isNotEmpty && bookingId.isNotEmpty) {
        await navigateFromNotification(
          screen: screen,
          bookingId: bookingId,
          type: type,
        );
      }
    }
  }

  // ── LOCAL NOTIFICATION INIT ─────────────────────────────────────────────────
  // ⚠️  iOS SETUP REQUIRED in AppDelegate.swift / AppDelegate.m:
  //   Add this so flutter_local_notifications can intercept foreground
  //   notifications on iOS (shows banner while app is open):
  //
  //   Swift (AppDelegate.swift):
  //     import UIKit
  //     import Flutter
  //     import flutter_local_notifications
  //
  //     @UIApplicationMain
  //     @objc class AppDelegate: FlutterAppDelegate {
  //       override func application(_ application: UIApplication,
  //           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  //         FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
  //           GeneratedPluginRegistrant.register(with: registry)
  //         }
  //         if #available(iOS 10.0, *) {
  //           UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
  //         }
  //         GeneratedPluginRegistrant.register(with: self)
  //         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  //       }
  //     }
  static Future<void> initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
          // ✅ Use ic_launcher which exists in your res folders
          '@mipmap/ic_launcher',
        );

    // ✅ iOS: defaultPresentAlert/Sound/Badge control foreground presentation
    //    of local notifications shown by flutter_local_notifications.
    //    These are separate from Firebase's setForegroundNotificationPresentationOptions.
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          defaultPresentAlert: true, // show banner in foreground
          defaultPresentSound: true, // play sound in foreground
          defaultPresentBadge: true, // update badge in foreground
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      // ✅ iOS does NOT support background notification response handler —
      //    taps on iOS background/terminated notifications are caught by
      //    FirebaseMessaging.onMessageOpenedApp and getInitialMessage instead.
      onDidReceiveBackgroundNotificationResponse: Platform.isIOS
          ? null
          : backgroundNotificationTap,
    );

    // Create the Android notification channel
    await _createAndroidNotificationChannel();
  }

  // ── ANDROID CHANNEL ─────────────────────────────────────────────────────────
  static Future<void> _createAndroidNotificationChannel() async {
    if (!Platform.isAndroid) return;

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // ── SHOW NOTIFICATION ───────────────────────────────────────────────────────
  static Future<void> showNotification(
    RemoteNotification? notification,
    Map<String, dynamic>? data, {
    String? messageId,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'Used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          visibility: NotificationVisibility.public,
          // ✅ Must match the icon in initializationSettingsAndroid
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      sound: 'default',
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    // Use a stable ID based on messageId to prevent duplicates from creating separate banners.
    // Fallback to timestamp ONLY if messageId is missing.
    final int notificationId = messageId != null
        ? messageId.hashCode % 100000
        : DateTime.now().millisecondsSinceEpoch % 100000;

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notification?.title ?? 'Notification',
      notification?.body ?? '',
      platformDetails,
      payload: data != null ? jsonEncode(data) : null,
    );
  }

  // ── TAP HANDLER (foreground) ────────────────────────────────────────────────
  static void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final String? payload = notificationResponse.payload;
    if (payload == null) return;

    try {
      debugPrint("Notification payload: $payload");
      final Map<String, dynamic> data = jsonDecode(payload);

      final String screen = data['screen'] ?? '';
      final String bookingId = data['booking_id'] ?? '';
      final String type = data['type'] ?? '';

      if (screen.isNotEmpty && bookingId.isNotEmpty) {
        await navigateFromNotification(
          screen: screen,
          bookingId: bookingId,
          type: type,
        );
      }
    } catch (e) {
      debugPrint("❌ Payload parse error: $e");
    }
  }

  // ── SNACKBAR ────────────────────────────────────────────────────────────────
  // static void showCustomSnackBar(
  //   String title,
  //   String message,
  //   BuildContext context,
  // ) {
  //   Flushbar(
  //     margin: const EdgeInsets.all(10),
  //     borderRadius: BorderRadius.circular(12),
  //     backgroundColor: Colors.white,
  //     flushbarPosition: FlushbarPosition.TOP,
  //     titleText: Text(
  //       title,
  //       style: const TextStyle(
  //         fontWeight: FontWeight.bold,
  //         color: Colors.black,
  //       ),
  //     ),
  //     messageText: Text(
  //       message,
  //       style: const TextStyle(color: Colors.black),
  //       maxLines: 2,
  //       overflow: TextOverflow.ellipsis,
  //     ),
  //     duration: const Duration(seconds: 3),
  //   ).show(context);
  // }

  // ── NAVIGATION ──────────────────────────────────────────────────────────────
  static Future<void> navigateFromNotification({
    required String screen,
    required dynamic bookingId,
    required String type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint("❌ navigatorKey context null");
      return;
    }

    String? role = await UserPreference.returnRole();
    debugPrint(
      "ROLE=$role | SCREEN=$screen | BOOKING_ID=$bookingId | TYPE=$type",
    );

    if (role == "vendor") {
      _handleVendorNavigation(context, type, bookingId);
    } else {
      _handleUserNavigation(context, type, bookingId);
    }
  }

  static void _handleVendorNavigation(
    BuildContext context,
    String type,
    dynamic bookingId,
  ) {
    final int tabIndex = switch (type) {
      "booking_request" || "booking_confirm" || "booking_completed" => 1,
      _ => 0,
    };

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => VendorNavigationTabScreen(initialIndex: tabIndex),
      ),
      (route) => false,
    );
  }

  static void _handleUserNavigation(
    BuildContext context,
    String type,
    dynamic bookingId,
  ) {
    final int tabIndex = switch (type) {
      "booking_confirm" ||
      "booking_cancelled" ||
      "booking_rejected" ||
      "booking_completed" => 2,
      _ => 0,
    };

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => NavigationTabScreen(initialIndex: tabIndex),
      ),
      (route) => false,
    );
  }

  // ── ANDROID 13+ PERMISSION ────────────────────────────────────────────────
  static Future<void> _requestAndroidPermission() async {
    // Check and request permission using permission_handler
    var status = await Permission.notification.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      debugPrint("🔔 Requesting notification permission...");
      status = await Permission.notification.request();
    }

    if (status.isGranted) {
      debugPrint("✅ Notification permissions granted.");
    } else {
      debugPrint("🚫 Notification permissions denied: $status");
    }
  }

  // ── UPDATE FCM TOKEN ON SERVER ─────────────────────────────────────────
  /// Sends the latest FCM token to the backend so the server always
  /// has a valid token for push notifications.
  static Future<void> _updateFcmTokenOnServer(String token) async {
    try {
      final String? accessToken = await UserPreference.returnAccessToken();
      // Only update if user is logged in
      if (accessToken == null || accessToken.isEmpty) return;

      debugPrint("🔄 Sending updated FCM token to server...");
      // TODO: Add your backend API endpoint to update FCM token.
      // Example:
      // await Repository().updateFcmToken({"fcm_token": token});
    } catch (e) {
      debugPrint("❌ Failed to update FCM token on server: $e");
    }
  }

  /// Convenience method to get the current FCM token,
  /// fetching a fresh one if it hasn't been retrieved yet.
  static Future<String?> getToken() async {
    if (fcmToken != null) return fcmToken;
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint('🔔 FCM token (late fetch): $fcmToken');
    } catch (e) {
      debugPrint('❌ Error fetching FCM token: $e');
    }
    return fcmToken;
  }
}
