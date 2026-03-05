import '../../../../core/appExports/app_export.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../data/models/all_bookings_model.dart';
import '../../../../data/network/network_api_services.dart';
import '../../../../data/response/api_response.dart';

class VendorMybookingsProvider extends ChangeNotifier {
  final NetworkApiServices _apiService = NetworkApiServices();

  VendorMybookingsProvider() {
    fetchInitialBookings();
  }

  Future<void> refreshBookings() async {
    _currentPage = 1;
    _totalPages = 1;

    _homeModel = ApiResponse.loading();
    notifyListeners();

    await _fetchBookings(reset: true);
  }

  // ================= STATE =================

  ApiResponse<AllBookingsModel> _homeModel = ApiResponse.loading();
  ApiResponse<AllBookingsModel> get homeModel => _homeModel;

  int _currentPage = 1;
  int _totalPages = 1;
  bool _isFetching = false;

  int selectedTab = 0;

  final List<Map<String, dynamic>> tabConfig = [
    {
      "label": "All",
      "status": null,
    },
    {
      "label": "Ongoing",
      "status": ["ongoing", "confirmed"],
    },
    {
      "label": "Upcoming",
      "status": ["pending"],
    },
    {
      "label": "Completed",
      "status": ["completed"],
    },
    {
      "label": "Cancelled",
      "status": ["cancelled", "rejected"],
    },
  ];

  // ================= CORE METHODS =================

  Future<void> fetchInitialBookings() async {
    _currentPage = 1;
    _totalPages = 1;
    _homeModel = ApiResponse.loading();
    notifyListeners();

    await _fetchBookings(reset: true);
  }
  //
  // Future<void> refreshBookings() async {
  //   await fetchInitialBookings();
  // }

  Future<void> loadMoreBookings() async {
    if (_isFetching) return;
    if (_currentPage >= _totalPages) return;

    _currentPage++;
    await _fetchBookings(reset: false);
  }

  Future<void> _fetchBookings({required bool reset}) async {
    try {
      _isFetching = true;

      final response = await _apiService.getApi(_buildUrl());
      final parsed = AllBookingsModel.fromJson(response);

      _totalPages = parsed.pagination?.totalPages ?? 1;

      if (reset) {
        _homeModel = ApiResponse.completed(parsed);
      } else {
        _homeModel.data?.data?.addAll(parsed.data ?? []);
        _homeModel.data?.pagination = parsed.pagination;
      }

      notifyListeners();
    } catch (e) {
      _homeModel = ApiResponse.error('Internal Server Error');
      notifyListeners();
      Get.showToast(e.toString(), type: ToastType.error);
    } finally {
      _isFetching = false;
    }
  }

  final Set<String> _loadingActions = {};

  bool isAcceptLoading(String bookingId) {
    return _loadingActions.contains('${bookingId}_accept');
  }

  bool isRejectLoading(String bookingId) {
    return _loadingActions.contains('${bookingId}_reject');
  }

  Future<bool> acceptOrRejectRequest(
      String action,
      String bookingId,
      ) async {
    final key = '${bookingId}_$action';

    if (_loadingActions.contains(key)) return false;

    try {
      _loadingActions.add(key);
      notifyListeners();

      await _apiService.postApi(
        {
          "booking_id": bookingId,
          "action": action,
        },
        AppUrls.acceptRejectBooking,
      );

      // Update status locally
      final bookings = _homeModel.data?.data;

      if (bookings != null) {
        final index =
        bookings.indexWhere((b) => b.id.toString() == bookingId);

        if (index != -1) {
          bookings[index].status =
          action == 'accept' ? 'confirmed' : 'rejected';
        }
      }

      _loadingActions.remove(key);
      notifyListeners();

      return true;
    } catch (e) {
      _loadingActions.remove(key);
      notifyListeners();

      Get.showToast(e.toString(), type: ToastType.error);
      return false;
    }
  }


  String _buildUrl() {
    String url = AppUrls.vendorMyBookings.replaceAll(
      '{page}',
      _currentPage.toString(),
    );

    final List<String>? statuses =
    tabConfig[selectedTab]["status"];

    if (statuses != null && statuses.isNotEmpty) {
      for (var s in statuses) {
        url += '&status=$s';
      }
    }

    return url;
  }

  // ================= TAB HANDLING =================

  void changeTab(int index) {
    if (selectedTab == index) return;

    selectedTab = index;
    fetchInitialBookings();
  }
}