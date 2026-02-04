class LiveSreamRequestModel {
  bool? status;
  String? message;
  LiveSreamRequestModelData? data;

  LiveSreamRequestModel({this.status, this.message, this.data});

  LiveSreamRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new LiveSreamRequestModelData.fromJson(json['data']) : null;
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

class LiveSreamRequestModelData {
  String? notificationType;
  String? uuid;
  String? streamingType;
  String? hostId;
  String? token;
  String? hostName;
  String? hostImage;
  String? channelName;
  String? appId;
  String? liveSessionId;

  LiveSreamRequestModelData(
      {this.notificationType,
        this.uuid,
        this.streamingType,
        this.hostId,
        this.token,
        this.hostName,
        this.hostImage,
        this.channelName,
        this.appId,
        this.liveSessionId});

  LiveSreamRequestModelData.fromJson(Map<String, dynamic> json) {
    notificationType = json['NotificationType']?.toString();
    uuid = json['uuid']?.toString();
    streamingType = json['streaming_type']?.toString();
    hostId = json['hostId']?.toString();
    token = json['token']?.toString();
    hostName = json['hostName']?.toString();
    hostImage = json['hostImage']?.toString();
    channelName = json['channelName']?.toString();
    appId = json['appId']?.toString();
    liveSessionId = json['liveSessionId']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NotificationType'] = this.notificationType;
    data['uuid'] = this.uuid;
    data['streaming_type'] = this.streamingType;
    data['hostId'] = this.hostId;
    data['token'] = this.token;
    data['hostName'] = this.hostName;
    data['hostImage'] = this.hostImage;
    data['channelName'] = this.channelName;
    data['appId'] = this.appId;
    data['liveSessionId'] = this.liveSessionId;
    return data;
  }
}
