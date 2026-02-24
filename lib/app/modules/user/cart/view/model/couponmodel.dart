class getCupponsModel {
  bool? status;
  List<Data>? data;

  getCupponsModel({this.status, this.data});

  getCupponsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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
  String? id;
  String? code;
  String? type;
  String? value;
  String? minCartAmount;
  String? minCartAmountMsg;
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
    this.minCartAmountMsg,
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
    minCartAmountMsg = json['min_cart_amount_message']?.toString();
    maxDiscount = json['max_discount']?.toString();
    usageLimit = json['usage_limit']?.toString();
    usedCount = json['used_count']?.toString();
    expiryDate = json['expiry_date']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['type'] = type;
    data['value'] = value;
    data['min_cart_amount'] = minCartAmount;
    data['max_discount'] = maxDiscount;
    data['usage_limit'] = usageLimit;
    data['used_count'] = usedCount;
    data['expiry_date'] = expiryDate;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
