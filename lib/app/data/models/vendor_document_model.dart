class VendorDocumentModel {
  bool? status;
  VendorDocumentModelData? data;

  VendorDocumentModel({this.status, this.data});

  VendorDocumentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? VendorDocumentModelData.fromJson(json['data']) : null;
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

class VendorDocumentModelData {
  String? governmentIdImage;
  String? certificate;
  String? id;

  VendorDocumentModelData({this.governmentIdImage, this.certificate, this.id});

  VendorDocumentModelData.fromJson(Map<String, dynamic> json) {
    governmentIdImage = json['government_id_image']?.toString();
    certificate = json['certificate']?.toString();
    id = json['id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['government_id_image'] = governmentIdImage;
    data['certificate'] = certificate;
    data['id'] = id;
    return data;
  }
}
