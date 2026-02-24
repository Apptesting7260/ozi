class VendorAvailability {
  bool? status;
  String? vendorId;
  Map<String,dynamic>? vendorAvailability;

  VendorAvailability({this.status, this.vendorId, this.vendorAvailability});

  VendorAvailability.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    vendorId = json['vendor_id']?.toString();
    vendorAvailability = json['vendor_availability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['vendor_id'] = vendorId;
    if (vendorAvailability != null) {
      data['vendor_availability'] = vendorAvailability;
    }
    return data;
  }
}


