//
// import '../../../../../core/appExports/app_export.dart';
// import '../../../../../shared/widgets/custom_app_bar.dart';
// import '../model/get_notification_model.dart';
// import '../provider/vendor_ notification_provider.dart';
//
// class NotificationsScreen extends StatelessWidget {
//   const NotificationsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => VendorNotificationProvider(),
//       child: const _NotificationsContent(),
//     );
//   }
// }
//
//
// class _NotificationsContent extends StatelessWidget {
//   const _NotificationsContent();
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<VendorNotificationProvider>();
//
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               CustomAppBar(title: "Notifications"),
//               hBox(20),
//
//               Expanded(
//                 child: provider.isLoading
//                     ? const Center(
//                   child: CircularProgressIndicator(),
//                 )
//
//                 //  EMPTY STATE AFTER LOADING
//                     : provider.notifications.isEmpty
//                     ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.notifications_none,
//                         size: 80,
//                         color: AppColors.grey.withValues(alpha: 0.3),
//                       ),
//                       hBox(16),
//                       Text(
//                         "No notification",
//                         style: AppFontStyle.text_16_400(
//                           AppColors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//
//                 // DATA LIST
//                     : ListView.separated(
//                   itemCount: provider.notifications.length,
//                   separatorBuilder: (_, __) => hBox(12),
//                   itemBuilder: (context, index) {
//                     final notification =
//                     provider.notifications[index];
//
//                     return _notificationTile(
//                       notification,
//                       onTap: () =>
//                           provider.markAsRead(index),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ================= TILE =================
//   Widget _notificationTile(
//       NotificationItem  notification, {
//         required VoidCallback onTap,
//       }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: notification.isRead == true
//               ? AppColors.primary.withValues(alpha: 0.08)
//               : AppColors.lightGrey2,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _icon(notification.type),
//             wBox(12),
//
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     notification.title ?? "",
//                     style: AppFontStyle.text_14_600(AppColors.darkText),
//                   ),
//                   hBox(4),
//                   Text(
//                     notification.message ?? "",
//                     style: AppFontStyle.text_13_400(AppColors.grey),
//                   ),
//                   hBox(6),
//                   Text(
//                     Get.formatTime(notification.time),
//                     style: AppFontStyle.text_11_400(AppColors.grey),
//                   ),
//
//                 ],
//               ),
//             ),
//
//             if (notification.isRead != true)
//               Container(
//                 height: 8,
//                 width: 8,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: AppColors.primary,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ================= ICON =================
//   // Widget _icon(NotificationItem isRead) {
//   //   IconData icon;
//   //   Color bg;
//   //
//   //   switch (isRead) {
//   //     case NotificationType.booking:
//   //       icon = Icons.calendar_today_outlined;
//   //       bg = AppColors.primary.withValues(alpha: 0.12);
//   //       break;
//   //     case NotificationType.payment:
//   //       icon = Icons.attach_money;
//   //       bg = AppColors.primary.withValues(alpha: 0.12);
//   //       break;
//   //     case NotificationType.cancelled:
//   //       icon = Icons.close;
//   //       bg = AppColors.grey.withValues(alpha: 0.15);
//   //       break;
//   //   }
//   //
//   //   return Container(
//   //     height: 40,
//   //     width: 40,
//   //     decoration: BoxDecoration(
//   //       color: bg,
//   //       borderRadius: BorderRadius.circular(12),
//   //     ),
//   //     child: Icon(icon, size: 20, color: AppColors.primary),
//   //   );
//   // }
//
//   Widget _icon(String? type) {
//     IconData icon;
//     Color bg;
//
//     switch (type) {
//       case "debit":
//         icon = Icons.attach_money;
//         bg = AppColors.primary.withValues(alpha: 0.12);
//         break;
//
//       case "credit":
//         icon = Icons.attach_money;
//         bg = AppColors.primary.withValues(alpha: 0.12);
//         break;
//
//
//       case "booking_cancelled":
//         icon = Icons.close;
//         bg = AppColors.grey.withValues(alpha: 0.15);
//         break;
//
//       default:
//         icon = Icons.calendar_today_outlined;
//         bg = AppColors.primary.withValues(alpha: 0.12);
//     }
//
//     return Container(
//       height: 40,
//       width: 40,
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Icon(
//         icon,
//         size: 20,
//         color: AppColors.primary,
//       ),
//     );
//   }
// }


import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../model/get_notification_model.dart';
import '../provider/vendor_ notification_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VendorNotificationProvider(),
      child: const _NotificationsContent(),
    );
  }
}


class _NotificationsContent extends StatefulWidget {
  const _NotificationsContent();

  @override
  State<_NotificationsContent> createState() =>
      _NotificationsContentState();
}


class _NotificationsContentState
    extends State<_NotificationsContent> {

  final ScrollController _scrollController = ScrollController();
  late VendorNotificationProvider _provider;

  @override
  void initState() {
    super.initState();

    _provider = context.read<VendorNotificationProvider>();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _provider.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _provider.readNotifications();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VendorNotificationProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomAppBar(title: "Notifications"),

              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                  controller: _scrollController,
                  itemCount: provider.notifications.length +
                      (provider.isPaginationLoading ? 1 : 0),
                  separatorBuilder: (_, __) => hBox(12),
                  itemBuilder: (context, index) {
                    if (index == provider.notifications.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final notification =
                    provider.notifications[index];

                    return _notificationTile(
                      notification,
                      onTap: () =>
                          provider.markAsRead(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// ================= TILE =================
Widget _notificationTile(
    NotificationItem  notification, {
      required VoidCallback onTap,
    }) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: notification.isRead == true
            ? AppColors.readNotification
            : AppColors.unReadNotification,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _icon(notification.type),
          wBox(12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title ?? "",
                  style: AppFontStyle.text_14_600(AppColors.darkText),
                ),
                hBox(4),
                Text(
                  notification.message ?? "",
                  style: AppFontStyle.text_13_400(AppColors.grey),
                ),
                hBox(6),
                Text(
                  Get.formatTime(notification.time),
                  style: AppFontStyle.text_11_400(AppColors.grey),
                ),

              ],
            ),
          ),

          if (notification.isRead != true)
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    ),
  );
}

// ================= ICON =================
// Widget _icon(NotificationItem isRead) {
//   IconData icon;
//   Color bg;
//
//   switch (isRead) {
//     case NotificationType.booking:
//       icon = Icons.calendar_today_outlined;
//       bg = AppColors.primary.withValues(alpha: 0.12);
//       break;
//     case NotificationType.payment:
//       icon = Icons.attach_money;
//       bg = AppColors.primary.withValues(alpha: 0.12);
//       break;
//     case NotificationType.cancelled:
//       icon = Icons.close;
//       bg = AppColors.grey.withValues(alpha: 0.15);
//       break;
//   }
//
//   return Container(
//     height: 40,
//     width: 40,
//     decoration: BoxDecoration(
//       color: bg,
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Icon(icon, size: 20, color: AppColors.primary),
//   );
// }

Widget _icon(String? type) {
  IconData icon;
  Color bg;
  Color? iconColor;

  switch (type) {
    case "debit":
      icon = Icons.attach_money;
      //bg = AppColors.primary.withValues(alpha: 0.12);
      bg = AppColors.white;
      break;

    case "credit":
      icon = Icons.attach_money;
     // bg = AppColors.primary.withValues(alpha: 0.12);
      bg = AppColors.white;
      break;


    case "booking_cancelled":
      icon = Icons.close;
      // bg = AppColors.grey.withValues(alpha: 0.15);
      bg = AppColors.white;
      break;

    default:
      icon = Icons.calendar_month_outlined;
      // bg = AppColors.primary.withValues(alpha: 0.12);
      bg = AppColors.white;
      iconColor = AppColors.grey;
  }

  return Container(
    height: 40,
    width: 40,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(
      icon,
      size: 20,
      color: iconColor ??  AppColors.primary,
    ),
  );
}

