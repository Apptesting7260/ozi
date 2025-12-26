
import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
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

class _NotificationsContent extends StatelessWidget {
  const _NotificationsContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VendorNotificationProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomAppBar(title: "Notifications"),
              hBox(20),

              Expanded(
                child: ListView.separated(
                  itemCount: provider.notifications.length,
                  separatorBuilder: (_, __) => hBox(12),
                  itemBuilder: (context, index) {
                    final notification = provider.notifications[index];
                    return _notificationTile(
                      notification,
                      onTap: () => provider.markAsRead(index),
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

  // ================= TILE =================
  Widget _notificationTile(
      AppNotification notification, {
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isUnread
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.lightGrey2,
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
                    notification.title,
                    style: AppFontStyle.text_14_600(AppColors.darkText),
                  ),
                  hBox(4),
                  Text(
                    notification.message,
                    style: AppFontStyle.text_13_400(AppColors.grey),
                  ),
                  hBox(6),
                  Text(
                    notification.time,
                    style: AppFontStyle.text_11_400(AppColors.grey),
                  ),
                ],
              ),
            ),

            if (notification.isUnread)
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
  Widget _icon(NotificationType type) {
    IconData icon;
    Color bg;

    switch (type) {
      case NotificationType.booking:
        icon = Icons.calendar_today_outlined;
        bg = AppColors.primary.withValues(alpha: 0.12);
        break;
      case NotificationType.payment:
        icon = Icons.attach_money;
        bg = AppColors.primary.withValues(alpha: 0.12);
        break;
      case NotificationType.cancelled:
        icon = Icons.close;
        bg = AppColors.grey.withValues(alpha: 0.15);
        break;
    }

    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 20, color: AppColors.primary),
    );
  }
}
