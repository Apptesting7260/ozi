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
            data!.add(Data.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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
  dynamic averageRating;
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
    this.averageRating,
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
    averageRating =
        num.tryParse(json['average_rating']?.toString() ?? '')?.toDouble() ??
        json['average_rating'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    subcategory = json['subcategory'] != null
        ? Category.fromJson(json['subcategory'])
        : null;
    vendor = json['vendor'] != null
        ? Vendor.fromJson(json['vendor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['service_name'] = serviceName;
    data['service_image'] = serviceImage;
    data['category_id'] = categoryId;
    data['subcategory_id'] = subcategoryId;
    data['description'] = description;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['service_price'] = servicePrice;
    data['duration_value'] = durationValue;
    data['duration_type'] = durationType;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (subcategory != null) {
      data['subcategory'] = subcategory!.toJson();
    }
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['parent_name'] = parentName;
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
      receivedReviewsAvgRating =
          num.tryParse(
            json['received_reviews_avg_rating']?.toString() ?? '',
          )?.toDouble() ??
          json['received_reviews_avg_rating'];
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
        receivedReviewsAvgRating =
            num.tryParse(
              first['received_reviews_avg_rating']?.toString() ?? '',
            )?.toDouble() ??
            first['received_reviews_avg_rating'];
        received_reviews_count =
            num.tryParse(
              first['received_reviews_count']?.toString() ?? '',
            )?.toInt() ??
            first['received_reviews_count'];
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['pro_img'] = proImg;
    return data;
  }
}
