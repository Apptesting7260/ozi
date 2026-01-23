class UserAddressModel {
  bool? status;
  List<Data>? data;

  UserAddressModel({this.status, this.data});

  UserAddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
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

  Data(
      {this.id,
        this.userId,
        this.addressType,
        this.isDefault,
        this.streetAddress,
        this.apartment,
        this.city,
        this.zipCode,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    return data;
  }
}
