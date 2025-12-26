import 'package:flutter/material.dart';

class VendorHomeProvider extends ChangeNotifier {
  // ================= ONLINE STATUS =================
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  void toggleOnline(bool value) {
    _isOnline = value;
    notifyListeners();
  }

  // ================= DASHBOARD STATS =================
  double todayEarning = 248.50;
  int activeBookings = 8;
  double walletBalance = 3420.00;
  int totalJobs = 124;

  // ================= BOOKINGS LIST =================
  final List<BookingRequest> _newRequests = [
    BookingRequest(
      customerName: "Alex Johnson",
      service: "Deep Cleaning",
      price: 84.13,
      date: "Today",
      time: "2:00 PM",
      address: "123 Main St, San Francisco",
      status: BookingStatus.newRequest,
    ),
  ];

  final List<BookingRequest> _confirmedRequests = [
    BookingRequest(
      customerName: "Alex Johnson",
      service: "Deep Cleaning",
      price: 84.13,
      date: "Tomorrow",
      time: "2:00 PM",
      address: "123 Main St, San Francisco",
      status: BookingStatus.confirmed,
    ),
  ];

  List<BookingRequest> get newRequests => _newRequests;
  List<BookingRequest> get confirmedRequests => _confirmedRequests;

  // ================= ACTIONS =================
  void acceptRequest(int index) {
    final request = _newRequests.removeAt(index);
    _confirmedRequests.add(
      request.copyWith(status: BookingStatus.confirmed),
    );
    notifyListeners();
  }

  void rejectRequest(int index) {
    _newRequests.removeAt(index);
    notifyListeners();
  }
}

// ===================================================
// MODELS
// ===================================================

enum BookingStatus { newRequest, confirmed }

class BookingRequest {
  final String customerName;
  final String service;
  final double price;
  final String date;
  final String time;
  final String address;
  final BookingStatus status;

  BookingRequest({
    required this.customerName,
    required this.service,
    required this.price,
    required this.date,
    required this.time,
    required this.address,
    required this.status,
  });

  BookingRequest copyWith({BookingStatus? status}) {
    return BookingRequest(
      customerName: customerName,
      service: service,
      price: price,
      date: date,
      time: time,
      address: address,
      status: status ?? this.status,
    );
  }
}
