import 'package:flutter/material.dart';

enum BookingStatus { newRequest, confirmed }

class BookingRequest {
  final String name;
  final String service;
  final String date;
  final String time;
  final String address;
  final double price;
  final BookingStatus status;

  BookingRequest({
    required this.name,
    required this.service,
    required this.date,
    required this.time,
    required this.address,
    required this.price,
    required this.status,
  });
}

class NewRequestsProvider extends ChangeNotifier {
  final List<BookingRequest> _requests = [
    BookingRequest(
      name: "Alex Johnson",
      service: "Deep Cleaning",
      date: "Today",
      time: "2:00 PM",
      address: "123 Main St, San Francisco",
      price: 84.13,
      status: BookingStatus.newRequest,
    ),
    BookingRequest(
      name: "Alex Johnson",
      service: "Deep Cleaning",
      date: "Today",
      time: "2:00 PM",
      address: "123 Main St, San Francisco",
      price: 84.13,
      status: BookingStatus.newRequest,
    ),
    BookingRequest(
      name: "Alex Johnson",
      service: "Deep Cleaning",
      date: "Tomorrow",
      time: "2:00 PM",
      address: "123 Main St, San Francisco",
      price: 84.13,
      status: BookingStatus.confirmed,
    ),
  ];

  List<BookingRequest> get requests => _requests;

  void acceptRequest(int index) {
    _requests[index] =
        BookingRequest(
          name: _requests[index].name,
          service: _requests[index].service,
          date: _requests[index].date,
          time: _requests[index].time,
          address: _requests[index].address,
          price: _requests[index].price,
          status: BookingStatus.confirmed,
        );
    notifyListeners();
  }

  void rejectRequest(int index) {
    _requests.removeAt(index);
    notifyListeners();
  }
}
