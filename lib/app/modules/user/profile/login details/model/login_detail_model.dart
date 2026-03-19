class CurrentUserLoginModel {
  bool? status;
  List<Data>? data;

  CurrentUserLoginModel({this.status, this.data});

  CurrentUserLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? deviceName;
  String? lastUsedAt;
  String? city;
  String? state;
  String? country;
  String? loggedInAt;
  bool? isCurrentDevice;

  Data({
    this.id,
    this.deviceName,
    this.lastUsedAt,
    this.city,
    this.state,
    this.country,
    this.loggedInAt,
    this.isCurrentDevice,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceName = json['device_name'];
    lastUsedAt = json['last_used_at'];
    city = json['deivce_city'];
    state = json['device_state'];
    country = json['device_country'];
    loggedInAt = json['logged_in_at'];
    isCurrentDevice = json['is_current_device'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['device_name'] = deviceName;
    data['last_used_at'] = lastUsedAt;
    data['logged_in_at'] = loggedInAt;
    data['is_current_device'] = isCurrentDevice;
    return data;
  }
}
