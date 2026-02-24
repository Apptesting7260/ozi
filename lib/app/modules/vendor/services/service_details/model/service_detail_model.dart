class ServiceCardDetailModel {
  bool? status;
  Data? data;

  ServiceCardDetailModel({this.status, this.data});

  ServiceCardDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? serviceName;
  String? serviceImage;
  String? description;
  int? servicePrice;
  int? durationValue;
  String? durationType;
  String? status;
  TotalBookingCount? totalBookingCount;
  TodayBookingCount? todayBookingCount;

  Data(
      {
        this.id,
        this.serviceName,
        this.serviceImage,
        this.description,
        this.servicePrice,
        this.durationValue,
        this.durationType,
        this.status,
        this.totalBookingCount,
        this.todayBookingCount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    serviceName = json['service_name'];
    serviceImage = json['service_image'];
    description = json['description'];
    servicePrice = json['service_price'];
    durationValue = json['duration_value'];
    durationType = json['duration_type'];
    status = json['status'];
    totalBookingCount = json['total_booking_count'] != null
        ? TotalBookingCount.fromJson(json['total_booking_count'])
        : null;
    todayBookingCount = json['today_booking_count'] != null
        ? TodayBookingCount.fromJson(json['today_booking_count'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_name'] = serviceName;
    data['service_image'] = serviceImage;
    data['description'] = description;
    data['service_price'] = servicePrice;
    data['duration_value'] = durationValue;
    data['duration_type'] = durationType;
    data['status'] = status;
    if (totalBookingCount != null) {
      data['total_booking_count'] = totalBookingCount!.toJson();
    }
    if (todayBookingCount != null) {
      data['today_booking_count'] = todayBookingCount!.toJson();
    }
    return data;
  }
}

class TotalBookingCount {
  int? totalPendingBooking;
  int? totalConfirmedBooking;
  int? totalOngoingBooking;
  int? totalCompletedBooking;
  int? totalCancelledBooking;
  int? totalRejectedBooking;
  int? totalBookingCount;

  TotalBookingCount(
      {this.totalPendingBooking,
        this.totalConfirmedBooking,
        this.totalOngoingBooking,
        this.totalCompletedBooking,
        this.totalCancelledBooking,
        this.totalRejectedBooking,
        this.totalBookingCount});

  TotalBookingCount.fromJson(Map<String, dynamic> json) {
    totalPendingBooking = json['total_pending_booking'];
    totalConfirmedBooking = json['total_confirmed_booking'];
    totalOngoingBooking = json['total_ongoing_booking'];
    totalCompletedBooking = json['total_completed_booking'];
    totalCancelledBooking = json['total_cancelled_booking'];
    totalRejectedBooking = json['total_rejected_booking'];
    totalBookingCount = json['total_booking_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_pending_booking'] = totalPendingBooking;
    data['total_confirmed_booking'] = totalConfirmedBooking;
    data['total_ongoing_booking'] = totalOngoingBooking;
    data['total_completed_booking'] = totalCompletedBooking;
    data['total_cancelled_booking'] = totalCancelledBooking;
    data['total_rejected_booking'] = totalRejectedBooking;
    data['total_booking_count'] = totalBookingCount;
    return data;
  }
}

class TodayBookingCount {
  int? todayPendingBooking;
  int? todayConfirmedBooking;
  int? todayOngoingBooking;
  int? todayCompletedBooking;
  int? todayCancelledBooking;
  int? todayRejectedBooking;
  int? todayTotalBookingCount;

  TodayBookingCount(
      {this.todayPendingBooking,
        this.todayConfirmedBooking,
        this.todayOngoingBooking,
        this.todayCompletedBooking,
        this.todayCancelledBooking,
        this.todayRejectedBooking,
        this.todayTotalBookingCount});

  TodayBookingCount.fromJson(Map<String, dynamic> json) {
    todayPendingBooking = json['today_pending_booking'];
    todayConfirmedBooking = json['today_confirmed_booking'];
    todayOngoingBooking = json['today_ongoing_booking'];
    todayCompletedBooking = json['today_completed_booking'];
    todayCancelledBooking = json['today_cancelled_booking'];
    todayRejectedBooking = json['today_rejected_booking'];
    todayTotalBookingCount = json['today_total_booking_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['today_pending_booking'] = todayPendingBooking;
    data['today_confirmed_booking'] = todayConfirmedBooking;
    data['today_ongoing_booking'] = todayOngoingBooking;
    data['today_completed_booking'] = todayCompletedBooking;
    data['today_cancelled_booking'] = todayCancelledBooking;
    data['today_rejected_booking'] = todayRejectedBooking;
    data['today_total_booking_count'] = todayTotalBookingCount;
    return data;
  }
}