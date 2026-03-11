class GuestUser {
  bool? status;
  String? message;
  GuestUserData? data;

  GuestUser({this.status, this.message, this.data});

  GuestUser.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new GuestUserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GuestUserData {
  int? userId;
  String? userRole;
  String? apiToken;

  GuestUserData({this.userId, this.userRole, this.apiToken});

  GuestUserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userRole = json['user_role'];
    apiToken = json['api_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_role'] = this.userRole;
    data['api_token'] = this.apiToken;
    return data;
  }
}