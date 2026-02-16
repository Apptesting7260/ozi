class ReadnotificationModel {
  bool? status;
  String? message;
  int? updatedCount;
  int? unreadCount;

  ReadnotificationModel(
      {this.status, this.message, this.updatedCount, this.unreadCount});

  ReadnotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    updatedCount = json['updated_count'];
    unreadCount = json['unread_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['updated_count'] = this.updatedCount;
    data['unread_count'] = this.unreadCount;
    return data;
  }
}