// ==================== PROVIDER: BOOKING DETAILS ====================

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../provider/vendor_mybookings_provider.dart';

class BookingDetailsProvider extends ChangeNotifier {
  final BookingModel booking;

  BookingDetailsProvider(this.booking);

  bool isProcessing = false;

  bool get isOngoing => booking.status == "in_progress";
  bool get isUpcoming => booking.status == "confirmed";
  bool get isCompleted => booking.status == "completed";
  bool get isCancelled => booking.status == "cancelled";

  // Call customer
  Future<void> callCustomer() async {
    try {
      final uri = Uri.parse("tel:${booking.phone}");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint("Error calling customer: $e");
    }
  }

  // Navigate to customer location
  Future<void> navigateToCustomer() async {
    try {
      final encodedAddress = Uri.encodeComponent(booking.address);
      final uri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$encodedAddress",
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error navigating: $e");
    }
  }

  // Complete job
  Future<void> completeJob(BuildContext context) async {
    isProcessing = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    isProcessing = false;
    notifyListeners();

    if (context.mounted) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Job marked as completed!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(context); // Go back to list
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  // Start job (for upcoming bookings)
  Future<void> startJob(BuildContext context) async {
    isProcessing = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    isProcessing = false;
    notifyListeners();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job started!")),
      );
    }
  }

  // Verify OTP (optional feature from screens)
  Future<void> verifyOTP(BuildContext context, String otp) async {
    isProcessing = true;
    notifyListeners();

    // Simulate OTP verification
    await Future.delayed(const Duration(seconds: 1));

    isProcessing = false;
    notifyListeners();

    if (context.mounted) {
      // Navigate or show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Verified!")),
      );
    }
  }
}