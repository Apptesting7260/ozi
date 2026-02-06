class getCupponsModel {
  bool? status;
  List<Data>? data;

  getCupponsModel({this.status, this.data});

  getCupponsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? code;
  String? type;
  String? value;
  String? minCartAmount;
  String? maxDiscount;
  String? usageLimit;
  String? usedCount;
  String? expiryDate;
  String? status;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.code,
    this.type,
    this.value,
    this.minCartAmount,
    this.maxDiscount,
    this.usageLimit,
    this.usedCount,
    this.expiryDate,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    code = json['code']?.toString();
    type = json['type']?.toString();
    value = json['value']?.toString();
    minCartAmount = json['min_cart_amount']?.toString();
    maxDiscount = json['max_discount']?.toString();
    usageLimit = json['usage_limit']?.toString();
    usedCount = json['used_count']?.toString();
    expiryDate = json['expiry_date']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['type'] = this.type;
    data['value'] = this.value;
    data['min_cart_amount'] = this.minCartAmount;
    data['max_discount'] = this.maxDiscount;
    data['usage_limit'] = this.usageLimit;
    data['used_count'] = this.usedCount;
    data['expiry_date'] = this.expiryDate;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
