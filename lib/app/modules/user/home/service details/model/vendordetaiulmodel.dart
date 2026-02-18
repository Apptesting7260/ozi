class vendorDetailModel {
  bool? status;
  String? message;
  List<Data>? data;

  vendorDetailModel({this.status, this.message, this.data});

  vendorDetailModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      status = json['status'];
      message = json['message'];
      if (json['data'] != null) {
        data = <Data>[];
        if (json['data'] is List) {
          json['data'].forEach((v) {
            data!.add(new Data.fromJson(v));
          });
        }
      }
    } else if (json is List) {
      status = true;
      message = "Success";
      data = json.map((v) => Data.fromJson(v)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? vendorId;
  String? serviceName;
  String? serviceImage;
  int? categoryId;
  int? subcategoryId;
  String? description;
  dynamic latitude;
  dynamic longitude;
  dynamic servicePrice;
  dynamic durationValue;
  String? durationType;
  String? status;
  dynamic quantity;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  Category? category;
  Category? subcategory;
  Vendor? vendor;

  Data({
    this.id,
    this.vendorId,
    this.serviceName,
    this.serviceImage,
    this.categoryId,
    this.subcategoryId,
    this.description,
    this.latitude,
    this.longitude,
    this.servicePrice,
    this.durationValue,
    this.durationType,
    this.status,
    this.quantity,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.category,
    this.subcategory,
    this.vendor,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    serviceName = json['service_name'];
    serviceImage = json['service_image'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    description = json['description'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    servicePrice =
        num.tryParse(json['service_price']?.toString() ?? '')?.toDouble() ??
        json['service_price'];
    durationValue =
        num.tryParse(json['duration_value']?.toString() ?? '')?.toInt() ??
        json['duration_value'];
    durationType = json['duration_type'];
    status = json['status'];
    quantity =
        num.tryParse(json['quantity']?.toString() ?? '')?.toInt() ??
        json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subcategory = json['subcategory'] != null
        ? new Category.fromJson(json['subcategory'])
        : null;
    vendor = json['vendor'] != null
        ? new Vendor.fromJson(json['vendor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['service_name'] = this.serviceName;
    data['service_image'] = this.serviceImage;
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subcategoryId;
    data['description'] = this.description;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['service_price'] = this.servicePrice;
    data['duration_value'] = this.durationValue;
    data['duration_type'] = this.durationType;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.subcategory != null) {
      data['subcategory'] = this.subcategory!.toJson();
    }
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? categoryName;
  String? parentName;

  Category({this.id, this.categoryName, this.parentName});

  Category.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      id = json['id'];
      categoryName = json['category_name'];
      parentName = json['parent_name'];
    } else if (json is List && json.isNotEmpty) {
      final first = json.first;
      if (first is Map<String, dynamic>) {
        id = first['id'];
        categoryName = first['category_name'];
        parentName = first['parent_name'];
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['parent_name'] = this.parentName;
    return data;
  }
}

class Vendor {
  int? id;
  String? firstName;
  String? lastName;
  String? proImg;
  dynamic receivedReviewsAvgRating;
  dynamic received_reviews_count;
  Vendor({
    this.id,
    this.firstName,
    this.lastName,
    this.proImg,
    this.receivedReviewsAvgRating,
    this.received_reviews_count,
  });

  Vendor.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      id = json['id'];
      firstName = json['first_name'];
      lastName = json['last_name'];
      proImg = json['pro_img'];
      receivedReviewsAvgRating = json['received_reviews_avg_rating'];
      received_reviews_count =
          num.tryParse(
            json['received_reviews_count']?.toString() ?? '',
          )?.toInt() ??
          json['received_reviews_count'];
    } else if (json is List && json.isNotEmpty) {
      final first = json.first;
      if (first is Map<String, dynamic>) {
        id = first['id'];
        firstName = first['first_name'];
        lastName = first['last_name'];
        proImg = first['pro_img'];
        receivedReviewsAvgRating = first['received_reviews_avg_rating'];
        received_reviews_count =
            num.tryParse(
              first['received_reviews_count']?.toString() ?? '',
            )?.toInt() ??
            first['received_reviews_count'];
      }
    }
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
