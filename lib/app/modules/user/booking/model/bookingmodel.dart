class bookingModel {
  bool? status;
  List<Data>? data;
  Pagination? pagination;

  bookingModel({this.status, this.data, this.pagination});

  bookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Data {
  int? bookingId;
  String? bookingCode;
  String? serviceDate;
  String? serviceDay;
  ServiceTime? serviceTime;
  String? serviceStartOtp;
  Address? address;
  Vendor? vendor;
  FirstService? firstService;
  List<Services>? services;
  String? subtotal;
  String? serviceFee;
  String? total;
  String? status;
  String? createdAt;

  Data({
    this.bookingId,
    this.bookingCode,
    this.serviceDate,
    this.serviceDay,
    this.serviceTime,
    this.serviceStartOtp,
    this.address,
    this.vendor,
    this.firstService,
    this.services,
    this.subtotal,
    this.serviceFee,
    this.total,
    this.status,
    this.createdAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'] is int
        ? json['booking_id']
        : int.tryParse(json['booking_id'].toString());
    bookingCode = json['booking_code']?.toString();
    serviceDate = json['service_date']?.toString();
    serviceDay = json['service_day']?.toString();
    if (json['service_time'] is String) {
      serviceTime = ServiceTime(from: json['service_time'], to: "");
    } else if (json['service_time'] != null) {
      serviceTime = ServiceTime.fromJson(json['service_time']);
    } else {
      serviceTime = null;
    }
    serviceStartOtp = json['service_start_otp']?.toString();
    address = json['address'] != null
        ? new Address.fromJson(json['address'])
        : null;
    vendor = json['vendor'] != null
        ? new Vendor.fromJson(json['vendor'])
        : null;
    firstService = json['first_service'] != null
        ? new FirstService.fromJson(json['first_service'])
        : null;
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    subtotal = json['subtotal']?.toString();
    serviceFee = json['service_fee']?.toString();
    total = json['total']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['booking_code'] = this.bookingCode;
    data['service_date'] = this.serviceDate;
    data['service_day'] = this.serviceDay;
    if (this.serviceTime != null) {
      data['service_time'] = this.serviceTime!.toJson();
    }
    data['service_start_otp'] = this.serviceStartOtp;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
    if (this.firstService != null) {
      data['first_service'] = this.firstService!.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    data['subtotal'] = this.subtotal;
    data['service_fee'] = this.serviceFee;
    data['total'] = this.total;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class ServiceTime {
  String? from;
  String? to;

  ServiceTime({this.from, this.to});

  ServiceTime.fromJson(Map<String, dynamic> json) {
    from = json['from']?.toString();
    to = json['to']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}

class Address {
  String? streetAddress;
  String? apartment;
  String? city;
  String? zipCode;

  Address({this.streetAddress, this.apartment, this.city, this.zipCode});

  Address.fromJson(Map<String, dynamic> json) {
    streetAddress = json['street_address']?.toString();
    apartment = json['apartment']?.toString();
    city = json['city']?.toString();
    zipCode = json['zip_code']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street_address'] = this.streetAddress;
    data['apartment'] = this.apartment;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    return data;
  }
}

class Vendor {
  int? id;
  String? name;
  bool? isdeleted;

  Vendor({this.id, this.name, this.isdeleted});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    name = json['name']?.toString();
    isdeleted = json['is_deleted'] is bool
        ? json['is_deleted']
        : json['is_deleted']?.toString().toLowerCase() == 'false';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class FirstService {
  int? id;
  int? bookingId;
  int? serviceId;
  String? serviceName;
  String? unitPrice;
  int? quantity;
  String? serviceItemTotal;
  String? createdAt;
  String? updatedAt;
  Service? service;

  FirstService({
    this.id,
    this.bookingId,
    this.serviceId,
    this.serviceName,
    this.unitPrice,
    this.quantity,
    this.serviceItemTotal,
    this.createdAt,
    this.updatedAt,
    this.service,
  });

  FirstService.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    bookingId = json['booking_id'] is int
        ? json['booking_id']
        : int.tryParse(json['booking_id'].toString());
    serviceId = json['service_id'] is int
        ? json['service_id']
        : int.tryParse(json['service_id'].toString());
    serviceName = json['service_name']?.toString();
    unitPrice = json['unit_price']?.toString();
    quantity = json['quantity'] is int
        ? json['quantity']
        : int.tryParse(json['quantity'].toString());
    serviceItemTotal = json['service_item_total']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    service = json['service'] != null
        ? new Service.fromJson(json['service'])
        : null;

    // Fallback: If service is null but service_image is directly in FirstService
    if (service == null && json['service_image'] != null) {
      service = Service(serviceImage: json['service_image']?.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['unit_price'] = this.unitPrice;
    data['quantity'] = this.quantity;
    data['service_item_total'] = this.serviceItemTotal;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    return data;
  }
}

class Service {
  int? id;
  int? vendorId;
  String? serviceName;
  String? serviceImage;
  int? categoryId;
  int? subcategoryId;
  String? description;
  String? latitude;
  String? longitude;
  int? servicePrice;
  int? durationValue;
  bool? serviceDeleted;
  String? durationType;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Service({
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
    this.serviceDeleted,
    this.durationType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    vendorId = json['vendor_id'] is int
        ? json['vendor_id']
        : int.tryParse(json['vendor_id'].toString());
    serviceName = json['service_name']?.toString();
    serviceImage = json['service_image']?.toString();
    categoryId = json['category_id'] is int
        ? json['category_id']
        : int.tryParse(json['category_id'].toString());
    subcategoryId = json['subcategory_id'] is int
        ? json['subcategory_id']
        : int.tryParse(json['subcategory_id'].toString());
    description = json['description']?.toString();
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
    servicePrice = json['service_price'] is int
        ? json['service_price']
        : int.tryParse(json['service_price'].toString());
    durationValue = json['duration_value'] is int
        ? json['duration_value']
        : int.tryParse(json['duration_value'].toString());
    serviceDeleted = json['is_service_deleted'] is bool
        ? json['is_service_deleted']
        : json['is_service_deleted']?.toString().toLowerCase() == 'false';
    durationType = json['duration_type']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
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
    return data;
  }
}

class Services {
  int? serviceId;
  String? serviceName;
  String? unitPrice;
  int? quantity;
  String? total;

  Services({
    this.serviceId,
    this.serviceName,
    this.unitPrice,
    this.quantity,
    this.total,
  });

  Services.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'] is int
        ? json['service_id']
        : int.tryParse(json['service_id'].toString());
    serviceName = json['service_name']?.toString();
    unitPrice = json['unit_price']?.toString();
    quantity = json['quantity'] is int
        ? json['quantity']
        : int.tryParse(json['quantity'].toString());
    total = json['total']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['unit_price'] = this.unitPrice;
    data['quantity'] = this.quantity;
    data['total'] = this.total;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? total;
  int? limit;

  Pagination({this.currentPage, this.totalPages, this.total, this.limit});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    total = json['total'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['total_pages'] = this.totalPages;
    data['total'] = this.total;
    data['limit'] = this.limit;
    return data;
  }
}
