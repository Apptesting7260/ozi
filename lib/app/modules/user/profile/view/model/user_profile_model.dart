class UserProfileModel {
  bool? status;
  String? message;
  ProfileData? data;

  UserProfileModel({this.status, this.message, this.data});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
    json['data'] != null ? ProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ProfileData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;

  String? emailOtp;
  String? emailOtpExpire;
  bool? isEmailVerified;
  String? pendingEmail;
  int? isPendingOtpVerified;

  String? proImg;
  String? countryCode;
  String? mobile;
  String? userRole;
  bool? isMobileVerified;

  int? isNotificationOn;
  int? emailNotification;

  String? otpExpireAt;
  dynamic terms;
  String? status;
  int? stepCompleted;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  VendorDetail? vendorDetail;

  ProfileData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.emailOtp,
    this.emailOtpExpire,
    this.isEmailVerified,
    this.pendingEmail,
    this.isPendingOtpVerified,
    this.proImg,
    this.countryCode,
    this.mobile,
    this.userRole,
    this.isMobileVerified,
    this.isNotificationOn,
    this.emailNotification,
    this.otpExpireAt,
    this.terms,
    this.status,
    this.stepCompleted,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.vendorDetail,
  });

  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];

    emailOtp = json['email_otp'];
    emailOtpExpire = json['email_otp_expire'];
    isEmailVerified = json['is_email_verified'];
    pendingEmail = json['pending_email'];
    isPendingOtpVerified = json['is_pending_otp_verified'];

    proImg = json['pro_img'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    userRole = json['user_role'];
    isMobileVerified = json['is_mobile_verified'];

    isNotificationOn = json['is_notification_on'];
    emailNotification = json['email_notification'];

    otpExpireAt = json['otp_expire_at'];
    terms = json['terms'];
    status = json['status'];
    stepCompleted = json['step_completed'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    vendorDetail = json['vendor_detail'] != null
        ? VendorDetail.fromJson(json['vendor_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'email_otp': emailOtp,
      'email_otp_expire': emailOtpExpire,
      'is_email_verified': isEmailVerified,
      'pending_email': pendingEmail,
      'is_pending_otp_verified': isPendingOtpVerified,
      'pro_img': proImg,
      'country_code': countryCode,
      'mobile': mobile,
      'user_role': userRole,
      'is_mobile_verified': isMobileVerified,
      'is_notification_on': isNotificationOn,
      'email_notification': emailNotification,
      'otp_expire_at': otpExpireAt,
      'terms': terms,
      'status': status,
      'step_completed': stepCompleted,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'vendor_detail': vendorDetail?.toJson(),
    };
  }
}

class VendorDetail {
  int? userId;
  String? certificate;
  String? governmentIdImage;

  VendorDetail({this.userId, this.certificate, this.governmentIdImage});

  VendorDetail.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    certificate = json['certificate'];
    governmentIdImage = json['government_id_image'];
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'certificate': certificate,
      'government_id_image': governmentIdImage,
    };
  }
}