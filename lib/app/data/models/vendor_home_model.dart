class VendorHomeModel {
  bool? status;
  VendorHomeVendorStatus? vendorStatus;
  VendorHomeDashboard? dashboard;
  List<VendorHomeRequests>? requests;
  VendorHomeProfile? profile;

  VendorHomeModel(
      {this.status, this.vendorStatus, this.dashboard, this.requests,this.profile});

  VendorHomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    vendorStatus = json['vendor_status'] != null
        ? new VendorHomeVendorStatus.fromJson(json['vendor_status'])
        : null;
    dashboard = json['dashboard'] != null
        ? new VendorHomeDashboard.fromJson(json['dashboard'])
        : null;
    if (json['requests'] != null) {
      requests = <VendorHomeRequests>[];
      json['requests'].forEach((v) {
        requests!.add(new VendorHomeRequests.fromJson(v));
      });
      profile = json['vendor_profile'] != null
          ? new VendorHomeProfile.fromJson(json['vendor_profile'])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.vendorStatus != null) {
      data['vendor_status'] = this.vendorStatus!.toJson();
    }
    if (this.dashboard != null) {
      data['dashboard'] = this.dashboard!.toJson();
    }
    if (this.requests != null) {
      data['requests'] = this.requests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VendorHomeVendorStatus {
  bool? isOnline;
  bool? hasLocation;
  bool? hasService;

  VendorHomeVendorStatus({this.isOnline, this.hasLocation, this.hasService});

  VendorHomeVendorStatus.fromJson(Map<String, dynamic> json) {
    isOnline = json['is_online'];
    hasLocation = json['has_location'];
    hasService = json['has_service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_online'] = this.isOnline;
    data['has_location'] = this.hasLocation;
    data['has_service'] = this.hasService;
    return data;
  }
}

class VendorHomeProfile {
  String? name;
  String? image;

  VendorHomeProfile({this.name,this.image});

  VendorHomeProfile.fromJson(Map<String, dynamic> json) {
    image = json['pro_img']?.toString();
    name = json['vendor_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class VendorHomeDashboard {
  String? todayEarnings;
  String? activeBookings;
  String? wallet;
  String? totalJobs;

  VendorHomeDashboard(
      {this.todayEarnings, this.activeBookings, this.wallet, this.totalJobs});

  VendorHomeDashboard.fromJson(Map<String, dynamic> json) {
    todayEarnings = json['today_earnings']?.toString();
    activeBookings = json['active_bookings']?.toString();
    wallet = json['wallet']?.toString();
    totalJobs = json['total_jobs']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['today_earnings'] = this.todayEarnings;
    data['active_bookings'] = this.activeBookings;
    data['wallet'] = this.wallet;
    data['total_jobs'] = this.totalJobs;
    return data;
  }
}

class VendorHomeRequests {
  String? bookingId;
  String? bookingCode;
  String? customerId;
  String? customerName;
  String? customerPhone;
  String? serviceDate;
  VendorHomeServiceTime? serviceTime;
  String? address;
  String? totalAmount;
  String? status;
  String? customerImage;
  bool isLoadingAccept = false;
  bool isLoadingReject = false;

  VendorHomeRequests(
      {this.bookingId,
        this.bookingCode,
        this.customerId,
        this.customerName,
        this.customerPhone,
        this.serviceDate,
        this.serviceTime,
        this.address,
        this.totalAmount,
        this.status,
        this.customerImage});

  VendorHomeRequests.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id']?.toString();
    bookingCode = json['booking_code']?.toString();
    customerId = json['customer_id']?.toString();
    customerName = json['customer_name']?.toString();
    customerPhone = json['customer_phone']?.toString();
    serviceDate = json['service_date']?.toString();
    serviceTime = json['service_time'] != null
        ? new VendorHomeServiceTime.fromJson(json['service_time'])
        : null;
    address = json['address'];
    totalAmount = json['total_amount'];
    status = json['status'];
    customerImage = json['customer_image']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['booking_code'] = this.bookingCode;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['service_date'] = this.serviceDate;
    if (this.serviceTime != null) {
      data['service_time'] = this.serviceTime!.toJson();
    }
    data['address'] = this.address;
    data['total_amount'] = this.totalAmount;
    data['status'] = this.status;
    return data;
  }
}

class VendorHomeServiceTime {
  String? from;
  String? to;

  VendorHomeServiceTime({this.from, this.to});

  VendorHomeServiceTime.fromJson(Map<String, dynamic> json) {
    from = json['from']?.toString();
    to = json['to']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}

class VendorAllRequestsModel {
  bool? status;
  List<VendorHomeRequests>? requests;

  VendorAllRequestsModel(
      {this.status, this.requests});

  VendorAllRequestsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['requests'] != null) {
      requests = <VendorHomeRequests>[];
      json['requests'].forEach((v) {
        requests!.add(new VendorHomeRequests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.requests != null) {
      data['requests'] = this.requests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




// class VendorHomeModel {
//   bool? status;
//   Data? data;
//
//   VendorHomeModel({this.status, this.data});
//
//   VendorHomeModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     data = json['vendor_status'] != null ? new Data.fromJson(json['vendor_status']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.data != null) {
//       data['vendor_status'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   bool? isOnline;
//   bool? hasLocation;
//   bool? hasService;
//
//   Data({this.isOnline, this.hasLocation, this.hasService});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     isOnline = json['is_online'];
//     hasLocation = json['has_location'];
//     hasService = json['has_service'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['is_online'] = this.isOnline;
//     data['has_location'] = this.hasLocation;
//     data['has_service'] = this.hasService;
//     return data;
//   }
// }
