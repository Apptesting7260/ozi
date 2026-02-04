class ConversionListModel {
  bool? status;
  List<ConversionListModelData>? data;

  ConversionListModel({this.status, this.data});

  ConversionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ConversionListModelData>[];
      json['data'].forEach((v) {
        data!.add(new ConversionListModelData.fromJson(v));
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

// class ConversionListModelData {
//   String? sId;
//   String? chatType;
//   List<ConversionListModelParticipants>? participants;
//   String? activity;
//   String? createdAt;
//   String? updatedAt;
//   String? iV;
//   ConversionListModelReceiver? receiver;
//
//   ConversionListModelData(
//       {this.sId,
//         this.chatType,
//         this.participants,
//         this.activity,
//         this.createdAt,
//         this.updatedAt,
//         this.iV,
//         this.receiver});
//
//   ConversionListModelData.fromJson(Map<String, dynamic> json) {
//     sId = json['_id']?.toString();
//     chatType = json['chat_type']?.toString();
//     if (json['participants'] != null) {
//       participants = <ConversionListModelParticipants>[];
//       json['participants'].forEach((v) {
//         participants!.add(new ConversionListModelParticipants.fromJson(v));
//       });
//     }
//     activity = json['activity']?.toString();
//     createdAt = json['createdAt']?.toString();
//     updatedAt = json['updatedAt']?.toString();
//     iV = json['__v']?.toString();
//     receiver = json['receiver'] != null
//         ? new ConversionListModelReceiver.fromJson(json['receiver'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['chat_type'] = this.chatType;
//     if (this.participants != null) {
//       data['participants'] = this.participants!.map((v) => v.toJson()).toList();
//     }
//     data['activity'] = this.activity;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     if (this.receiver != null) {
//       data['receiver'] = this.receiver!.toJson();
//     }
//     return data;
//   }
// }

class ConversionListModelData {
  LastMessage? lastMessage;
  String? sId;
  String? chatType;
  List<ConversionListModelParticipants>? participants;
  String? groupName;
  String? groupImage;
  String? description;
  String? createdBy;
  String? activity;
  String? createdAt;
  String? updatedAt;
  String? iV;
  ConversionListModelReceiver? receiver;
  String? unreadMsgCount;

  ConversionListModelData(
      {this.lastMessage,
        this.sId,
        this.chatType,
        this.participants,
        this.groupName,
        this.groupImage,
        this.description,
        this.createdBy,
        this.activity,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.receiver,
        this.unreadMsgCount});

  ConversionListModelData.fromJson(Map<String, dynamic> json) {
    lastMessage = json['lastMessage'] != null
        ? new LastMessage.fromJson(json['lastMessage'])
        : null;
    sId = json['_id'];
    chatType = json['chat_type'];
    if (json['participants'] != null) {
      participants = <ConversionListModelParticipants>[];
      json['participants'].forEach((v) {
        participants!.add(new ConversionListModelParticipants.fromJson(v));
      });
    }
    groupName = json['groupName']?.toString();
    groupImage = json['groupImage']?.toString();
    description = json['description']?.toString();
    createdBy = json['createdBy']?.toString();
    activity = json['activity']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    iV = json['__v']?.toString();
    receiver = json['receiver'] != null
        ? new ConversionListModelReceiver.fromJson(json['receiver'])
        : null;
    unreadMsgCount = json['unreadMsgCount']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lastMessage != null) {
      data['lastMessage'] = this.lastMessage!.toJson();
    }
    data['_id'] = this.sId;
    data['chat_type'] = this.chatType;
    if (this.participants != null) {
      data['participants'] = this.participants!.map((v) => v.toJson()).toList();
    }
    data['activity'] = this.activity;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.receiver != null) {
      data['receiver'] = this.receiver!.toJson();
    }
    data['unreadMsgCount'] = this.unreadMsgCount;
    return data;
  }
}

class LastMessage {
  String? messageId;
  String? text;
  String? createdAt;

  LastMessage({this.messageId, this.text, this.createdAt});

  LastMessage.fromJson(Map<String, dynamic> json) {
    messageId = json['messageId']?.toString();
    text = json['text']?.toString();
    createdAt = json['createdAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageId'] = this.messageId;
    data['text'] = this.text;
    data['createdAt'] = this.createdAt;
    return data;
  }
}






class ConversionListModelParticipants {
  String? userId;
  String? name;
  bool? isMuted;
  bool? isDeleted;
  String? sId;
  String? joinedAt;

  ConversionListModelParticipants(
      {this.userId, this.isMuted, this.isDeleted, this.sId, this.joinedAt,this.name});

  ConversionListModelParticipants.fromJson(Map<String, dynamic> json) {
    userId = json['user_id']?.toString();
    name = json['name']?.toString();
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

class ConversionListModelReceiver {
  String? profile;
  String? email;
  String? fullName;
  String? id;
  String? userName;

  ConversionListModelReceiver(
      {this.profile, this.email, this.fullName, this.id, this.userName});

  ConversionListModelReceiver.fromJson(Map<String, dynamic> json) {
    profile = json['profile']?.toString();
    email = json['email']?.toString();
    fullName = json['fullName']?.toString();
    id = json['id']?.toString();
    userName = json['userName']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile'] = this.profile;
    data['email'] = this.email;
    data['fullName'] = this.fullName;
    data['id'] = this.id;
    data['userName'] = this.userName;
    return data;
  }
}
