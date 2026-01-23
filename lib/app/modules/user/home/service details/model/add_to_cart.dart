class AddToCartModel {
  bool? status;
  String? message;
  CartData? data;

  AddToCartModel({this.status, this.message, this.data});

  AddToCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CartData.fromJson(json['data']) : null;
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

class CartData {
  int? id;
  int? userId;
  int? serviceId;
  String? serviceName;
  int? quantity;
  String? createdAt;
  String? updatedAt;

  CartData(
      {this.id,
        this.userId,
        this.serviceId,
        this.serviceName,
        this.quantity,
        this.createdAt,
        this.updatedAt});

  CartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['quantity'] = quantity;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
