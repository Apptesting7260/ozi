class helpSupportModel {
  String? status;
  String? massage;
  Actions? actions;
  List<Data>? data;

  helpSupportModel({this.status, this.massage, this.actions, this.data});

  helpSupportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    massage = json['massage'];
    actions = json['actions'] != null
        ? new Actions.fromJson(json['actions'])
        : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['massage'] = this.massage;
    if (this.actions != null) {
      data['actions'] = this.actions!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Actions {
  String? emailUs;
  int? callUs;

  Actions({this.emailUs, this.callUs});

  Actions.fromJson(Map<String, dynamic> json) {
    emailUs = json['email_us'];
    callUs = json['call_us'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_us'] = this.emailUs;
    data['call_us'] = this.callUs;
    return data;
  }
}

class Data {
  int? id;
  String? type;
  String? question;
  String? answer;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.type,
    this.question,
    this.answer,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    question = json['question'];
    answer = json['answer'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
