class LiveSreamRequestModel {
  bool? status;
  String? message;
  LiveSreamRequestModelData? data;

  LiveSreamRequestModel({this.status, this.message, this.data});

  LiveSreamRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? LiveSreamRequestModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NotificationType'] = notificationType;
    data['uuid'] = uuid;
    data['streaming_type'] = streamingType;
    data['hostId'] = hostId;
    data['token'] = token;
    data['hostName'] = hostName;
    data['hostImage'] = hostImage;
    data['channelName'] = channelName;
    data['appId'] = appId;
    data['liveSessionId'] = liveSessionId;
    return data;
  }
}
