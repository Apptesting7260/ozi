class getVendorReviewsModel {
  bool? status;
  List<Data>? data;
  Meta? meta;

  getVendorReviewsModel({this.status, this.data, this.meta});

  getVendorReviewsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? vendorId;
  int? userId;
  int? rating;
  String? review;
  String? createdAt;
  String? updatedAt;
  User? user;

  Data({
    this.id,
    this.vendorId,
    this.userId,
    this.rating,
    this.review,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    userId = json['user_id'];
    rating = json['rating'];
    review = json['review'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['user_id'] = this.userId;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? proImg;

  User({this.id, this.firstName, this.lastName, this.proImg});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    proImg = json['pro_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['pro_img'] = this.proImg;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? lastPage;
  int? total;
  int? perPage;

  Meta({this.currentPage, this.lastPage, this.total, this.perPage});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    total = json['total'];
    perPage = json['per_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['total'] = this.total;
    data['per_page'] = this.perPage;
    return data;
  }
}
