class settingsModel {
  bool? status;
  Data? data;

  settingsModel({this.status, this.data});

  settingsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? isNotificationOn;
  bool? emailnotification;
  String? termsUrl;
  String? privacyUrl;

  Data({
    this.isNotificationOn,
    this.emailnotification,
    this.termsUrl,
    this.privacyUrl,
  });

  Data.fromJson(Map<String, dynamic> json) {
    isNotificationOn = json['is_notification_on'];
    emailnotification = json['email_notification'];
    termsUrl = json['terms_url'];
    privacyUrl = json['privacy_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_notification_on'] = this.isNotificationOn;
    data['email_notification'] = this.emailnotification;
    data['terms_url'] = this.termsUrl;
    data['privacy_url'] = this.privacyUrl;
    return data;
  }
}
