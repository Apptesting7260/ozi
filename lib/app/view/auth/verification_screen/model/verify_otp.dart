class verifyOtp {
  bool? status;
  String? message;
  String? userId;
  String? stepCompleted;
  String? role;
  String? token;

  verifyOtp({this.status, this.message,this.userId,this.stepCompleted});

  verifyOtp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['data']['user_id']?.toString();
    stepCompleted = json['data']['step_completed']?.toString();
    role = json['data']['user_role']?.toString();
    token = json['data']['api_token']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}