class helpSupportModel {
  dynamic status;
  String? massage;
  Actions? actions;
  List<Data>? data;

  helpSupportModel({this.status, this.massage, this.actions, this.data});

  helpSupportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    massage = json['massage'] ?? json['message'];
    actions = json['actions'] != null
        ? Actions.fromJson(json['actions'])
        : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['massage'] = massage;
    if (actions != null) {
      data['actions'] = actions!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Actions {
  String? emailUs;
  dynamic callUs;

  Actions({this.emailUs, this.callUs});

  Actions.fromJson(Map<String, dynamic> json) {
    emailUs = json['email_us'];
    callUs = json['call_us'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email_us'] = emailUs;
    data['call_us'] = callUs;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['question'] = question;
    data['answer'] = answer;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
