// import 'package:flutter/material.dart';
//
// class ServiceDetailsProvider extends ChangeNotifier {
//   /// ---------------- STATIC SERVICE DATA ----------------
//   String serviceName = "Shirt Sleeve Shortening & Fitting Service";
//   String description =
//       "High-pressure full body massage to target pain points, knots & muscle soreness\n\n"
//       "Treats deeper muscle layers, heals sports injuries & improves flexibility";
//
//   String imageUrl =
//       "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9";
//
//   double price = 84.13;
//   String duration = "2 Hours";
//   bool isActive = true;
//
//   int todayBookings = 2;
//   int totalBookings = 142;
//
//   bool isLoading = false;
//
//   /// Getter for backward compatibility
//   String get serviceImage => imageUrl;
//
//   /// ---------------- ACTIONS (STATIC - NO API) ----------------
//
//   void deleteService() {
//     debugPrint("✅ Service deleted successfully (Static Data)");
//   }
//
//   void editService() {
//     debugPrint("📝 Navigate to edit service screen");
//   }
//
//   void toggleStatus() {
//     isActive = !isActive;
//     notifyListeners();
//     debugPrint("Status toggled: ${isActive ? 'Active' : 'Inactive'}");
//   }
// }


import '../../../../../core/appExports/app_export.dart';
import '../../../../../data/repository/repository.dart';
import '../model/service_detail_model.dart';

class ServiceDetailsProvider with ChangeNotifier {

  final Repository _repo = Repository();

  bool isLoading = false;
  bool hasError = false;
  String error = "";
  bool isActivetoggle = true;

  ServiceCardDetailModel? _model;

  Data? get serviceDetails => _model?.data;

  String get serviceName => serviceDetails?.serviceName ?? "";
  String get description => serviceDetails?.description ?? "";
  double get price =>
      (serviceDetails?.servicePrice ?? 0).toDouble();

  String get duration =>
      "${serviceDetails?.durationValue ?? 0} ${serviceDetails?.durationType ?? ""}";

  bool get isActive =>
      serviceDetails?.status == "active";

  int get totalBookings =>
      serviceDetails?.totalBookingCount?.totalBookingCount ?? 0;

  int get todayBookings =>
      serviceDetails?.todayBookingCount?.todayTotalBookingCount ?? 0;

  Future<void> loadCardService(String serviceId) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _repo.fetchServiceDetail(serviceId: serviceId);

      _model = result;

      isLoading = false;
      notifyListeners();

    } catch (e) {
      isLoading = false;
      hasError = true;
      error = e.toString();
      notifyListeners();
    }
  }

  void toggleStatus() {
    isActivetoggle = !isActive;
     notifyListeners();
    debugPrint("Status toggled: ${isActive ? 'Active' : 'Inactive'}");
   }
}
