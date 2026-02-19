class bookingDetailsModel {
  bool? status;
  Data? data;

  bookingDetailsModel({this.status, this.data});

  bookingDetailsModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? bookingCode;
  int? userId;
  int? vendorId;
  int? addressId;
  String? paymentMethod;
  String? serviceDate;
  String? serviceDay;
  ServiceTime? serviceTime;
  String? subtotal;
  String? serviceFee;
  String? discountAmount;
  String? total;
  String? status;
  String? serviceStartOtp;
  bool? isOtpVerified;
  String? vendorActionAt;
  String? createdAt;
  String? updatedAt;
  List<Items>? items;
  Vendor? vendor;
  Address? address;

  Data({
    this.id,
    this.bookingCode,
    this.userId,
    this.vendorId,
    this.addressId,
    this.paymentMethod,
    this.serviceDate,
    this.serviceDay,
    this.serviceTime,
    this.subtotal,
    this.serviceFee,
    this.total,
    this.status,
    this.discountAmount,
    this.serviceStartOtp,
    this.isOtpVerified,
    this.vendorActionAt,
    this.createdAt,
    this.updatedAt,
    this.items,
    this.vendor,
    this.address,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    bookingCode = json['booking_code']?.toString();
    userId = json['user_id'] is int
        ? json['user_id']
        : int.tryParse(json['user_id'].toString());
    vendorId = json['vendor_id'] is int
        ? json['vendor_id']
        : int.tryParse(json['vendor_id'].toString());
    addressId = json['address_id'] is int
        ? json['address_id']
        : int.tryParse(json['address_id'].toString());
    paymentMethod = json['payment_method']?.toString();
    serviceDate = json['service_date']?.toString();
    serviceDay = json['service_day']?.toString();
    if (json['service_time'] is String) {
      serviceTime = ServiceTime(from: json['service_time'], to: "");
    } else if (json['service_time'] != null) {
      serviceTime = ServiceTime.fromJson(json['service_time']);
    } else {
      serviceTime = null;
    }
    subtotal = json['subtotal']?.toString();
    serviceFee = json['service_fee']?.toString();
    total = json['total']?.toString();
    status = json['status']?.toString();
    discountAmount = json['discount_amount']?.toString();
    serviceStartOtp = json['service_start_otp']?.toString();
    isOtpVerified = json['is_otp_verified'] is bool
        ? json['is_otp_verified']
        : json['is_otp_verified'].toString().toLowerCase() == 'true';
    vendorActionAt = json['vendor_action_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    } else if (json['services'] != null) {
      items = <Items>[];
      json['services'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    vendor = json['vendor'] != null
        ? new Vendor.fromJson(json['vendor'])
        : null;
    address = json['address'] != null
        ? new Address.fromJson(json['address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_code'] = this.bookingCode;
    data['user_id'] = this.userId;
    data['vendor_id'] = this.vendorId;
    data['address_id'] = this.addressId;
    data['payment_method'] = this.paymentMethod;
    data['service_date'] = this.serviceDate;
    data['service_day'] = this.serviceDay;
    if (this.serviceTime != null) {
      data['service_time'] = this.serviceTime!.toJson();
    }
    data['subtotal'] = this.subtotal;
    data['service_fee'] = this.serviceFee;
    data['total'] = this.total;
    data['status'] = this.status;
    data['service_start_otp'] = this.serviceStartOtp;
    data['is_otp_verified'] = this.isOtpVerified;
    data['vendor_action_at'] = this.vendorActionAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}

class Items {
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

  Items({
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

  Items.fromJson(Map<String, dynamic> json) {
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
    serviceItemTotal = (json['service_item_total'] ?? json['total'])
        ?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
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
  String? latitude;
  String? longitude;
  int? servicePrice;
  int? durationValue;
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

class Vendor {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? proImg;
  String? countryCode;
  String? mobile;
  String? userRole;
  bool? isMobileVerified;
  String? otpExpireAt;
  String? terms;
  String? status;
  String? stepCompleted;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Vendor({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.proImg,
    this.countryCode,
    this.mobile,
    this.userRole,
    this.isMobileVerified,
    this.otpExpireAt,
    this.terms,
    this.status,
    this.stepCompleted,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    email = json['email']?.toString();
    proImg = json['pro_img']?.toString();
    countryCode = json['country_code']?.toString();
    mobile = json['mobile']?.toString();
    userRole = json['user_role']?.toString();
    isMobileVerified = json['is_mobile_verified'] is bool
        ? json['is_mobile_verified']
        : json['is_mobile_verified'].toString().toLowerCase() == 'true';
    otpExpireAt = json['otp_expire_at']?.toString();
    terms = json['terms']?.toString();
    status = json['status']?.toString();
    stepCompleted = json['step_completed']?.toString();
    deletedAt = json['deleted_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['pro_img'] = this.proImg;
    data['country_code'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['user_role'] = this.userRole;
    data['is_mobile_verified'] = this.isMobileVerified;
    data['otp_expire_at'] = this.otpExpireAt;
    data['terms'] = this.terms;
    data['status'] = this.status;
    data['step_completed'] = this.stepCompleted;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Address {
  int? id;
  int? userId;
  String? addressType;
  int? isDefault;
  String? streetAddress;
  String? apartment;
  String? city;
  String? zipCode;
  String? createdAt;
  String? updatedAt;
  String? fullAddress;

  Address({
    this.id,
    this.userId,
    this.addressType,
    this.isDefault,
    this.streetAddress,
    this.apartment,
    this.city,
    this.zipCode,
    this.createdAt,
    this.updatedAt,
    this.fullAddress,
  });

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    userId = json['user_id'] is int
        ? json['user_id']
        : int.tryParse(json['user_id'].toString());
    addressType = json['address_type']?.toString();
    isDefault = json['is_default'] is int
        ? json['is_default']
        : int.tryParse(json['is_default'].toString());
    streetAddress = json['street_address']?.toString();
    apartment = json['apartment']?.toString();
    city = json['city']?.toString();
    zipCode = json['zip_code']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    fullAddress =
        json['full_address']?.toString() ??
        [
          if (streetAddress?.isNotEmpty == true) streetAddress,
          if (apartment?.isNotEmpty == true) apartment,
          if (city?.isNotEmpty == true) city,
          if (zipCode?.isNotEmpty == true) zipCode,
        ].join(", ");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['address_type'] = this.addressType;
    data['is_default'] = this.isDefault;
    data['street_address'] = this.streetAddress;
    data['apartment'] = this.apartment;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['full_address'] = this.fullAddress;
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
