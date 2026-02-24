class CheckConverstionModel {
  bool? status;
  CheckConverstionModelData? data;

  CheckConverstionModel({this.status, this.data});

  CheckConverstionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? CheckConverstionModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
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
        participants!.add(Participants.fromJson(v));
      });
    }
    sId = json['_id']?.toString();
    activity = json['activity']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    iV = json['__v']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_type'] = chatType;
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    data['_id'] = sId;
    data['activity'] = activity;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['isMuted'] = isMuted;
    data['isDeleted'] = isDeleted;
    data['_id'] = sId;
    data['joinedAt'] = joinedAt;
    return data;
  }
}
