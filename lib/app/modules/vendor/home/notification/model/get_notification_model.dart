import 'dart:convert';
import 'package:ozi/app/data/models/vendorservicedetailmodel.dart';

class GetNotificationModel {
  bool? status;
  String? userRole;
  int? unreadCount;
  Data? data;

  GetNotificationModel({
    this.status,
    this.userRole,
    this.unreadCount,
    this.data,
  });

  GetNotificationModel.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] == true ||
        json['status'] == 'true' ||
        json['status'] == 1;
    userRole = json['user_role']?.toString();
    unreadCount = json['unread_count'] != null
        ? int.tryParse(json['unread_count'].toString())
        : null;
    data = (json['data'] != null && json['data'] is Map<String, dynamic>)
        ? Data.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['user_role'] = this.userRole;
    data['unread_count'] = this.unreadCount;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  List<Items>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'] != null
        ? int.tryParse(json['current_page'].toString())
        : null;

    if (json['data'] != null && json['data'] is List) {
      data = <Items>[];
      json['data'].forEach((v) {
        if (v is Map<String, dynamic>) {
          data!.add(Items.fromJson(v));
        }
      });
    } else {
      data = [];
    }

    firstPageUrl = json['first_page_url']?.toString();
    from = json['from'] != null ? int.tryParse(json['from'].toString()) : null;
    lastPage = json['last_page'] != null
        ? int.tryParse(json['last_page'].toString())
        : null;
    lastPageUrl = json['last_page_url']?.toString();

    if (json['links'] != null && json['links'] is List) {
      links = <Links>[];
      json['links'].forEach((v) {
        if (v is Map<String, dynamic>) {
          links!.add(Links.fromJson(v));
        }
      });
    }

    nextPageUrl = json['next_page_url']?.toString();
    path = json['path']?.toString();
    perPage = json['per_page'] != null
        ? int.tryParse(json['per_page'].toString())
        : null;
    prevPageUrl = json['prev_page_url']?.toString();
    to = json['to'] != null ? int.tryParse(json['to'].toString()) : null;
    total = json['total'] != null
        ? int.tryParse(json['total'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Items {
  int? id;
  int? notifiableId;
  String? notifiableType;
  String? type;
  String? title;
  String? message;
  Type? data;
  bool? isRead;
  String? createdAt;
  String? updatedAt;

  Items({
    this.id,
    this.notifiableId,
    this.notifiableType,
    this.type,
    this.title,
    this.message,
    this.data,
    this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    notifiableId = json['notifiable_id'] != null
        ? int.tryParse(json['notifiable_id'].toString())
        : null;
    notifiableType = json['notifiable_type']?.toString();
    type = json['type']?.toString();
    title = json['title']?.toString();
    message = json['message']?.toString();

    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      data = Type.fromJson(json['data']);
    } else {
      data = null;
    }

    isRead =
        json['is_read'] == true ||
        json['is_read'] == 'true' ||
        json['is_read'] == 1;
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['notifiable_id'] = this.notifiableId;
    data['notifiable_type'] = this.notifiableType;
    data['type'] = this.type;
    data['title'] = this.title;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Type {
  int? bookingId;
  String? screen;
  String? type;

  Type({this.bookingId, this.screen, this.type});

  Type.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'] != null
        ? int.tryParse(json['booking_id'].toString())
        : null;
    screen = json['screen']?.toString();
    type = json['type']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = this.bookingId;
    data['screen'] = this.screen;
    data['type'] = this.type;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url']?.toString();
    label = json['label']?.toString();
    active =
        json['active'] == true ||
        json['active'] == 'true' ||
        json['active'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
