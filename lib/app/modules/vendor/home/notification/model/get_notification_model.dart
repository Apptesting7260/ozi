import 'dart:convert';

GetNotificationModel getNotificationModelFromJson(String str) =>
    GetNotificationModel.fromJson(json.decode(str));

String getNotificationModelToJson(GetNotificationModel data) =>
    json.encode(data.toJson());

class GetNotificationModel {
  bool? status;
  int? unreadCount;
  NotificationData? data;

  GetNotificationModel({
    this.status,
    this.unreadCount,
    this.data,
  });

  factory GetNotificationModel.fromJson(Map<String, dynamic> json) =>
      GetNotificationModel(
        status: json["status"],
        unreadCount: json["unread_count"],
        data: json["data"] == null
            ? null
            : NotificationData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "unread_count": unreadCount,
    "data": data?.toJson(),
  };
}

class NotificationData {
  int? currentPage;
  List<NotificationItem>? data;
  int? lastPage;
  int? total;
  String? nextPageUrl;

  NotificationData({
    this.currentPage,
    this.data,
    this.lastPage,
    this.total,
    this.nextPageUrl,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<NotificationItem>.from(
          json["data"].map(
                (x) => NotificationItem.fromJson(x),
          ),
        ),
        lastPage: json["last_page"],
        total: json["total"],
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "last_page": lastPage,
    "total": total,
    "next_page_url": nextPageUrl,
  };
}

class NotificationItem {
  int? id;
  String? title;
  String? message;
  String? time;
  bool? isRead;
  String? type;

  NotificationItem({
    this.id,
    this.title,
    this.message,
    this.time,
    this.isRead,
    this.type,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        time: json["created_at"],
        isRead: json["is_read"] == true || json["is_read"] == 1,
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "message": message,
    "time": time,
    "is_read": isRead,
    "type": type,
  };
}
