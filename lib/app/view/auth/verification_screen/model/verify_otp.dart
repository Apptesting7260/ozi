class VerifyOtp {
  bool? status;
  String? message;
  String? userId;
  String? type;
  bool? isRegistrationComplete;
  bool? isLoggedIn;
  String? nextStep;
  String? role;
  String? token;
  String? stepCompleted;
  bool? isRoleSelected;
  bool? isVerifiedByAdmin;

  VerifyOtp({
    this.userId,
    this.stepCompleted,
    this.type,
    this.token,
    this.isLoggedIn,
    this.isRegistrationComplete,
    this.nextStep,
    this.role,
    this.status,
    this.message,
    this.isRoleSelected,
    this.isVerifiedByAdmin
  });

  VerifyOtp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    if (json['data'] != null) {
      final data = json['data'];

      userId = data['user_id']?.toString();
      type = data['type'];
      isRegistrationComplete = data['is_registration_complete'];
      isLoggedIn = data['is_logged_in'];
      isRoleSelected = (data['is_role_selected'] == true ||
              data['is_role_selected'] == 1 ||
              data['is_role_selected'] == '1') ||
          (data['user_role'] != null && data['user_role'].toString().isNotEmpty);
      nextStep = data['next_step'];
      role = data['user_role'];
      token = data['api_token'];
      stepCompleted = data['step_completed']?.toString();
      isVerifiedByAdmin = data['verified_by_admin'];
    }
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message};
  }
}
