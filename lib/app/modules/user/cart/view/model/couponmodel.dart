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
  int? id;
  String? code;
  String? type;
  String? value;
  String? minCartAmount;
  String? maxDiscount;
  int? usageLimit;
  int? usedCount;
  String? expiryDate;
  int? status;
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
    id = json['id'];
    code = json['code'];
    type = json['type'];
    value = json['value'];
    minCartAmount = json['min_cart_amount'];
    maxDiscount = json['max_discount'];
    usageLimit = json['usage_limit'];
    usedCount = json['used_count'];
    expiryDate = json['expiry_date'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
