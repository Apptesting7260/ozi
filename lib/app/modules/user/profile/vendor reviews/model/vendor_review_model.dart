class VendorReviewModel {
  bool? status;
  Data? data;

  VendorReviewModel({this.status, this.data});

  VendorReviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? averageRating;
  int? reviewsCount;
  List<ReviewDetails>? reviewDetails;

  Data({this.averageRating, this.reviewsCount, this.reviewDetails});

  Data.fromJson(Map<String, dynamic> json) {
    averageRating = json['average_rating'];
    reviewsCount = json['reviews_count'];
    if (json['reviewDetails'] != null) {
      reviewDetails = <ReviewDetails>[];
      json['reviewDetails'].forEach((v) {
        reviewDetails!.add(new ReviewDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average_rating'] = this.averageRating;
    data['reviews_count'] = this.reviewsCount;
    if (this.reviewDetails != null) {
      data['reviewDetails'] =
          this.reviewDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReviewDetails {
  int? id;
  int? vendorId;
  int? userId;
  int? rating;
  String? review;
  String? createdAt;
  String? updatedAt;
  User? user;

  ReviewDetails(
      {this.id,
        this.vendorId,
        this.userId,
        this.rating,
        this.review,
        this.createdAt,
        this.updatedAt,
        this.user});

  ReviewDetails.fromJson(Map<String, dynamic> json) {
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