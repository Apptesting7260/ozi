// class PageStatusModel {
//   bool? status;
//   String? message;
//   PageStatusModelData? data;
//
//   PageStatusModel({this.status, this.message, this.data});
//
//   PageStatusModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message']?.toString();
//     data = json['data'] != null ? new PageStatusModelData.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class PageStatusModelData {
//   PageStatusModelMember? member;
//
//   PageStatusModelData({this.member});
//
//   PageStatusModelData.fromJson(Map<String, dynamic> json) {
//     member =
//     json['member'] != null ? new PageStatusModelMember.fromJson(json['member']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.member != null) {
//       data['member'] = this.member!.toJson();
//     }
//     return data;
//   }
// }
//
// class PageStatusModelMember {
//   String? coverphoto;
//   String? email;
//   String? fullName;
//   String? id;
//   String? userName;
//
//   PageStatusModelMember({this.coverphoto, this.email, this.fullName, this.id, this.userName});
//
//   PageStatusModelMember.fromJson(Map<String, dynamic> json) {
//     coverphoto = json['coverphoto']?.toString();
//     email = json['email']?.toString();
//     fullName = json['fullName']?.toString();
//     id = json['id']?.toString();
//     userName = json['userName']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['coverphoto'] = this.coverphoto;
//     data['email'] = this.email;
//     data['fullName'] = this.fullName;
//     data['id'] = this.id;
//     data['userName'] = this.userName;
//     return data;
//   }
// }

class PageStatusModel {
  bool? status;
  String? message;
  List<AllParticipants>? allParticipants;
  String? conversationName;
  String? conversationImage;

  PageStatusModel(
      {this.status,
        this.message,
        this.allParticipants,
        this.conversationName,
        this.conversationImage});

  PageStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    if (json['allParticipants'] != null) {
      allParticipants = <AllParticipants>[];
      json['allParticipants'].forEach((v) {
        allParticipants!.add(new AllParticipants.fromJson(v));
      });
    }
    conversationName = json['conversation_name']?.toString();
    conversationImage = json['conversation_image']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.allParticipants != null) {
      data['allParticipants'] =
          this.allParticipants!.map((v) => v.toJson()).toList();
    }
    data['conversation_name'] = this.conversationName;
    data['conversation_image'] = this.conversationImage;
    return data;
  }
}

class AllParticipants {
  String? coverphoto;
  String? email;
  String? fullName;
  String? id;
  String? profile;
  String? userName;

  AllParticipants(
      {this.coverphoto,
        this.email,
        this.fullName,
        this.id,
        this.profile,
        this.userName});

  AllParticipants.fromJson(Map<String, dynamic> json) {
    coverphoto = json['coverphoto']?.toString();
    email = json['email']?.toString();
    fullName = json['fullName']?.toString();
    id = json['id']?.toString();
    profile = json['profile']?.toString();
    userName = json['userName']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coverphoto'] = this.coverphoto;
    data['email'] = this.email;
    data['fullName'] = this.fullName;
    data['id'] = this.id;
    data['profile'] = this.profile;
    data['userName'] = this.userName;
    return data;
  }
}

