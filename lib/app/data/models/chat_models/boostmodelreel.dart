class boostReelModel {
  bool? status;
  List<Boosts>? boosts;
  String? sort;
  int? count;
  Reel? reel;

  boostReelModel({this.status, this.boosts, this.sort, this.count, this.reel});

  boostReelModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['boosts'] != null) {
      boosts = <Boosts>[];
      json['boosts'].forEach((v) {
        boosts!.add(Boosts.fromJson(v));
      });
    }
    sort = json['sort'];
    count = json['count'];
    reel = json['reel'] != null ? Reel.fromJson(json['reel']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (boosts != null) {
      data['boosts'] = boosts!.map((v) => v.toJson()).toList();
    }
    data['sort'] = sort;
    data['count'] = count;
    if (reel != null) {
      data['reel'] = reel!.toJson();
    }
    return data;
  }
}

class Boosts {
  int? amount;
  String? createdAt;
  int? views;
  String? id;
  String? duration;
  String? updatedAt;

  Boosts({
    this.amount,
    this.createdAt,
    this.views,
    this.id,
    this.duration,
    this.updatedAt,
  });

  Boosts.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    createdAt = json['createdAt'];
    views = json['views'];
    id = json['id'];
    duration = json['duration'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['createdAt'] = createdAt;
    data['views'] = views;
    data['id'] = id;
    data['duration'] = duration;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Reel {
  String? caption;
  String? fileUrl;
  String? id;
  String? imageUrl;
  String? userId;

  Reel({this.caption, this.fileUrl, this.id, this.imageUrl, this.userId});

  Reel.fromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    fileUrl = json['fileUrl'];
    id = json['id'];
    imageUrl = json['imageUrl'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['caption'] = caption;
    data['fileUrl'] = fileUrl;
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['userId'] = userId;
    return data;
  }
}
