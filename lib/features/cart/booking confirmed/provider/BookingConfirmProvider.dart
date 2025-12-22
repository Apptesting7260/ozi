import 'package:flutter/material.dart';

class BookingConfirmProvider extends ChangeNotifier {
  String bookingId = "BK-2024-001";

  String serviceName = "Shirt Sleeve Shortening & Fitting Service";
  String providerName = "John Doe";

  String bookingDate = "December 10, 2024";
  String bookingTime = "10:00 AM";

  String address =
      "123 Main Street, Apt 4B, San Francisco, CA 94102";

  double total = 173.26;

  List<String> otp = ["1", "1", "1", "1"];
}
