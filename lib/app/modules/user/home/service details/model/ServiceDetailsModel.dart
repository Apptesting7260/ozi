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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
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
  Null? latitude;
  Null? longitude;
  int? servicePrice;
  int? durationValue;
  String? durationType;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  Category? category;
  Category? subcategory;
  Vendor? vendor;

  ServiceData(
      {this.id,
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
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.category,
        this.subcategory,
        this.vendor});

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
    servicePrice = json['service_price'];
    durationValue = json['duration_value'];
    durationType = json['duration_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subcategory = json['subcategory'] != null
        ? new Category.fromJson(json['subcategory'])
        : null;
    vendor =
    json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
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
  Null? parentName;

  Category({this.id, this.categoryName, this.parentName});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    parentName = json['parent_name'];
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

  Vendor({this.id, this.firstName, this.lastName});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;
  bool? hasMore;

  Pagination(
      {this.currentPage,
        this.perPage,
        this.total,
        this.lastPage,
        this.hasMore});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    perPage = json['per_page'];
    total = json['total'];
    lastPage = json['last_page'];
    hasMore = json['has_more'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    data['last_page'] = this.lastPage;
    data['has_more'] = this.hasMore;
    return data;
  }
}
