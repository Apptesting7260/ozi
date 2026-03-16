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
    status = json['status'];
    userRole = json['user_role'];
    unreadCount = json['unread_count'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  Null? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
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
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Items>[];
      json['data'].forEach((v) {
        data!.add(new Items.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    id = json['id'];
    notifiableId = json['notifiable_id'];
    notifiableType = json['notifiable_type'];
    type = json['type'];
    title = json['title'];
    message = json['message'];
    data = json['data'] != null ? new Type.fromJson(json['data']) : null;
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    bookingId = json['booking_id'];
    screen = json['screen'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
