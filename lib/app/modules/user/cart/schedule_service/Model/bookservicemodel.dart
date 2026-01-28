class BookServiceModel {
  bool? status;
  int? vendorId;
  VendorAvailability? vendorAvailability;
  DefaultAddress? defaultAddress;

  BookServiceModel({
    this.status,
    this.vendorId,
    this.vendorAvailability,
    this.defaultAddress,
  });
BookServiceModel.fromJson(Map<String, dynamic> json) {
  status = json['status'];
  vendorId = json['vendor_id'];

  vendorAvailability = json['vendor_availability'] != null
      ? VendorAvailability.fromJson(json['vendor_availability'])
      : null;

  defaultAddress = json['default_address'] != null
      ? DefaultAddress.fromJson(json['default_address'])
      : null;
}

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['vendor_id'] = vendorId;
    if (vendorAvailability != null) {
      data['vendor_availability'] = vendorAvailability!.toJson();
    }
   data['default_address'] = defaultAddress?.toJson();
    return data;
  }
}

class VendorAvailability {
  // Map key = day of week, value = list of slots
  Map<String, List<DaySlot>>? days;

  VendorAvailability({this.days});

  VendorAvailability.fromJson(Map<String, dynamic> json) {
    days = {};
    json.forEach((key, value) {
      if (value is List) {
        days![key] = value.map((e) => DaySlot.fromJson(e)).toList();
      }
    });
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    days?.forEach((key, value) {
      data[key] = value.map((e) => e.toJson()).toList();
    });
    return data;
  }
}

class DaySlot {
  String? from;
  String? to;

  DaySlot({this.from, this.to});

  DaySlot.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
      };
}
class DefaultAddress {
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

  DefaultAddress(
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

  DefaultAddress.fromJson(Map<String, dynamic> json) {
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