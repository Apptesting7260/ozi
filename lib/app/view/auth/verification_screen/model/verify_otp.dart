class verifyOtp {
  bool? status;
  String? message;
  String? userId;

  verifyOtp({this.status, this.message,this.userId});

  verifyOtp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['data']['user_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}