// ==================== MODELS ====================

import '../../../../core/appExports/app_export.dart';

class BookingModel {
  final String id;
  final String name;
  final String service;
  final String date;
  final String time;
  final String address;
  final double price;
  final String status; // in_progress, confirmed, completed, cancelled
  final String phone;
  final String email;
  final String paymentMethod;
  final double serviceFee;
  final String? imageUrl;

  BookingModel({
    required this.id,
    required this.name,
    required this.service,
    required this.date,
    required this.time,
    required this.address,
    required this.price,
    required this.status,
    required this.phone,
    required this.email,
    required this.paymentMethod,
    this.serviceFee = 5.00,
    this.imageUrl,
  });

  double get total => price + serviceFee;
}

// ==================== PROVIDER: MY BOOKINGS ====================


class VendorMybookingsProvider extends ChangeNotifier {
  int selectedTab = 0;
  bool isLoading = false;

  final List<String> tabs = [
    "All",
    "Ongoing",
    "Upcoming",
    "Completed",
    "Cancelled",
  ];

  // Sample data - Replace with API call
  final List<BookingModel> allBookings = [
    BookingModel(
      id: "BK-2024-001",
      name: "Alex Johnson",
      service: "Deep tissue pain relief massage",
      date: "Today",
      time: "2:00 PM",
      address: "123 Main Street, Apt 4B, San Francisco, CA 94102",
      price: 84.13,
      status: "in_progress",
      phone: "+1234567890",
      email: "alex@example.com",
      paymentMethod: "Visa •••• 4242",
      imageUrl: "https://images.unsplash.com/photo-1544161515-4ab6ce6db874",
    ),
    BookingModel(
      id: "BK-2024-002",
      name: "Sarah Williams",
      service: "Swedish Massage",
      date: "Tomorrow",
      time: "10:00 AM",
      address: "456 Oak Ave, San Francisco, CA 94103",
      price: 89.13,
      status: "confirmed",
      phone: "+1234567891",
      email: "sarah@example.com",
      paymentMethod: "Cash",
      imageUrl: "https://images.unsplash.com/photo-1540555700478-4be289fbecef",
    ),
    BookingModel(
      id: "BK-2024-003",
      name: "Michael Brown",
      service: "Hot Stone Massage",
      date: "Dec 15, 2024",
      time: "3:00 PM",
      address: "789 Pine St, San Francisco, CA 94104",
      price: 120.00,
      status: "completed",
      phone: "+1234567892",
      email: "michael@example.com",
      paymentMethod: "Visa •••• 1234",
      imageUrl: "https://images.unsplash.com/photo-1519824145371-296894a0daa9",
    ),
    BookingModel(
      id: "BK-2024-004",
      name: "Emily Davis",
      service: "Aromatherapy Massage",
      date: "Dec 20, 2024",
      time: "1:00 PM",
      address: "321 Elm St, San Francisco, CA 94105",
      price: 95.00,
      status: "cancelled",
      phone: "+1234567893",
      email: "emily@example.com",
      paymentMethod: "Mastercard •••• 5678",
    ),
    BookingModel(
      id: "BK-2024-005",
      name: "David Wilson",
      service: "Sports Massage",
      date: "Dec 28, 2024",
      time: "4:00 PM",
      address: "654 Maple Dr, San Francisco, CA 94106",
      price: 110.00,
      status: "confirmed",
      phone: "+1234567894",
      email: "david@example.com",
      paymentMethod: "Cash",
      imageUrl: "https://images.unsplash.com/photo-1544161515-4ab6ce6db874",
    ),
  ];

  void changeTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  List<BookingModel> get filteredBookings {
    if (selectedTab == 0) return allBookings;

    final tab = tabs[selectedTab].toLowerCase();

    return allBookings.where((b) {
      if (tab == "ongoing") return b.status == "in_progress";
      if (tab == "upcoming") return b.status == "confirmed";
      if (tab == "completed") return b.status == "completed";
      if (tab == "cancelled") return b.status == "cancelled";
      return false;
    }).toList();
  }

  // Navigate to details
  // void openBookingDetails(BuildContext context, BookingModel booking) {
  //   // Navigator.push(
  //   //   context,
  //   //   MaterialPageRoute(
  //   //     builder: (_) => BookingDetailsScreen(booking: booking),
  //   //   ),
  //   // );
  // }

  // Refresh bookings
  Future<void> refreshBookings() async {
    isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    notifyListeners();
  }
}