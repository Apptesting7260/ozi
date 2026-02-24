import '../../../../core/appExports/app_export.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../data/models/all_bookings_model.dart';
import '../../../../data/network/network_api_services.dart';
import '../../../../data/response/api_response.dart';

class VendorMybookingsProvider extends ChangeNotifier {
  final NetworkApiServices _apiService = NetworkApiServices();

  VendorMybookingsProvider() {
    getAllBookings();
  }

  ApiResponse<AllBookingsModel> _homeModel = ApiResponse.loading();
  ApiResponse<AllBookingsModel> get homeModel => _homeModel;

  setHomeModel(ApiResponse<AllBookingsModel> value) {
    _homeModel = value;
    notifyListeners();
  }

  Future<void> getAllBookings() async {
    if (_homeModel.data?.pagination != null) {
      if (_homeModel.data!.pagination!.currentPage! >=
          _homeModel.data!.pagination!.totalPages!) {
        return;
      }
      _homeModel.data!.pagination!.currentPage =
          _homeModel.data!.pagination!.currentPage! + 1;
    }
    if (kDebugMode) {
      print('getting categories');
    }
    try {
      String apiUrl = AppUrls.vendorMyBookings.replaceAll(
        '{page}',
        _homeModel.data?.pagination?.currentPage.toString() ?? '1',
      );
      if (selectedTab != 0) {
        apiUrl += '&status=${tabs[selectedTab].toLowerCase()}';
      }
      final response = await _apiService.getApi(apiUrl);
      if (kDebugMode) {
        print(response);
      }
      if (_homeModel.data?.pagination?.currentPage == 1 ||
          _homeModel.data?.pagination?.currentPage == null) {
        setHomeModel(
          ApiResponse.completed(AllBookingsModel.fromJson(response)),
        );
      } else {
        AllBookingsModel data = AllBookingsModel.fromJson(response);
        _homeModel.data?.data?.addAll(data.data ?? []);
        notifyListeners();
      }
      _homeModel.data?.pagination = AllBookingsModel.fromJson(
        response,
      ).pagination;
    } catch (e) {
      Get.showToast(e.toString(), type: ToastType.error);
      setHomeModel(ApiResponse.error('Internal Server Error'));
    }
  }

  int selectedTab = 0;
  bool isLoading = false;

  final List<String> tabs = [
    "All",
    "Ongoing",
    "Upcoming",
    "Completed",
    "Cancelled",
  ];

  void changeTab(int index) {
    selectedTab = index;
    setHomeModel(ApiResponse.loading());
    getAllBookings();
    notifyListeners();
  }

  // List<BookingModel> get filteredBookings {
  //   if (selectedTab == 0) return allBookings;
  //
  //   final tab = tabs[selectedTab].toLowerCase();
  //
  //   return allBookings.where((b) {
  //     if (tab == "ongoing") return b.status == "in_progress";
  //     if (tab == "upcoming") return b.status == "confirmed";
  //     if (tab == "completed") return b.status == "completed";
  //     if (tab == "cancelled") return b.status == "cancelled";
  //     return false;
  //   }).toList();
  // }

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
  // Future<void> refreshBookings() async {
  //   isLoading = true;
  //   notifyListeners();
  //
  //   // Simulate API call
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   isLoading = false;
  //   notifyListeners();
  // }
}
