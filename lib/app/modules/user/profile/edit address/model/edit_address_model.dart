class EditAddressModel {
  bool? status;
  String? message;
  EditAddressData? data;

  EditAddressModel({this.status, this.message, this.data});

  EditAddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new EditAddressData.fromJson(json['data']) : null;
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

class EditAddressData {
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

  EditAddressData(
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

  EditAddressData.fromJson(Map<String, dynamic> json) {
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
