class LoginModel {
  bool? status;
  String? message;
  LoginModelData? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? LoginModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class LoginModelData {
  bool? isDeleted;
  bool? canRestore;
  int? deletedDays;

  LoginModelData({this.isDeleted, this.canRestore, this.deletedDays});

  LoginModelData.fromJson(Map<String, dynamic> json) {
    isDeleted = json['is_deleted'];
    canRestore = json['can_restore'];
    deletedDays = json['deleted_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['is_deleted'] = isDeleted;
    map['can_restore'] = canRestore;
    map['deleted_days'] = deletedDays;
    return map;
  }
}