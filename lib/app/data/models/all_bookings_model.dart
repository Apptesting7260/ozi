class AllBookingsModel {
  bool? status;
  List<AllBookingsModelData>? data;
  Pagination? pagination;

  AllBookingsModel({this.status, this.data, this.pagination});

  AllBookingsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <AllBookingsModelData>[];
      json['data'].forEach((v) {
        data!.add(AllBookingsModelData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class AllBookingsModelData {
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
  String? serviceStartOtp;
  String? vendorActionAt;
  String? createdAt;
  String? updatedAt;
  User? user;
  Address? address;

  AllBookingsModelData(
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
        this.serviceStartOtp,
        this.vendorActionAt,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.address});

  AllBookingsModelData.fromJson(Map<String, dynamic> json) {
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
    serviceStartOtp = json['service_start_otp']?.toString();
    vendorActionAt = json['vendor_action_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    address =
    json['address'] != null ? Address.fromJson(json['address']) : null;
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
    data['service_start_otp'] = serviceStartOtp;
    data['vendor_action_at'] = vendorActionAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

// class ServiceTime {
//   String? from;
//   String? to;
//
//   ServiceTime({this.from, this.to});
//
//   ServiceTime.fromJson(Map<String, dynamic> json) {
//     from = json['from']?.toString();
//     to = json['to']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['from'] = this.from;
//     data['to'] = this.to;
//     return data;
//   }
// }

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
  String? status;
  String? stepCompleted;
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
        this.status,
        this.stepCompleted,
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
    status = json['status']?.toString();
    stepCompleted = json['step_completed']?.toString();
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
    data['status'] = status;
    data['step_completed'] = stepCompleted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Address {
  String? id;
  String? userId;
  String? addressType;
  String? isDefault;
  String? streetAddress;
  String? apartment;
  String? city;
  String? zipCode;
  String? createdAt;
  String? updatedAt;
  String? fullAddress;

  Address(
      {this.id,
        this.userId,
        this.addressType,
        this.isDefault,
        this.streetAddress,
        this.apartment,
        this.city,
        this.zipCode,
        this.createdAt,
        this.updatedAt,
        this.fullAddress});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    userId = json['user_id']?.toString();
    addressType = json['address_type']?.toString();
    isDefault = json['is_default']?.toString();
    streetAddress = json['street_address']?.toString();
    apartment = json['apartment']?.toString();
    city = json['city']?.toString();
    zipCode = json['zip_code']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    fullAddress = json['full_address']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['address_type'] = addressType;
    data['is_default'] = isDefault;
    data['street_address'] = streetAddress;
    data['apartment'] = apartment;
    data['city'] = city;
    data['zip_code'] = zipCode;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['full_address'] = fullAddress;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    data['total'] = total;
    data['limit'] = limit;
    return data;
  }
}
