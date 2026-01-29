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
    bookingId = json['booking_id'];
    print("bookingId1");
    bookingCode = json['booking_code'];
    print("bookingId2");
    serviceDate = json['service_date'];
    print("bookingId3");
    serviceDay = json['service_day'];
    print("bookingId4");
    serviceTime = json['service_time'] != null
        ? new ServiceTime.fromJson(json['service_time'])
        : null;
    print("bookingId5");
    serviceStartOtp = json['service_start_otp'];
    print("bookingId6");
    address = json['address'] != null
        ? new Address.fromJson(json['address'])
        : null;
    print("bookingId7");
    vendor = json['vendor'] != null
        ? new Vendor.fromJson(json['vendor'])
        : null;
    print("bookingId8");
    firstService = json['first_service'] != null
        ? new FirstService.fromJson(json['first_service'])
        : null;
    print("bookingId9");
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    print("bookingId10");
    subtotal = json['subtotal'];
    print("bookingId11");
    serviceFee = json['service_fee'];
    print("bookingId12");
    total = json['total'];
    print("bookingId13");
    status = json['status'];
    print("bookingId14");
    createdAt = json['created_at'];
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
    from = json['from'];
    to = json['to'];
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
    print("bookingId15");
    streetAddress = json['street_address'];
    print("bookingId16");
    apartment = json['apartment'];
    print("bookingId17");
    city = json['city'];
    print("bookingId18");
    zipCode = json['zip_code'];
    print("bookingId19");
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

  Vendor({this.id, this.name});

  Vendor.fromJson(Map<String, dynamic> json) {
    print("bookingId20");
    id = json['id'];
    print("bookingId21");
    name = json['name'];
    print("bookingId22");
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
    print("bookingId23");
    id = json['id'];
    print("bookingId24");
    bookingId = json['booking_id'];
    print("bookingId25");
    serviceId = json['service_id'];
    print("bookingId26");
    serviceName = json['service_name'];
    print("bookingId27");
    unitPrice = json['unit_price'];
    print("bookingId28");
    quantity = json['quantity'];
    serviceItemTotal = json['service_item_total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    service = json['service'] != null
        ? new Service.fromJson(json['service'])
        : null;
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
  Null? latitude;
  Null? longitude;
  int? servicePrice;
  int? durationValue;
  String? durationType;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

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
    this.durationType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Service.fromJson(Map<String, dynamic> json) {
    print("bookingId29");
    id = json['id'];
    print("bookingId30");
    vendorId = json['vendor_id'];
    print("bookingId31");
    serviceName = json['service_name'];
    print("bookingId32");
    serviceImage = json['service_image'];
    print("bookingId33");
    categoryId = json['category_id'];
    print("bookingId34");
    subcategoryId = json['subcategory_id'];
    print("bookingId35");
    description = json['description'];
    print("bookingId36");
    latitude = json['latitude'];
    print("bookingId37");
    longitude = json['longitude'];
    print("bookingId38");
    servicePrice = json['service_price'];
    print("bookingId39");
    durationValue = json['duration_value'];
    print("bookingId40");
    durationType = json['duration_type'];
    print("bookingId41");
    status = json['status'];
    print("bookingId42");
    createdAt = json['created_at'];
    print("bookingId43");
    updatedAt = json['updated_at'];
    print("bookingId44");
    deletedAt = json['deleted_at'];
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
    print("bookingId:45");
    serviceId = json['service_id'];
    print("bookingId:46");
    serviceName = json['service_name'];
    print("bookingId:47");
    unitPrice = json['unit_price'];
    print("bookingId:48");
    quantity = json['quantity'];
    print("bookingId:49");
    total = json['total'];
    print("bookingId:50");
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
