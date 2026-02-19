class ServiceDetailsModel {
  bool? status;
  String? message;
  List<ServiceData>? data;
  Pagination? pagination;

  ServiceDetailsModel({this.status, this.message, this.data, this.pagination});

  ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ServiceData>[];
      json['data'].forEach((v) {
        data!.add(new ServiceData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class ServiceData {
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
  dynamic reviewsCount;
  dynamic ratings;
  Category? category;
  Category? subcategory;
  Vendor? vendor;

  ServiceData({
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
    this.reviewsCount,
    this.ratings,
    this.category,
    this.subcategory,
    this.vendor,
  });

  ServiceData.fromJson(Map<String, dynamic> json) {
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
    reviewsCount =
        num.tryParse(json['reviews_count']?.toString() ?? '')?.toInt() ??
        json['reviews_count'];
    ratings =
        num.tryParse(json['average_rating']?.toString() ?? '')?.toDouble() ??
        json['ratings'];
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
    data['quantity'] = quantity;
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
  Null parentName;

  Category({this.id, this.categoryName, this.parentName});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    parentName = json['parent_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  String? profileImage;
  Vendor({this.id, this.firstName, this.lastName, this.profileImage});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImage = json['pro_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['pro_img'] = profileImage;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;
  bool? hasMore;

  Pagination({
    this.currentPage,
    this.perPage,
    this.total,
    this.lastPage,
    this.hasMore,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    perPage = json['per_page'];
    total = json['total'];
    lastPage = json['last_page'];
    hasMore = json['has_more'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = currentPage;
    data['per_page'] = perPage;
    data['total'] = total;
    data['last_page'] = lastPage;
    data['has_more'] = hasMore;
    return data;
  }
}
