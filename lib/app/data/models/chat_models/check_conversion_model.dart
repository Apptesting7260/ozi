class CheckConverstionModel {
  bool? status;
  CheckConverstionModelData? data;

  CheckConverstionModel({this.status, this.data});

  CheckConverstionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new CheckConverstionModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CheckConverstionModelData {
  String? chatType;
  List<Participants>? participants;
  String? sId;
  String? activity;
  String? createdAt;
  String? updatedAt;
  String? iV;

  CheckConverstionModelData(
      {this.chatType,
        this.participants,
        this.sId,
        this.activity,
        this.createdAt,
        this.updatedAt,
        this.iV});

  CheckConverstionModelData.fromJson(Map<String, dynamic> json) {
    chatType = json['chat_type']?.toString();
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(new Participants.fromJson(v));
      });
    }
    sId = json['_id']?.toString();
    activity = json['activity']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    iV = json['__v']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_type'] = this.chatType;
    if (this.participants != null) {
      data['participants'] = this.participants!.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['activity'] = this.activity;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Participants {
  String? userId;
  bool? isMuted;
  bool? isDeleted;
  String? sId;
  String? joinedAt;

  Participants(
      {this.userId, this.isMuted, this.isDeleted, this.sId, this.joinedAt});

  Participants.fromJson(Map<String, dynamic> json) {
    userId = json['user_id']?.toString();
    isMuted = json['isMuted'];
    isDeleted = json['isDeleted'];
    sId = json['_id']?.toString();
    joinedAt = json['joinedAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['isMuted'] = this.isMuted;
    data['isDeleted'] = this.isDeleted;
    data['_id'] = this.sId;
    data['joinedAt'] = this.joinedAt;
    return data;
  }
}
