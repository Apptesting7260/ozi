class AddToCartModel {
  bool? status;
  String? message;
  CartData? data;

  AddToCartModel({this.status, this.message, this.data});

  AddToCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new CartData.fromJson(json['data']) : null;
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
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['quantity'] = this.quantity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
