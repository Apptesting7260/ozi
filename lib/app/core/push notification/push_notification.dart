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
import '../utils/get_utils.dart';



@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Background Notification: ${message.notification?.body}");
  if (message.data['NotificationType'] == 'call') {
    // CallKitParams params = CallKitParams(
    //   id: message.data['callId'],
    //   nameCaller: message.data['callerName'],
    //   appName: 'My App',
    //   avatar: message.data['callerImage'],
    //   handle: 'Caller',
    //   type: 0, // 0 = audio call
    // );
    //
    // FlutterCallkitIncoming.showCallkitIncoming(params);
  }else if(message.data['NotificationType'] == 'call_ended'){

  }
}



@pragma('vm:entry-point')
void backgroundNotificationTap(NotificationResponse notificationResponse) {
  final String? payload = notificationResponse.payload;
  debugPrint("🔙 Background Notification tapped. Payload: $payload");
}

class PushNotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static String? fcmToken;
  static String? apnsToken;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static DarwinInitializationSettings initializationSettingsDarwin =const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  static firebaseNotification() async {
    firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    firebaseMessaging.isAutoInitEnabled;
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = const DarwinInitializationSettings();

    var platform = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    // firebaseMessaging.requestPermission();

    initLocalNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? appleNotification = message.notification?.apple;
      debugPrint('🔔message notification title=====${message.notification?.title}');
      debugPrint('🔔message notification title=====${message.notification?.title}');
      debugPrint('📝message notification body=====${message.notification?.body}');
      debugPrint('📝message notification data=====${message.data['NotificationType']}');
      debugPrint('notification body=====$notification.  $android.   $appleNotification');

      if ((notification != null && android != null)||message.data!=null) {
        if(message.data['NotificationType']=='call'){

        }else if(message.data['NotificationType'] == 'call_ended'){

        }else{
          showNotification(message.notification,message.data);
        }
        debugPrint('android not null notification==${message.notification}');
        FirebaseMessaging.instance.getInitialMessage().then((message) {
          if (message != null) {
            debugPrint("abc525");
          } else {
            debugPrint("123154115415abc");
          }
        });
      } else if (notification != null && appleNotification != null) {
        // await showNotification(message.notification);
        debugPrint('apple notification1');
        showCustomSnackBar(notification.title.toString(), notification.body.toString(), navigatorKey.currentContext!);
      }
    },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.notification != null) {
        print('called on tap');
        print(message.notification?.body);
        print(message.data);
        if(message.data['conversationId']!=null){
          navigateFromNotification(entityType: 'chat',entityId: message.data['conversationId'],);
        }else if(message.data['NotificationType']=='live_streaming'){
          // Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => LiveStreamScreen(token: message.data['token'],
          //     appId: message.data['appId'],
          //     channelId: message.data['channelName'],
          //     isCollaborator: false, streamId: message.data['liveSessionId'],),));
        }else{
          navigateFromNotification(entityType: message.data['entity_type']??'notification',entityId: message.data['entity_id']??'',);
        }
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.getToken().then((String? token) async {
      if (token == null) {
        debugPrint('FCM token is null');
      } else {
        fcmToken = token;
        debugPrint('FCM token: $token');
      }
    }).catchError((error) {
      debugPrint('Error getting FCM token: ${error.toString()}');
    });

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      debugPrint('FlutterFire Messaging Example: Getting APNs token...');
      String? token = await FirebaseMessaging.instance.getAPNSToken();
      apnsToken = token;
      debugPrint('FlutterFire Messaging Example: Got APNs token: $token');
    }
  }




  static Future initLocalNotification() async {
    if (Platform.isIOS) {
      var initializationSettingsAndroid = const AndroidInitializationSettings('ic_launcher');

      final InitializationSettings initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin);

      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
    } else {
      var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

      const initializationSettingsIOS = DarwinInitializationSettings();


      var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse:backgroundNotificationTap,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      );
    }
  }

  static Future<void> showNotification(RemoteNotification? notification,Map<String, dynamic>? data) async {
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
      notification?.title,
      notification?.body,
      platform,
      payload: jsonEncode(data),
    );
  }

  static Future _onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    debugPrint("receive==$payload,== $body");
  }

  static Future _selectNotification(String? payload) async {
    debugPrint('notification payload: $payload');
  }

  static void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    // NotificationsController  controller = Get.put(NotificationsController());
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      try {
        debugPrint('notification payload: $payload');
        Map<String,dynamic>? dataIs = jsonDecode(payload);
        if(dataIs?['conversationId']!=null){
          navigateFromNotification(entityType: 'chat',entityId: dataIs?['conversationId']??'',);
        }else if(dataIs?['NotificationType']=='live_streaming'){
          // Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => LiveStreamScreen(token: dataIs?['token'],
          //     appId: dataIs?['appId'],
          //     channelId: dataIs?['channelName'],
          //      streamId: dataIs?['liveSessionId'],
          //     isCollaborator: false),));
        }else{
          navigateFromNotification(entityType: dataIs?['entity_type']??'notifications',entityId: dataIs?['entity_id']??'',);
        }
      } catch (e) {
        debugPrint('Error parsing payload: $e');
      }
    }
  }

  static showCustomSnackBar(String title, String message, BuildContext context) {
    print("object>>>> $title \n $message");
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
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: Colors.black,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      duration: const Duration(seconds: 3),
      onTap: (_) {
        // final NotificationsController controller = Get.put(NotificationsController());
        // final type = controller.apiData.value.notification?.first.type ?? "";
        // _handleNotificationTap(type: type, title: title);
      },
    ).show(context);
  }

  static Future<void> navigateFromNotification({
    required String entityType,
    required dynamic entityId,
    Map<String, dynamic>? extraData,
  }) async {

    final context = navigatorKey.currentContext;

    if (context == null) {
      debugPrint("❌ navigatorKey context is null");
      return;
    }

    debugPrint("🔀 Notification navigate: type=$entityType id=$entityId");

    switch (entityType) {

      case "chat":
        // Navigator.pushNamed(
        //   context,
        //   AppRoutes.messageDetailsScreen,
        //   arguments: {"conversion_id": entityId},
        // );
        break;

      case "call":
        // Navigator.pushNamed(
        //   context,
        //   AppRoutes.ringingCallCard,
        //   arguments: {
        //     "appId": extraData?['appId'],
        //     "callType":extraData?['callType'],
        //     "token": extraData?['token'],
        //     "channelName": extraData?['channelName'],
        //     "userName": extraData?['callerName'] ?? '',
        //     "userImageUrl": extraData?['callerImage'] ?? '',
        //   },
        // );
        break;

      case "reel":
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder:
        //         (context) => Singlereelscreen(
        //       isFirstLoad: true,
        //       reelId: entityId,
        //     ),
        //   ),
        // );
        break;

      case "post":
        // Navigator.pushNamed(
        //   context,
        //   AppRoutes.singlePost,
        //   arguments: {'postId': entityId ?? ""},
        // );

        break;

      case "profile":
        // Navigator.pushNamed(
        //   context,
        //   AppRoutes.userProfileScreen,
        //   arguments: entityId,
        // );
        break;

      case "notification":
        // Navigator.pushNamed(context, AppRoutes.allNotifications);
        break;

      default:
        // Navigator.pushNamed(context, AppRoutes.allNotifications);
        debugPrint("⚠ Unknown entityType: $entityType");
        break;
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
