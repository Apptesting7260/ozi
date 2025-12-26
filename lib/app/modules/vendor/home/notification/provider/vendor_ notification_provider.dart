import 'package:flutter/material.dart';

class VendorNotificationProvider extends ChangeNotifier {
  final List<AppNotification> _notifications = [
    AppNotification(
      title: "New Booking Request",
      message: "Sarah Johnson has requested Deep Cleaning service",
      time: "2 min ago",
      isUnread: true,
      type: NotificationType.booking,
    ),
    AppNotification(
      title: "Payment Received",
      message: "\$120 has been credited to your wallet",
      time: "1 hour ago",
      isUnread: true,
      type: NotificationType.payment,
    ),
    AppNotification(
      title: "Booking Cancelled",
      message: "Lisa Taylor cancelled the Painting service",
      time: "2 days ago",
      isUnread: false,
      type: NotificationType.cancelled,
    ),
  ];

  List<AppNotification> get notifications => _notifications;

  void markAsRead(int index) {
    _notifications[index] =
        _notifications[index].copyWith(isUnread: false);
    notifyListeners();
  }
}

// ================= MODEL =================

enum NotificationType { booking, payment, cancelled }

class AppNotification {
  final String title;
  final String message;
  final String time;
  final bool isUnread;
  final NotificationType type;

  AppNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.isUnread,
    required this.type,
  });

  AppNotification copyWith({bool? isUnread}) {
    return AppNotification(
      title: title,
      message: message,
      time: time,
      isUnread: isUnread ?? this.isUnread,
      type: type,
    );
  }
}
