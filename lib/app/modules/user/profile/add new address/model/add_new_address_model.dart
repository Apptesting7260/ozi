class AddNewAddressModel {
  bool? status;
  String? message;
  AddNewAddressData? data;

  AddNewAddressModel({this.status, this.message, this.data});

  AddNewAddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? AddNewAddressData.fromJson(json['data']) : null;
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

class AddNewAddressData {
  int? userId;
  String? streetAddress;
  String? apartment;
  String? city;
  String? zipCode;
  String? addressType;
  bool? isDefault;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? fullAddress;

  AddNewAddressData(
      {this.userId,
        this.streetAddress,
        this.apartment,
        this.city,
        this.zipCode,
        this.addressType,
        this.isDefault,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.fullAddress});

  AddNewAddressData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    streetAddress = json['street_address'];
    apartment = json['apartment'];
    city = json['city'];
    zipCode = json['zip_code'];
    addressType = json['address_type'];
    isDefault = json['is_default'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    fullAddress = json['full_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['street_address'] = streetAddress;
    data['apartment'] = apartment;
    data['city'] = city;
    data['zip_code'] = zipCode;
    data['address_type'] = addressType;
    data['is_default'] = isDefault;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['full_address'] = fullAddress;
    return data;
  }
}
