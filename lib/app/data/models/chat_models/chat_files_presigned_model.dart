class ChatFilePresignedUrlsModel {
  String? id;
  String? fileType;
  List<String>? uploadUrls;
  List<String>? publicUrls;

  ChatFilePresignedUrlsModel(
      {this.id, this.fileType, this.uploadUrls, this.publicUrls});

  ChatFilePresignedUrlsModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    fileType = json['fileType']?.toString();
    uploadUrls = json['uploadUrls'].cast<String>();
    publicUrls = json['publicUrls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fileType'] = this.fileType;
    data['uploadUrls'] = this.uploadUrls;
    data['publicUrls'] = this.publicUrls;
    return data;
  }
}
