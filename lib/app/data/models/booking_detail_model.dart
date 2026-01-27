class BookingDetailModel {
  bool? status;
  BookingDetailModelData? data;

  BookingDetailModel({this.status, this.data});

  BookingDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new BookingDetailModelData.fromJson(json['data']) : null;
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

class BookingDetailModelData {
  String? id;
  String? bookingCode;
  String? userId;
  String? vendorId;
  String? addressId;
  String? paymentMethod;
  String? serviceDate;
  String? serviceDay;
  ServiceTime? serviceTime;
  String? subtotal;
  String? serviceFee;
  String? total;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<Items>? items;
  User? user;

  BookingDetailModelData(
      {this.id,
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
        this.createdAt,
        this.updatedAt,
        this.items,
        this.user});

  BookingDetailModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    bookingCode = json['booking_code']?.toString();
    userId = json['user_id']?.toString();
    vendorId = json['vendor_id']?.toString();
    addressId = json['address_id']?.toString();
    paymentMethod = json['payment_method']?.toString();
    serviceDate = json['service_date']?.toString();
    serviceDay = json['service_day']?.toString();
    serviceTime = json['service_time'] != null
        ? new ServiceTime.fromJson(json['service_time'])
        : null;
    subtotal = json['subtotal']?.toString();
    serviceFee = json['service_fee']?.toString();
    total = json['total']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
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

class Items {
  String? id;
  String? bookingId;
  String? serviceId;
  String? serviceName;
  String? unitPrice;
  String? quantity;
  String? serviceItemTotal;
  String? createdAt;
  String? updatedAt;
  String? image;

  Items(
      {this.id,
        this.bookingId,
        this.serviceId,
        this.serviceName,
        this.unitPrice,
        this.quantity,
        this.serviceItemTotal,
        this.createdAt,
        this.image,
        this.updatedAt,});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    bookingId = json['booking_id']?.toString();
    serviceId = json['service_id']?.toString();
    serviceName = json['service_name']?.toString();
    unitPrice = json['unit_price']?.toString();
    quantity = json['quantity']?.toString();
    serviceItemTotal = json['service_item_total']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    image = json['service_image']?.toString();
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
    return data;
  }
}

class User {
  String? id;
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

  User(
      {this.id,
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
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    email = json['email']?.toString();
    proImg = json['pro_img']?.toString();
    countryCode = json['country_code']?.toString();
    mobile = json['mobile']?.toString();
    userRole = json['user_role']?.toString();
    isMobileVerified = json['is_mobile_verified'];
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
