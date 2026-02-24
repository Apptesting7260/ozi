class SavedLatlongModel {
  bool? status;
  SavedLatlongModelData? data;

  SavedLatlongModel({this.status, this.data});

  SavedLatlongModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? SavedLatlongModelData.fromJson(json['data']) : null;
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

class SavedLatlongModelData {
  int? id;
  int? vendorId;
  String? longitude;
  String? latitude;

  SavedLatlongModelData({this.id, this.vendorId, this.longitude, this.latitude});

  SavedLatlongModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}