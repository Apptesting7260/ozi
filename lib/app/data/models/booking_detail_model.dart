import 'all_bookings_model.dart';

class BookingDetailModel {
  bool? status;
  BookingDetailModelData? data;

  BookingDetailModel({this.status, this.data});

  BookingDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? BookingDetailModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
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
  String? serviceTime;
  String? subtotal;
  String? serviceFee;
  String? total;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<Items>? items;
  Address? address;
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
        this.address,
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
    serviceTime = json['service_time']?.toString();

    subtotal = json['subtotal']?.toString();
    serviceFee = json['service_fee']?.toString();
    total = json['total']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    address = json['address'] != null
        ? Address.fromJson(json['address'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_code'] = bookingCode;
    data['user_id'] = userId;
    data['vendor_id'] = vendorId;
    data['address_id'] = addressId;
    data['payment_method'] = paymentMethod;
    data['service_date'] = serviceDate;
    data['service_day'] = serviceDay;
    // if (this.serviceTime != null) {
    //   data['service_time'] = this.serviceTime!.toJson();
    // }
    data['subtotal'] = subtotal;
    data['service_fee'] = serviceFee;
    data['total'] = total;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      data['user'] = user!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
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
    image = json['service']?['service_image']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['unit_price'] = unitPrice;
    data['quantity'] = quantity;
    data['service_item_total'] = serviceItemTotal;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['pro_img'] = proImg;
    data['country_code'] = countryCode;
    data['mobile'] = mobile;
    data['user_role'] = userRole;
    data['is_mobile_verified'] = isMobileVerified;
    data['otp_expire_at'] = otpExpireAt;
    data['terms'] = terms;
    data['status'] = status;
    data['step_completed'] = stepCompleted;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
