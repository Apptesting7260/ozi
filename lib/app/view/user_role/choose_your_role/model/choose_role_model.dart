class ChooseRoleModel {
  bool? status;
  String? message;
  Data? data;

  ChooseRoleModel({this.status, this.message, this.data});

  ChooseRoleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? userId;
  String? userRole;
  bool? isRegistrationComplete;
  String? nextStep;

  Data(
      {this.userId, this.userRole, this.isRegistrationComplete, this.nextStep});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userRole = json['user_role'];
    isRegistrationComplete = json['is_registration_complete'];
    nextStep = json['next_step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_role'] = this.userRole;
    data['is_registration_complete'] = this.isRegistrationComplete;
    data['next_step'] = this.nextStep;
    return data;
  }
}