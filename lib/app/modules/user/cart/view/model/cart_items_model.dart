class CartItemsModel {
  bool? status;
  String? message;
  CartItemsData? data;

  CartItemsModel({this.status, this.message, this.data});

  CartItemsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CartItemsData.fromJson(json['data']) : null;
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

class CartItemsData {
  List<CartItem>? items;
  Summary? summary;

  CartItemsData({this.items, this.summary});

  CartItemsData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <CartItem>[];
      json['items'].forEach((v) {
        items!.add(CartItem.fromJson(v));
      });
    }
    summary =
    json['summary'] != null ? Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    return data;
  }
}

class CartItem {
  int? cartId;
  int? serviceId;
  String? serviceName;
  String? serviceImage;
  int? servicePrice;
  int? quantity;
  int? serviceItemTotal;

  CartItem(
      {this.cartId,
        this.serviceId,
        this.serviceName,
        this.serviceImage,
        this.servicePrice,
        this.quantity,
        this.serviceItemTotal});

  CartItem.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    serviceImage = json['service_image'];
    servicePrice = json['service_price'];
    quantity = json['quantity'];
    serviceItemTotal = json['service_item_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['service_image'] = serviceImage;
    data['service_price'] = servicePrice;
    data['quantity'] = quantity;
    data['service_item_total'] = serviceItemTotal;
    return data;
  }
}

class Summary {
  int? itemsCount;
  int? subtotal;
  int? serviceFee;
  int? total;

  Summary({this.itemsCount, this.subtotal, this.serviceFee, this.total});

  Summary.fromJson(Map<String, dynamic> json) {
    itemsCount = json['items_count'];
    subtotal = json['subtotal'];
    serviceFee = json['service_fee'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['items_count'] = itemsCount;
    data['subtotal'] = subtotal;
    data['service_fee'] = serviceFee;
    data['total'] = total;
    return data;
  }
}
