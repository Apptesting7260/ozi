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
        boosts!.add(new Boosts.fromJson(v));
      });
    }
    sort = json['sort'];
    count = json['count'];
    reel = json['reel'] != null ? new Reel.fromJson(json['reel']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.boosts != null) {
      data['boosts'] = this.boosts!.map((v) => v.toJson()).toList();
    }
    data['sort'] = this.sort;
    data['count'] = this.count;
    if (this.reel != null) {
      data['reel'] = this.reel!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['createdAt'] = this.createdAt;
    data['views'] = this.views;
    data['id'] = this.id;
    data['duration'] = this.duration;
    data['updatedAt'] = this.updatedAt;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['caption'] = this.caption;
    data['fileUrl'] = this.fileUrl;
    data['id'] = this.id;
    data['imageUrl'] = this.imageUrl;
    data['userId'] = this.userId;
    return data;
  }
}
