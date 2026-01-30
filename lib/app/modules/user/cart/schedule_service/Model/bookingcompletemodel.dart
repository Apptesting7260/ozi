class BookingconfirmerdModel {
  bool? status;
  String? message;
  Data? data;

  BookingconfirmerdModel({this.status, this.message, this.data});

  BookingconfirmerdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? bookingId;
  String? bookingCode;
  String? status;
  String? serviceDate;
  String? serviceDay;
  ServiceTime? serviceTime;
  String? paymentMethod;
  String? subtotal;
  String? serviceFee;
  String? total;
  int? serviceStartOtp;
  Vendor? vendor;
  List<Services>? services;
  Address? address;

  Data({
    this.bookingId,
    this.bookingCode,
    this.status,
    this.serviceDate,
    this.serviceDay,
    this.serviceTime,
    this.paymentMethod,
    this.subtotal,
    this.serviceFee,
    this.total,
    this.serviceStartOtp,
    this.vendor,
    this.services,
    this.address,
  });

  Data.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    bookingCode = json['booking_code'];
    status = json['status'];
    serviceDate = json['service_date'];
    serviceDay = json['service_day'];
    serviceTime = json['service_time'] != null
        ? new ServiceTime.fromJson(json['service_time'])
        : null;
    paymentMethod = json['payment_method'];
    subtotal = json['subtotal'];
    serviceFee = json['service_fee'];
    total = json['total'];
    serviceStartOtp = json['service_start_otp'];
    vendor = json['vendor'] != null
        ? new Vendor.fromJson(json['vendor'])
        : null;
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    address = json['address'] != null
        ? new Address.fromJson(json['address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['booking_code'] = this.bookingCode;
    data['status'] = this.status;
    data['service_date'] = this.serviceDate;
    data['service_day'] = this.serviceDay;
    if (this.serviceTime != null) {
      data['service_time'] = this.serviceTime!.toJson();
    }
    data['payment_method'] = this.paymentMethod;
    data['subtotal'] = this.subtotal;
    data['service_fee'] = this.serviceFee;
    data['total'] = this.total;
    data['service_start_otp'] = this.serviceStartOtp;
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
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

class Vendor {
  int? id;
  String? name;

  Vendor({this.id, this.name});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['unit_price'] = this.unitPrice;
    data['quantity'] = this.quantity;
    data['total'] = this.total;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_type'] = this.addressType;
    data['street_address'] = this.streetAddress;
    data['apartment'] = this.apartment;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    return data;
  }
}
