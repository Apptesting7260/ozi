class BookingconfirmerdModel {
  bool? status;
  String? message;
  Data? data;

  BookingconfirmerdModel({this.status, this.message, this.data});

  BookingconfirmerdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? bookingId;
  bool? paymentRequired;
  String? clientSecret;
  String? bookingCode;
  String? status;
  String? serviceDate;
  String? serviceDay;
  String? serviceTime;
  String? paymentMethod;
  String? subtotal;
  String? serviceFee;
  String? discountAmount;
  String? total;
  int? serviceStartOtp;
  Vendor? vendor;
  List<Services>? services;
  Address? address;

  Data({
    this.bookingId,
    this.paymentRequired,
    this.clientSecret,
    this.bookingCode,
    this.status,
    this.serviceDate,
    this.serviceDay,
    this.serviceTime,
    this.paymentMethod,
    this.subtotal,
    this.serviceFee,
    this.discountAmount,
    this.total,
    this.serviceStartOtp,
    this.vendor,
    this.services,
    this.address,
  });

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    paymentRequired = json['payment_required'];
    clientSecret = json['client_secret'];
    bookingCode = json['booking_code'];
    status = json['status'];
    serviceDate = json['service_date'];
    serviceDay = json['service_day'];
    serviceTime = json['service_time'];
    paymentMethod = json['payment_method'];
    subtotal = json['subtotal'];
    serviceFee = json['service_fee'];
    discountAmount = json['discount_amount']?.toString();
    total = json['total'];
    serviceStartOtp = json['service_start_otp'];
    vendor = json['vendor'] != null
        ? Vendor.fromJson(json['vendor'])
        : null;
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    address = json['address'] != null
        ? Address.fromJson(json['address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['payment_required'] = paymentRequired;
    data['client_secret'] = clientSecret;
    data['booking_code'] = bookingCode;
    data['status'] = status;
    data['service_date'] = serviceDate;
    data['service_day'] = serviceDay;
    data['service_time'] = serviceTime;
    data['payment_method'] = paymentMethod;
    data['subtotal'] = subtotal;
    data['service_fee'] = serviceFee;
    data['discount_amount'] = discountAmount;
    data['total'] = total;
    data['service_start_otp'] = serviceStartOtp;
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class Vendor {
  int? id;
  String? name;

  Vendor({this.id, this.name});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
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
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    unitPrice = json['unit_price'];
    quantity = json['quantity'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['unit_price'] = unitPrice;
    data['quantity'] = quantity;
    data['total'] = total;
    return data;
  }
}

class Address {
  String? addressType;
  String? streetAddress;
  String? apartment;
  String? city;
  String? zipCode;

  Address({
    this.addressType,
    this.streetAddress,
    this.apartment,
    this.city,
    this.zipCode,
  });

  Address.fromJson(Map<String, dynamic> json) {
    addressType = json['address_type'];
    streetAddress = json['street_address'];
    apartment = json['apartment'];
    city = json['city'];
    zipCode = json['zip_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address_type'] = addressType;
    data['street_address'] = streetAddress;
    data['apartment'] = apartment;
    data['city'] = city;
    data['zip_code'] = zipCode;
    return data;
  }
}
