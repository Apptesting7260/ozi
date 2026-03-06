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
      isRoleSelected = data['is_role_selected'];
      nextStep = data['next_step'];
      role = data['user_role'];
      token = data['api_token'];
      stepCompleted = data['step_completed']?.toString();
    }
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message};
  }
}
