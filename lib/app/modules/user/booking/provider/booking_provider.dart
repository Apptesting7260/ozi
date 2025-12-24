import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  int tabIndex = 0;

  void changeTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  List<Map<String, dynamic>> get bookings {
    if (tabIndex == 0) return allBookings;
    if (tabIndex == 1) return ongoingBookings;
    if (tabIndex == 2) return upcomingBookings;
    if (tabIndex == 3) return completedBookings;
    if (tabIndex == 4) return canceledBookings;
    return allBookings;
  }

  // All Bookings (Combined)
  final List<Map<String, dynamic>> allBookings = [
    {
      "title": "Shirt Sleeve Shortening & Fitting",
      "price": "\$84.13",
      "date": "Today",
      "time": "2:00 PM",
      "address": "123 Main St, San Francisco",
      "status": "In Progress",
      "statusColor": "green",
      "img": "assets/demo/user1.png"
    },
    {
      "title": "Pant Hemming & Waist Adjustment",
      "price": "\$65.00",
      "date": "Tomorrow",
      "time": "10:00 AM",
      "address": "456 Oak Ave, San Francisco",
      "status": "Confirmed",
      "statusColor": "blue",
      "img": "assets/demo/user2.png"
    },
    {
      "title": "Dress Alteration & Fitting",
      "price": "\$120.00",
      "date": "Dec 22, 2025",
      "time": "3:00 PM",
      "address": "789 Pine St, San Francisco",
      "status": "Upcoming",
      "statusColor": "orange",
      "img": "assets/demo/user3.png"
    },
    {
      "title": "Suit Tailoring Service",
      "price": "\$250.00",
      "date": "Dec 15, 2025",
      "time": "11:00 AM",
      "address": "321 Market St, San Francisco",
      "status": "Completed",
      "statusColor": "green",
      "img": "assets/demo/user4.png"
    },
    {
      "title": "Jean Repair & Patching",
      "price": "\$45.00",
      "date": "Dec 10, 2025",
      "time": "4:00 PM",
      "address": "654 Castro St, San Francisco",
      "status": "Cancelled",
      "statusColor": "red",
      "img": "assets/demo/user5.png"
    },
  ];

  // Ongoing Bookings
  final List<Map<String, dynamic>> ongoingBookings = [
    {
      "title": "Shirt Sleeve Shortening & Fitting",
      "price": "\$84.13",
      "date": "Today",
      "time": "2:00 PM",
      "address": "123 Main St, San Francisco",
      "status": "In Progress",
      "statusColor": "green",
      "img": "assets/demo/user1.png"
    },
    {
      "title": "Jacket Zipper Replacement",
      "price": "\$55.00",
      "date": "Today",
      "time": "5:00 PM",
      "address": "987 Mission St, San Francisco",
      "status": "In Progress",
      "statusColor": "green",
      "img": "assets/demo/user2.png"
    },
  ];

  // Upcoming Bookings
  final List<Map<String, dynamic>> upcomingBookings = [
    {
      "title": "Pant Hemming & Waist Adjustment",
      "price": "\$65.00",
      "date": "Tomorrow",
      "time": "10:00 AM",
      "address": "456 Oak Ave, San Francisco",
      "status": "Confirmed",
      "statusColor": "blue",
      "img": "assets/demo/user2.png"
    },
    {
      "title": "Dress Alteration & Fitting",
      "price": "\$120.00",
      "date": "Dec 22, 2025",
      "time": "3:00 PM",
      "address": "789 Pine St, San Francisco",
      "status": "Upcoming",
      "statusColor": "orange",
      "img": "assets/demo/user3.png"
    },
    {
      "title": "Coat Lining Replacement",
      "price": "\$95.00",
      "date": "Dec 25, 2025",
      "time": "1:00 PM",
      "address": "111 Valencia St, San Francisco",
      "status": "Upcoming",
      "statusColor": "orange",
      "img": "assets/demo/user1.png"
    },
  ];

  // Completed Bookings
  final List<Map<String, dynamic>> completedBookings = [
    {
      "title": "Suit Tailoring Service",
      "price": "\$250.00",
      "date": "Dec 15, 2025",
      "time": "11:00 AM",
      "address": "321 Market St, San Francisco",
      "status": "Completed",
      "statusColor": "green",
      "img": "assets/demo/user4.png"
    },
    {
      "title": "Blazer Alteration",
      "price": "\$145.00",
      "date": "Dec 12, 2025",
      "time": "2:00 PM",
      "address": "555 Geary St, San Francisco",
      "status": "Completed",
      "statusColor": "green",
      "img": "assets/demo/user5.png"
    },
    {
      "title": "Skirt Hemming",
      "price": "\$35.00",
      "date": "Dec 8, 2025",
      "time": "9:00 AM",
      "address": "222 Polk St, San Francisco",
      "status": "Completed",
      "statusColor": "green",
      "img": "assets/demo/user1.png"
    },
    {
      "title": "Shirt Button Replacement",
      "price": "\$20.00",
      "date": "Dec 5, 2025",
      "time": "12:00 PM",
      "address": "888 Hayes St, San Francisco",
      "status": "Completed",
      "statusColor": "green",
      "img": "assets/demo/user2.png"
    },
    {
      "title": "Wedding Dress Alteration",
      "price": "\$350.00",
      "date": "Dec 1, 2025",
      "time": "10:00 AM",
      "address": "444 Union St, San Francisco",
      "status": "Completed",
      "statusColor": "green",
      "img": "assets/demo/user3.png"
    },
  ];

  // Canceled Bookings
  final List<Map<String, dynamic>> canceledBookings = [
    {
      "title": "Jean Repair & Patching",
      "price": "\$45.00",
      "date": "Dec 10, 2025",
      "time": "4:00 PM",
      "address": "654 Castro St, San Francisco",
      "status": "Cancelled",
      "statusColor": "red",
      "img": "assets/demo/user5.png"
    },
    {
      "title": "Sweater Resize",
      "price": "\$60.00",
      "date": "Dec 7, 2025",
      "time": "3:30 PM",
      "address": "777 Clement St, San Francisco",
      "status": "Cancelled",
      "statusColor": "red",
      "img": "assets/demo/user4.png"
    },
  ];
}