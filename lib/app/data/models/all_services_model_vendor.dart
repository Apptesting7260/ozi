class VendorGetAllServicesModel {
  bool? status;
  String? message;
  List<VendorGetAllServicesModelData>? data;
  Filters? filters;
  Pagination? pagination;

  VendorGetAllServicesModel({
    this.status,
    this.message,
    this.data,
    this.filters,
    this.pagination,
  });

  VendorGetAllServicesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();

    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((e) => VendorGetAllServicesModelData.fromJson(e))
          .toList();
    }

    filters =
    json['filters'] != null ? Filters.fromJson(json['filters']) : null;

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'filters': filters?.toJson(),
      'pagination': pagination?.toJson(),
    };
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
  ServiceCategory? category;
  ServiceCategory? subcategory;
  Vendor? vendor;


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

    category =
    json['category'] != null ? ServiceCategory.fromJson(json['category']) : null;

    subcategory = json['subcategory'] != null
        ? ServiceCategory.fromJson(json['subcategory'])
        : null;

    vendor =
    json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor_id': vendorId,
      'service_name': serviceName,
      'service_image': serviceImage,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'service_price': servicePrice,
      'duration_value': durationValue,
      'duration_type': durationType,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'category': category?.toJson(),
      'subcategory': subcategory?.toJson(),
      'vendor': vendor?.toJson(),
    };
  }
}

class ServiceCategory {
  String? id;
  String? categoryName;
  String? parentName;

  ServiceCategory({this.id, this.categoryName, this.parentName});

  ServiceCategory.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    categoryName = json['category_name']?.toString();
    parentName = json['parent_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': categoryName,
      'parent_name': parentName,
    };
  }
}

class Vendor {
  String? id;
  String? firstName;
  String? lastName;
  String? proImg;

  Vendor({this.id, this.firstName, this.lastName, this.proImg});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    proImg = json['pro_img']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'pro_img': proImg,
    };
  }
}

class Filters {
  List<ServiceCategory>? categories;

  Filters({this.categories});

  Filters.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = (json['categories'] as List)
          .map((e) => ServiceCategory.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories?.map((e) => e.toJson()).toList(),
    };
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
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
      'has_more': hasMore,
    };
  }
}

