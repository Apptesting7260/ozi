import 'package:flutter/material.dart';

class ServiceDetailsProvider extends ChangeNotifier {
  /// ---------------- STATIC SERVICE DATA ----------------
  String serviceName = "Shirt Sleeve Shortening & Fitting Service";
  String description =
      "High-pressure full body massage to target pain points, knots & muscle soreness\n\n"
      "Treats deeper muscle layers, heals sports injuries & improves flexibility";

  String imageUrl =
      "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9";

  double price = 84.13;
  String duration = "2 Hours";
  bool isActive = true;

  int todayBookings = 2;
  int totalBookings = 142;

  bool isLoading = false;

  /// Getter for backward compatibility
  String get serviceImage => imageUrl;

  /// ---------------- ACTIONS (STATIC - NO API) ----------------

  void deleteService() {
    debugPrint("✅ Service deleted successfully (Static Data)");
  }

  void editService() {
    debugPrint("📝 Navigate to edit service screen");
  }

  void toggleStatus() {
    isActive = !isActive;
    notifyListeners();
    debugPrint("Status toggled: ${isActive ? 'Active' : 'Inactive'}");
  }
}