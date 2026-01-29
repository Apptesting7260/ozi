import 'package:flutter/material.dart';
import 'package:ozi/app/core/constants/app_urls.dart';
import 'package:ozi/app/data/repository/repository.dart';
import '../model/bookingmodel.dart';
import '../model/bookingdetailsmodel.dart' as details;

class BookingProvider extends ChangeNotifier {
  Repository _repository = Repository();
  int tabIndex = 0;

  // State variables for bookings data from API
  bookingModel? _bookingsData;
  List<Data> _allBookings = []; // Accumulated bookings across pages
  bool _isLoading = false;
  bool _isLoadingMore = false; // For pagination loading
  String? _errorMessage;

  // Booking details state
  details.bookingDetailsModel? _bookingDetails;
  bool _isDetailsLoading = false;
  String? _detailsErrorMessage;

  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalBookings = 0;
  int _limit = 20;
  bool _hasMoreData = true;
  String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) return "";
    if (path.startsWith("http")) return path;
    return "${AppUrls.imageBaseUrl}$path";
  }

  // Getters for accessing bookings data
  bookingModel? get bookingsData => _bookingsData;
  List<Data> get allBookings => _allBookings;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;

  // Details getters
  details.bookingDetailsModel? get bookingDetails => _bookingDetails;
  bool get isDetailsLoading => _isDetailsLoading;
  String? get detailsErrorMessage => _detailsErrorMessage;

  // Pagination getters
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalBookings => _totalBookings;
  bool get hasMoreData => _hasMoreData;

  // Get list of booking data
  List<Data>? get apiBookingsList =>
      _allBookings.isNotEmpty ? _allBookings : _bookingsData?.data;

  void changeTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  int _requestId = 0;

  String _currentStatus = "All";

  setCurrentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  /// Reset pagination and fetch fresh bookings
  Future<void> refreshBookings(String status) async {
    _currentStatus = status;
    _currentPage = 1;
    _allBookings.clear();
    _hasMoreData = true;
    await getAllBookings(status);
  }

  Future<void> getAllBookings(String status) async {
    final int requestId = ++_requestId;

    if (_currentPage == 1) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }

    _errorMessage = null;
    if (_currentPage == 1) notifyListeners();

    try {
      final response = await _repository.getAllBookings(
        status,
        _limit,
        _currentPage,
      );

      if (requestId != _requestId) return;

      if (response.status == true) {
        _bookingsData = response;

        if (response.pagination != null) {
          _currentPage = response.pagination!.currentPage ?? _currentPage;
          _totalPages = response.pagination!.totalPages ?? 1;
          _totalBookings = response.pagination!.total ?? 0;
          _hasMoreData = _currentPage < _totalPages;
        } else {
          _hasMoreData = response.data?.isNotEmpty == true;
        }

        if (response.data != null && response.data!.isNotEmpty) {
          _allBookings.addAll(response.data!);
        }
      } else {
        _errorMessage = 'API returned status false';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  /// Get specific booking details by ID
  Future<void> getBookingDetails(int bookingId) async {
    _isDetailsLoading = true;
    _detailsErrorMessage = null;
    _bookingDetails = null; // Clear previous details
    notifyListeners();

    try {
      final response = await _repository.getBookingDetailsApi(bookingId);
      if (response.status == true) {
        _bookingDetails = response;
      } else {
        _detailsErrorMessage = 'Failed to load booking details';
      }
    } catch (e) {
      _detailsErrorMessage = e.toString();
    } finally {
      _isDetailsLoading = false;
      notifyListeners();
    }
  }

  /// Load next page of bookings
  Future<void> loadMoreBookings(String status) async {
    if (_isLoadingMore || !_hasMoreData) {
      print(
        'Cannot load more - Loading: $_isLoadingMore, HasMore: $_hasMoreData',
      );
      return;
    }

    int nextPage = _currentPage + 1;
    print('Loading more bookings - Next page: $nextPage');
    await getAllBookings(status);
  }
}
