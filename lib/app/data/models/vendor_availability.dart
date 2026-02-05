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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['vendor_id'] = this.vendorId;
    if (this.vendorAvailability != null) {
      data['vendor_availability'] = this.vendorAvailability;
    }
    return data;
  }
}


