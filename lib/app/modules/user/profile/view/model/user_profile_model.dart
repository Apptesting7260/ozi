class UserProfileModel         {
  bool? status;
  String? message;
  ProfileData? data;

  UserProfileModel({this.status, this.message, this.data});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProfileData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? proImg;
  String? countryCode;
  String? mobile;
  String? userRole;
  bool? isMobileVerified;
  String? otpExpireAt;
  Null terms;
  String? status;
  int? stepCompleted;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;

  ProfileData(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.proImg,
        this.countryCode,
        this.mobile,
        this.userRole,
        this.isMobileVerified,
        this.otpExpireAt,
        this.terms,
        this.status,
        this.stepCompleted,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    proImg = json['pro_img'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    userRole = json['user_role'];
    isMobileVerified = json['is_mobile_verified'];
    otpExpireAt = json['otp_expire_at'];
    terms = json['terms'];
    status = json['status'];
    stepCompleted = json['step_completed'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['pro_img'] = proImg;
    data['country_code'] = countryCode;
    data['mobile'] = mobile;
    data['user_role'] = userRole;
    data['is_mobile_verified'] = isMobileVerified;
    data['otp_expire_at'] = otpExpireAt;
    data['terms'] = terms;
    data['status'] = status;
    data['step_completed'] = stepCompleted;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
