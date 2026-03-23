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
import 'package:ozi/app/data/network/web_socket_connection_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/storage/user_preference.dart';
import '../../modules/user/navigation tab/view/navigation_tab_screen.dart';
import '../../modules/vendor/home/notification/provider/vendor_ notification_provider.dart';
import '../../modules/vendor/navigation tab/view/vendor_navigation_tab_screen.dart';
import '../../routes/app_routes.dart';
import '../../view/message/screens/message.dart';
import '../../view/message/provider/message_provider.dart';
import 'package:provider/provider.dart';
import '../utils/get_utils.dart';
import '../../../firebase_options.dart';

// ─── BACKGROUND HANDLER ──────────────────────────────────────────────────────
// When the app is in background/terminated state and the server sends an FCM
// message with a `notification` payload, Firebase's NATIVE Android SDK
// automatically displays a system tray notification.
//
// ⚠️  DO NOT show any local notification here.
//     If we call flutterLocalNotificationsPlugin.show() here, users will see
//     TWO identical notifications — one from Firebase native + one from us.
//
// This handler exists ONLY for:
//   • Logging / analytics
//   • Updating local state (e.g., badge count, cache)
//   • Processing data-only messages that need silent work
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log("Background Notification: ${message.notification?.body}");
  log("Background Data: ${message.data}");

  debugPrint("Background Notification: ${message.notification?.body}");
  debugPrint("📨 Foreground Message ID: ${message.messageId}");
  debugPrint('🔔 Title: ${message.notification?.title}');
  debugPrint('📝 Body : ${message.notification?.body}');
  debugPrint('📦 Data : ${message.data}');

  // ❌ Do NOT show a local notification here.
  //    Firebase's native SDK already displays the notification
  //    for background/terminated state when `notification` payload is present.
  //
  //    For data-only messages (message.notification == null), Firebase does NOT
  //    auto-display — but if you need to show one, you can uncomment below:
  //
  // if (!Platform.isIOS && message.notification == null) {
  //   await PushNotificationService.initLocalNotification();
  //   await PushNotificationService.showNotificationFromData(message.data, message.messageId);
  // }
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
      conversationId: data['conversationId'] ?? '',
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

  /// Stores notification data when app is launched from terminated state.
  /// The splash screen should call [consumePendingNotification] to handle it.
  static Map<String, dynamic>? _pendingNotificationData;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> firebaseNotification() async {
    if (_isInitialized) {
      debugPrint("PushNotificationService already initialized. Skipping.");
      return;
    }
    _isInitialized = true;

    // ── 1. Request permissions (non-blocking) ────────────────────────────────
    //    Fire-and-forget so the permission dialog doesn't block app startup.
    //    The splash screen will be visible while the dialog is shown.
    _requestPermissionsInBackground();

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

    // ── 3. Init local notifications ──────────────────────────────────────────
    await initLocalNotification();

    // ── 4. Register background handler ──────────────────────────────────────
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // ── 5. Foreground messages ───────────────────────────────────────────────
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      final ctx = navigatorKey.currentContext;

      if (ctx != null) {
        try {
          final provider = Provider.of<VendorNotificationProvider>(ctx, listen: false);

          final type = message.data['type'] ?? '';

          if (_shouldRefreshVendorNotifications(type)) {
            print("🔥 API TRIGGER FROM FOREGROUND NOTIFICATION");

            provider.getNotifications(isRefresh: true);
          }
        } catch (e) {
          debugPrint("❌ Provider error: $e");
        }
      }

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
      final String conversationId = message.data['conversationId'] ?? '';
      final String type = message.data['type'] ?? '';

      if (type == "message" && conversationId.isNotEmpty) {
        await navigateFromNotification(
          screen: '',
          bookingId: '',
          conversationId: conversationId,
          type: type,
        );
      } else if (bookingId.isNotEmpty) {
        await navigateFromNotification(
          screen: screen,
          bookingId: bookingId,
          conversationId: conversationId,
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

    // ── 9. REMOVED — getInitialMessage is now handled by checkInitialMessage()
    //    which the splash screen calls directly before navigating.
  }

  /// Checks if the app was launched by tapping a notification from killed state.
  /// Call this from the splash screen BEFORE navigating to detect pending
  /// notification taps. This method awaits Firebase's getInitialMessage().
  ///
  /// Safe to call multiple times — it only stores data once.
  static Future<void> checkInitialMessage() async {
    try {
      // Ensure Firebase is initialized (idempotent — safe to call again)
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      RemoteMessage? initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();

      if (initialMessage != null) {
        _pendingNotificationData = initialMessage.data;
        debugPrint("📩 App opened via notification (terminated state)");
        debugPrint("📩 Data: ${initialMessage.data}");
      }
    } catch (e) {
      debugPrint("❌ Error checking initial message: $e");
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
      final String conversationId = data['conversationId'] ?? '';
      final String type = data['type'] ?? '';

      if (type == "message" && conversationId.isNotEmpty) {
        await navigateFromNotification(
          screen: '',
          bookingId: '',
          conversationId: conversationId,
          type: type,
        );
      } else if (bookingId.isNotEmpty) {
        await navigateFromNotification(
          screen: screen,
          bookingId: bookingId,
          conversationId: conversationId,
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

  // ── PENDING NOTIFICATION (terminated state) ──────────────────────────────
  /// Returns true if the app was opened by tapping a notification
  /// from terminated/killed state and hasn't been consumed yet.
  static bool get hasPendingNotification => _pendingNotificationData != null;

  /// Consumes the pending notification (if any) and navigates to the
  /// appropriate screen. Call this from the splash screen AFTER auth checks
  /// to ensure the notification navigation takes priority over default routing.
  ///
  /// Returns `true` if there was a pending notification and navigation was triggered.
  static Future<bool> consumePendingNotification() async {
    final data = _pendingNotificationData;
    if (data == null) return false;

    // Clear it so it's only consumed once
    _pendingNotificationData = null;

    final String screen = data['screen'] ?? '';
    final String bookingId = data['booking_id'] ?? '';
    final String conversationId = data['conversationId'] ?? '';
    final String type = data['type'] ?? '';

    debugPrint(
      "📩 Consuming pending notification: screen=$screen, bookingId=$bookingId, type=$type,conversationId  = $conversationId",
    );

    if (type == "message" && conversationId.isNotEmpty) {
      await navigateFromNotification(
        screen: '',
        bookingId: '',
        conversationId: conversationId,
        type: type,
      );
    } else if (bookingId.isNotEmpty) {
      await navigateFromNotification(
        screen: screen,
        bookingId: bookingId,
        conversationId: conversationId,
        type: type,
      );
    }
    return false;
  }

  static bool _shouldRefreshVendorNotifications(String type) {
    return [
      "booking_request",
      "booking_confirm",
      "booking_paid_advanced",
      "booking_payment_failed",
      "booking_ongoing",
      "booking_completed",
      'booking_cancelled',
      'booking_rejected',
      'credit',
      'debit'
    ].contains(type); }


  // ── NAVIGATION ──────────────────────────────────────────────────────────────
  static Future<void> navigateFromNotification({
    required String screen,
    required dynamic bookingId,
    required String conversationId,
    required String type,
  }) async {
    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint("❌ navigatorKey context null");
      return;
    }

    SocketController? _;

    // WAIT for socket connection
    // await _socket.socket.

    // IMPORTANT: tell backend user is online
    // SocketController.instance.goOnline();

    debugPrint("✅ Socket connected & online event sent");

    String? role = await UserPreference.returnRole();
    debugPrint("🔔 Role identified for navigation: $role");

    // Explicitly handle vendor vs user navigation
    if (role?.toLowerCase() == "vendor") {
      _handleVendorNavigation(context, type, bookingId, conversationId);
    } else {
      // Default to user navigation for all other roles (including null/guest)
      _handleUserNavigation(context, type, bookingId, conversationId);
    }
  }

  static void _handleVendorNavigation(
    BuildContext context,
    String type,
    dynamic bookingId,
    dynamic conversationId,
  ) {
    print("🔔 Navigation Triggered");
    print("Type: $type");
    print("BookingId: $bookingId");
    print("ConversationId: $conversationId");

    if (type == "message") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => VendorNavigationTabScreen(
            initialIndex: 0,
            conversationId: conversationId,
          ),
        ),
        (route) => false,
      );

      return;
    }

    int tabIndex = switch (type) {
      "booking_request" => 1,
      "credit" => 2,
      "booking_cancelled" => 1,
      "booking_confirm" => 1,
      "booking_completed" => 1,
      "booking_rejected" => 1,
      _ => 0,
    };

    print("➡️ Navigating to Vendor Tab Index: $tabIndex");

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
    dynamic conversationId,
  ) {
    print("ConversationId: $conversationId");

    if (type == "message") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => NavigationTabScreen(initialIndex: 0)),
        (route) => false,
      );

      // We wait for the root navigation to finish before pushing on top of it.
      // This ensures we have a valid context and the previous route is removed.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentContext = navigatorKey.currentContext ?? context;

        Navigator.push(
          currentContext,
          MaterialPageRoute(builder: (_) => MessageScreen()),
        );

        if (conversationId.isNotEmpty) {
          Navigator.pushNamed(
            currentContext,
            AppRoutes.messageDetailsScreen,
            arguments: {"conversion_id": conversationId},
          ).then((_) {
            currentContext.read<MessageProvider>().getAllConversions(true);
          });
        }
      });

      return;
    }

    int tabIndex = switch (type) {
      "booking_confirm" => 2,
      "booking_cancelled" => 2,
      "booking_rejected" => 2,
      "booking_completed" => 2,
      "booking_ongoing" => 2,
      "booking_payment_failed" => 1,
      _ => 0,
    };

    // For all other user notifications, ensure we land on the User Navigation Tab
    // Default to the home screen (index 0) if requested, or the specific tab based on type
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => NavigationTabScreen(initialIndex: tabIndex),
      ),
      (route) => false,
    );
  }

  // ── NON-BLOCKING PERMISSION REQUEST ─────────────────────────────────────
  /// Requests notification permissions asynchronously without blocking
  /// the app startup. This ensures the splash screen is visible while
  /// the permission dialog is displayed.
  static void _requestPermissionsInBackground() {
    // Fire-and-forget — don't await
    () async {
      try {
        await firebaseMessaging.requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          carPlay: false,
          criticalAlert: true,
          provisional: false,
          sound: true,
        );

        // Request Android Notification Permission explicitly for Android 13+
        if (Platform.isAndroid) {
          await _requestAndroidPermission();
        }
      } catch (e) {
        debugPrint("❌ Error requesting notification permissions: $e");
      }
    }();
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
