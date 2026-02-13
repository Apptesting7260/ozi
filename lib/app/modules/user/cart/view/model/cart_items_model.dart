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
    summary = json['summary'] != null
        ? Summary.fromJson(json['summary'])
        : null;
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
  String? serviceId;
  String? serviceName;
  String? serviceImage;
  int? servicePrice;
  String? activeStatus;
  int? quantity;
  int? serviceItemTotal;
  bool? isservicedeleted;

  CartItem({
    this.cartId,
    this.serviceId,
    this.serviceName,
    this.serviceImage,
    this.servicePrice,
    this.activeStatus,
    this.quantity,
    this.serviceItemTotal,
    this.isservicedeleted,
  });

  CartItem.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    serviceId = json['service_id']?.toString();
    serviceName = json['service_name']?.toString();
    serviceImage = json['service_image']?.toString();
    servicePrice = int.tryParse(json['service_price']?.toString() ?? "0");
    activeStatus = json['status']?.toString();
    quantity = json['quantity'];
    serviceItemTotal = int.tryParse(
      json['service_item_total']?.toString() ?? "0",
    );
    // Handle both boolean and various truthy values from API (like 1 or "true")
    final deletedValue = json['is_service_deleted'];
    if (deletedValue is bool) {
      isservicedeleted = deletedValue;
    } else if (deletedValue is num) {
      isservicedeleted = deletedValue == 1;
    } else if (deletedValue is String) {
      isservicedeleted =
          deletedValue.toLowerCase() == 'true' || deletedValue == '1';
    } else {
      isservicedeleted = false;
    }
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
  int? discount;
  String? appliedCuppon;

  Summary({
    this.itemsCount,
    this.subtotal,
    this.serviceFee,
    this.total,
    this.discount,
    this.appliedCuppon,
  });

  Summary.fromJson(Map<String, dynamic> json) {
    itemsCount = int.tryParse(json['items_count']?.toString() ?? "0");
    subtotal = int.tryParse(json['subtotal']?.toString() ?? "0");
    serviceFee = int.tryParse(json['service_fee']?.toString() ?? "0");
    total = int.tryParse(json['total']?.toString() ?? "0");
    discount = int.tryParse(json['discount']?.toString() ?? "0");
    // Fallback if discount is not directly provided
    if (discount == 0 &&
        subtotal != null &&
        serviceFee != null &&
        total != null) {
      discount = (subtotal! + serviceFee!) - total!;
    }
    appliedCuppon = json['applied_coupon']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['items_count'] = itemsCount;
    data['subtotal'] = subtotal;
    data['service_fee'] = serviceFee;
    data['total'] = total;
    data['discount'] = discount;
    data['applied_coupon'] = appliedCuppon;
    return data;
  }
}
