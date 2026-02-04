class MessageListModel {
  bool? status;
  List<MessageListModelData> data = [];

  MessageListModel({this.status, required this.data});

  MessageListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = [];
    if (json['data'] != null) {
      data = <MessageListModelData>[];
      json['data'].forEach((v) {
        data!.add(new MessageListModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessageListModelData {
  String? sId;
  String? conversationId;
  String? senderId;
  String? text;
  List<String>? fileUrl;
  List<MessageListModelSeenBy>? seenBy;
  String? status;
  bool? isDeleted;
  List<Reactions>? reactions;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? senderType;
  bool? mediaUploadLoading;
  String? dataLink;

  MessageListModelData(
      {this.sId,
        this.conversationId,
        this.senderId,
        this.text,
        this.fileUrl,
        this.seenBy,
        this.status,
        this.isDeleted,
        this.reactions,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.senderType,
        this.dataLink,
        this.mediaUploadLoading});

  MessageListModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversationId = json['conversationId'];
    senderId = json['senderId'];
    text = json['text'];
    if (json['fileUrl'] != null) {
      fileUrl = <String>[];
      json['fileUrl'].forEach((v) {
        fileUrl!.add(v.toString());
      });
    }
    if (json['seen_by'] != null) {
      seenBy = <MessageListModelSeenBy>[];
      json['seen_by'].forEach((v) {
        seenBy!.add(new MessageListModelSeenBy.fromJson(v));
      });
    }
    status = json['status'];
    isDeleted = json['isDeleted'];
    dataLink = json['dataLink']?.toString();
    if (json['reactions'] != null) {
      reactions = <Reactions>[];
      json['reactions'].forEach((v) {
        reactions!.add(new Reactions.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    senderType = json['senderType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['conversationId'] = this.conversationId;
    data['senderId'] = this.senderId;
    data['text'] = this.text;
    // if (this.fileUrl != null) {
    //   data['fileUrl'] = this.fileUrl!.map((v) => v.toJson()).toList();
    // }
    if (this.seenBy != null) {
      data['seen_by'] = this.seenBy!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['isDeleted'] = this.isDeleted;
    // if (this.reactions != null) {
    //   data['reactions'] = this.reactions!.map((v) => v.toJson()).toList();
    // }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['senderType'] = this.senderType;
    return data;
  }
}

class Reactions {
  String? userId;
  String? reaction;
  String? sId;
  String? createdAt;

  Reactions({this.userId, this.reaction, this.sId, this.createdAt});

  Reactions.fromJson(Map<String, dynamic> json) {
    userId = json['userId']?.toString();
    reaction = json['reaction']?.toString();
    sId = json['_id']?.toString();
    createdAt = json['createdAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['reaction'] = this.reaction;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}


class MessageListModelSeenBy {
  String? userId;
  String? status;
  String? sId;
  String? seenAt;

  MessageListModelSeenBy({this.userId, this.status, this.sId, this.seenAt});

  MessageListModelSeenBy.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    status = json['status'];
    sId = json['_id'];
    seenAt = json['seenAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['seenAt'] = this.seenAt;
    return data;
  }
}
