import 'package:ozi/app/modules/user/booking/booking details/view/booking_details_screen.dart';
import 'package:ozi/app/modules/user/booking/provider/booking_provider.dart';
import 'package:ozi/app/modules/vendor/bookings/booking details/view/vendor_booking_details_screen.dart';
import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../model/get_notification_model.dart';
import '../provider/vendor_ notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => NotificationsContentState();
}

class NotificationsContentState extends State<NotificationsScreen> {
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VendorNotificationProvider>();
    final booking = context.watch<BookingProvider>();

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
                    // EMPTY STATE
                    : provider.notifications.isEmpty
                    ? Center(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.08,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.notifications_none_rounded,
                                    size: 32,
                                    color: AppColors.primary,
                                  ),
                                ),

                                hBox(24),

                                Text(
                                  "No new notifications",
                                  textAlign: TextAlign.center,
                                  style: AppFontStyle.text_16_600(
                                    AppColors.darkText,
                                  ),
                                ),

                                hBox(8),

                                Text(
                                  maxLines: 3,
                                  "Everything looks good. We’ll notify you when something requires your attention.",
                                  textAlign: TextAlign.center,
                                  style: AppFontStyle.text_14_400(
                                    AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller: _scrollController,
                        itemCount:
                            provider.notifications.length +
                            (provider.isPaginationLoading ? 1 : 0),
                        separatorBuilder: (_, __) => hBox(12),
                        itemBuilder: (context, index) {
                          if (index == provider.notifications.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final notification = provider.notifications[index];
                          final data = provider.model;
                          return _notificationTile(
                            data,
                            notification,
                            onTap: () => provider.markAsRead(index),
                            context: context,
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

Widget _notificationTile(
  GetNotificationModel data,
  Items notification, {
  required VoidCallback onTap,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      print("Click on this notification tile");
      data.userRole?.toLowerCase() == "vendor"
          ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VendorBookingDetailsScreen(
                  bookingId: notification.data!.bookingId.toString(),
                ),
              ),
            )
          : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingDetailsScreen(
                  bookingId: notification.data!.bookingId.toString(),
                ),
              ),
            );
    },
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
                  maxLines: 3,
                  notification.message ?? "",

                  overflow: TextOverflow.ellipsis,
                  style: AppFontStyle.text_13_400(AppColors.grey),
                ),
                hBox(6),
                Text(
                  Get.formatTime(notification.createdAt),
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

Widget _icon(String? type) {
  IconData icon;
  Color bg;
  Color? iconColor;

  switch (type) {
    case "debit":
      icon = Icons.attach_money;
      bg = AppColors.white;
      break;

    case "credit":
      icon = Icons.attach_money;
      bg = AppColors.white;
      break;

    case "booking_cancelled":
      icon = Icons.close;
      bg = AppColors.white;
      break;

    default:
      icon = Icons.calendar_month_outlined;
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
    child: Icon(icon, size: 20, color: iconColor ?? AppColors.primary),
  );
}
