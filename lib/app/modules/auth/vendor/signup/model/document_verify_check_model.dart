class DocumentStatusModel {
  bool? status;
  String? message;
  DocumentStatusModelData? data;

  DocumentStatusModel({this.status, this.message, this.data});

  DocumentStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DocumentStatusModelData.fromJson(json['data']) : null;
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

class DocumentStatusModelData {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? stepCompleted;
  bool? verifiedByAdmin;

  DocumentStatusModelData(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.stepCompleted,
        this.verifiedByAdmin});

  DocumentStatusModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString() ?? '';
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    stepCompleted = json['step_completed']?.toString() ?? '';
    verifiedByAdmin = json['verified_by_admin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['step_completed'] = this.stepCompleted;
    data['verified_by_admin'] = this.verifiedByAdmin;
    return data;
  }
}