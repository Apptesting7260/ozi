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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ozi/app/core/appExports/app_export.dart';
import '../../data/storage/user_preference.dart';
import '../../modules/user/navigation tab/view/navigation_tab_screen.dart';
import '../../modules/vendor/home/notification/provider/vendor_ notification_provider.dart';
import '../../modules/vendor/navigation tab/view/vendor_navigation_tab_screen.dart';
import '../utils/get_utils.dart';
import '../../../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //log("Background Notification: ${message.notification?.body}");
  debugPrint(
    '🔔message notification title background message=====${message.notification?.title}',
  );
  debugPrint('📝message notification body=====${message.notification?.body}');
  debugPrint('📝message notification data body=====${message.data}');
  debugPrint(
    '📝message notification messageId=====${message.data['booking_id']}',
  );
  debugPrint('📝message notification messageType=====${message.data['type']}');
  debugPrint(
    '📝message notification messageType=====${message.data['screen']}',
  );

  try {
    if (message.data['type'] == 'booking_request') {
    } else if (message.data['NotificationType'] == 'call_ended') {}
  } catch (e) {
    debugPrint("Error in background notification: $e");
  }
}

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

class PushNotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  /// Prevent duplicate notification navigation
  static final Set<String> _handledMessageIds = {};

  static String? fcmToken;
  static String? apnsToken;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static DarwinInitializationSettings initializationSettingsDarwin =
      const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        // onDidReceiveLocalNotification: null,
      );

  static firebaseNotification() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    firebaseMessaging.isAutoInitEnabled;

    await initLocalNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        debugPrint("📨 Message ID: ${message.messageId}");

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        AppleNotification? appleNotification = message.notification?.apple;
        debugPrint(
          '🔔message notification title onmessage =====${message.notification?.title}',
        );
        debugPrint(
          '📝message notification body=====${message.notification?.body}',
        );
        debugPrint('📝message notification dataBody=====${message.data}');
        //debugPrint('📝message notification data=====${message.data['screen']}');
        debugPrint(
          'notification body ===== $notification.  $android.   $appleNotification',
        );

        showNotification(message.notification, message.data);

        final context = navigatorKey.currentContext;
        if (context != null) {
          try {
            final notifProvider =
            context.read<VendorNotificationProvider>();
            // Either refresh from page 1:
            await notifProvider.getNotifications(isRefresh: true);
            // or, if your API is heavy and backend already increments counts,
            // you could instead just re-fetch first page occasionally.
          } catch (e) {
            debugPrint('Error updating VendorNotificationProvider on message: $e');
          }
        }


        debugPrint('android not null notification==${message.notification}');
        FirebaseMessaging.instance.getInitialMessage().then((message) {
          if (message != null) {
            debugPrint("abc525");
          } else {
            debugPrint("123154115415abc");
          }
        });
      } catch (e) {
        debugPrint("Error in onMessage: $e");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      /// Prevent duplicate navigation
      if (message.messageId != null) {
        if (_handledMessageIds.contains(message.messageId)) return;
        _handledMessageIds.add(message.messageId!);
      }

      if (kDebugMode) {
        debugPrint("🔔 Notification tapped");
        debugPrint("Notification Body: ${message.notification?.body}");
        debugPrint("Notification Data: ${message.data}");
      }

      try {
        final String screen = message.data['screen'] ?? '';
        final String bookingId = message.data['booking_id'] ?? '';
        final String type = message.data['type'] ?? '';

        if (screen.isNotEmpty && bookingId.isNotEmpty) {
          await navigateFromNotification(
            screen: screen,
            bookingId: bookingId,
            type: type,
          );
        } else {
          debugPrint("⚠ Invalid notification data");
        }
      } catch (e) {
        debugPrint("❌ Notification navigation error: $e");
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance
        .getToken()
        .then((String? token) async {
          if (token == null) {
            debugPrint('FCM token is null');
          } else {
            fcmToken = token;
            debugPrint('🔔 FCM token: $token');
          }
        })
        .catchError((error) {
          debugPrint('Error getting FCM token: ${error.toString()}');
        });

    /// Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      fcmToken = newToken;
      debugPrint("🔄 FCM Token Refreshed: $newToken");
    });

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      debugPrint('FlutterFire Messaging Example: Getting APNs token...');
      String? token = await FirebaseMessaging.instance.getAPNSToken();
      apnsToken = token;
      debugPrint('FlutterFire Messaging Example: Got APNs token: $token');
    }

    /// Handle notification when app opens from terminated state
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      debugPrint("📩 App opened via notification (terminated)");

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

  static Future initLocalNotification() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: Platform.isIOS
          ? null
          : backgroundNotificationTap,
    );
  }

  static Future<void> showNotification(
    RemoteNotification? notification,
    Map<String, dynamic>? data,
  ) async {
    var android = const AndroidNotificationDetails(
      'high_importance_channel',
      "Woye Vendor",
      channelDescription: "channelDescription",
      importance: Importance.max,
      fullScreenIntent: true,
      icon: '@mipmap/ic_launcher',
      priority: Priority.high,
      visibility: NotificationVisibility.public,
    );

    var iOS = const DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      sound: 'default',
    );
    var platform = NotificationDetails(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().second,
      notification?.title ?? 'Notification',
      notification?.body ?? '',
      platform,
      payload: data != null ? jsonEncode(data) : null,
    );
  }

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
        navigateFromNotification(
          screen: screen,
          bookingId: bookingId,
          type: type,
        );
      } else {
        debugPrint("⚠ Invalid notification payload");
      }
    } catch (e) {
      debugPrint("❌ Payload parse error: $e");
    }
  }

  static showCustomSnackBar(
    String title,
    String message,
    BuildContext context,
  ) {
    if (kDebugMode) {
      print("object>>>> $title \n $message");
    }
    Flushbar(
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: Colors.white,
      flushbarPosition: FlushbarPosition.TOP,
      icon: Padding(
        padding: REdgeInsets.only(left: 8.0),
        child: Image.asset(
          'assets/images/launcher.webp',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
      titleText: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.black),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      duration: const Duration(seconds: 3),
      onTap: (_) {
        print("Hooooo rha h tappppppp");
        // final NotificationsController controller = Get.put(NotificationsController());
        // final type = controller.apiData.value.notification?.first.type ?? "";
        // _handleNotificationTap(type: type, title: title);
      },
    ).show(context);
  }

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

    debugPrint("ROLE = $role");
    debugPrint("SCREEN = $screen");
    debugPrint("BOOKING ID = $bookingId");

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
    switch (type) {
      case "booking_request":
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => VendorNavigationTabScreen(initialIndex: 1),
          ),
          (route) => false,
        );

        break;

      case "booking_confirm":
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => VendorNavigationTabScreen(initialIndex: 1),
          ),
          (route) => false,
        );

        break;

      case "booking_completed":
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => VendorNavigationTabScreen(initialIndex: 1),
          ),
          (route) => false,
        );

        break;

      default:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => VendorNavigationTabScreen(initialIndex: 0),
          ),
          (route) => false,
        );
    }
  }

  static void _handleUserNavigation(
    BuildContext context,
    String type,
    dynamic bookingId,
  ) {
    switch (type) {
      case "booking_confirm":
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => NavigationTabScreen(initialIndex: 2
            ),
          ),
          (route) => false,
        );

        break;

      case "booking_cancelled":

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => NavigationTabScreen(initialIndex: 2
            ),
          ),
              (route) => false,
        );

        break;

      case "booking_rejected":

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => NavigationTabScreen(initialIndex: 2
            ),
          ),
              (route) => false,
        );

        break;


      case "booking_completed":
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => NavigationTabScreen(initialIndex: 2),
          ),
          (route) => false,
        );

        break;

      default:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => NavigationTabScreen(initialIndex: 0),
          ),
          (route) => false,
        );
    }
  }

  // static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   log("background notification--> ${message.notification?.body}");
  // }

  // static void _handleNotificationTap({required String type, required String title}) {
  //   if (type == "restaurant") {
  //     if (title == "New Order Received") {
  //       Get.toNamed(AppRoutes.restaurantOrderListScreen, arguments: {"fromNotification": "true"});
  //     } else if (title == "Ticket Reply") {
  //       Get.toNamed(AppRoutes.restaurantSupportScreen);
  //     }
  //   } else if (type == "pharmacy") {
  //     if (title == "New Order Received") {
  //       Get.toNamed(AppRoutes.pharmacyOrderListScreen, arguments: {"fromNotification": "true"});
  //     } else if (title == "Ticket Reply") {
  //       Get.toNamed(AppRoutes.pharmacySupportScreen);
  //     }
  //   } else if (type == "grocery") {
  //     if (title == "New Order Received") {
  //       Get.toNamed(AppRoutes.groceryOrderListScreen, arguments: {"fromNotification": "true"});
  //     } else if (title == "Ticket Reply") {
  //       Get.toNamed(AppRoutes.grocerySupportScreen);
  //     }
  //   }
  // }
}
