class VendorGetAllServicesModel {
  bool? status;
  String? message;
  List<VendorGetAllServicesModelData>? data;

  VendorGetAllServicesModel({this.status, this.message, this.data});

  VendorGetAllServicesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    if (json['data'] != null) {
      data = <VendorGetAllServicesModelData>[];
      json['data'].forEach((v) {
        data!.add(new VendorGetAllServicesModelData.fromJson(v));
      });
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

class VendorGetAllServicesModelData {
  String? id;
  String? vendorId;
  String? serviceName;
  String? serviceImage;
  String? categoryId;
  String? subcategoryId;
  String? description;
  String? latitude;
  String? longitude;
  String? servicePrice;
  String? durationValue;
  String? durationType;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Category? category;
  Category? subcategory;
  bool isActive = true;

  VendorGetAllServicesModelData({
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
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.category,
    this.subcategory,
  });

  VendorGetAllServicesModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    vendorId = json['vendor_id']?.toString();
    serviceName = json['service_name']?.toString();
    serviceImage = json['service_image']?.toString();
    categoryId = json['category_id']?.toString();
    subcategoryId = json['subcategory_id']?.toString();
    description = json['description']?.toString();
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
    servicePrice = json['service_price']?.toString();
    durationValue = json['duration_value']?.toString();
    durationType = json['duration_type']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subcategory = json['subcategory'] != null
        ? new Category.fromJson(json['subcategory'])
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
    return data;
  }
}

class Category {
  String? id;
  String? categoryName;

  Category({this.id, this.categoryName});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    categoryName = json['category_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    return data;
  }
}
