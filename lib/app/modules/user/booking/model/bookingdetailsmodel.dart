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
  String? serviceTime;
  String? subtotal;
  String? serviceFee;
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
    id = json['id'];
    bookingCode = json['booking_code'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    addressId = json['address_id'];
    paymentMethod = json['payment_method'];
    serviceDate = json['service_date'];
    serviceDay = json['service_day'];
    serviceTime = json['service_time'];
    subtotal = json['subtotal'];
    serviceFee = json['service_fee'];
    total = json['total'];
    status = json['status'];
    serviceStartOtp = json['service_start_otp'];
    isOtpVerified = json['is_otp_verified'];
    vendorActionAt = json['vendor_action_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
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
    data['service_time'] = this.serviceTime;
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
    id = json['id'];
    bookingId = json['booking_id'];
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    unitPrice = json['unit_price'];
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
  Null? otpExpireAt;
  Null? terms;
  String? status;
  int? stepCompleted;
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
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    proImg = json['pro_img'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    userRole = json['user_role'];
    isMobileVerified = json['is_mobile_verified'];
    otpExpireAt = json['otp_expire_at'];
    terms = json['terms'];
    status = json['status'];
    stepCompleted = json['step_completed'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    id = json['id'];
    userId = json['user_id'];
    addressType = json['address_type'];
    isDefault = json['is_default'];
    streetAddress = json['street_address'];
    apartment = json['apartment'];
    city = json['city'];
    zipCode = json['zip_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fullAddress = json['full_address'];
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
