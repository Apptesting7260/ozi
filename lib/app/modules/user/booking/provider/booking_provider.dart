import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/core/constants/app_urls.dart';
import 'package:ozi/app/data/repository/repository.dart';
import 'package:ozi/app/modules/user/cart/schedule_service/Model/bookservicemodel.dart';
import 'package:ozi/app/modules/user/navigation%20tab/provider/navigation_provider.dart';
import '../../../../data/models/chat_models/check_conversion_model.dart';
import '../../../../data/network/web_socket_connection_service.dart';
import '../../../../data/storage/user_preference.dart';
import '../../../../routes/app_routes.dart';
import '../../navigation tab/view/navigation_tab_screen.dart';
import '../model/bookingmodel.dart';
import '../model/bookingdetailsmodel.dart' as details;
import 'dart:developer' as dev;

class BookingProvider extends ChangeNotifier {
  final Repository _repository = Repository();
  int tabIndex = 0;

  bookingModel? _bookingsData;
  final List<Data> _allBookings = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;

  details.bookingDetailsModel? _bookingDetails;
  bool _isDetailsLoading = false;
  String? _detailsErrorMessage;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalBookings = 0;
  final int _limit = 20;
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


  setCurrentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  Future<void> refreshBookings(String status) async {
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
      Get.showToast(
        e.toString(),
        type: ToastType.error,
      );
    }

    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> getBookingDetails(int bookingId) async {
    _isDetailsLoading = true;
    _detailsErrorMessage = null;
    _bookingDetails = null;
    notifyListeners();

    try {
      final response = await _repository.getBookingDetailsApi(bookingId);
      if (response.status == true) {
        _bookingDetails = response;
      } else {
        _detailsErrorMessage = 'Failed to load booking details';
      }
    } catch (e) {
      Get.showToast(
        e.toString(),
        type: ToastType.error,
      );
      _detailsErrorMessage = e.toString();
    } finally {
      _isDetailsLoading = false;
      notifyListeners();
    }
  }

  String extractServiceImage(Data booking) {
    if (booking.firstService?.service?.serviceImage?.isNotEmpty == true) {
      return booking.firstService!.service!.serviceImage!;
    }

    if (booking.services != null && booking.services!.isNotEmpty) {}
    return "";
  }

  Future<void> loadMoreBookings(String status) async {
    if (_isLoadingMore || !_hasMoreData) {
      if (kDebugMode) {
        print(
        'Cannot load more - Loading: $_isLoadingMore, HasMore: $_hasMoreData',
      );
      }
      return;
    }

    int nextPage = _currentPage + 1;
    if (kDebugMode) {
      print('Loading more bookings - Next page: $nextPage');
    }
    await getAllBookings(status);
  }

  bool _isCancelling = false;
  int? _cancellingBookingId;
  bool get isCancelling => _isCancelling;
  int? get cancellingBookingId => _cancellingBookingId;

  void setCancelling(bool value, {int? id}) {
    _isCancelling = value;
    _cancellingBookingId = id;
    notifyListeners();
  }

  Future<bool> cancelBooking(int bookingId, BuildContext context) async {
    try {
      // Start API call
      setCancelling(true, id: bookingId);
      final response = await _repository.cancelBookingApi(bookingId);

      if (response != null &&
          response['status'].toString().toLowerCase() == 'true') {
        // Update local state for instant UI update
        if (_bookingDetails?.data?.id == bookingId) {
          _bookingDetails?.data?.status = 'Cancelled';
        }

        // Update in list if present
        final index = _allBookings.indexWhere((b) => b.bookingId == bookingId);
        if (index != -1) {
          _allBookings[index].status = 'Cancelled';
        }

        // Success: show message
        Get.showToast(
          "${response['message'] ?? "Booking cancelled successfully"}",
          type: ToastType.success,
        );
        Navigator.pop(context);
        setCancelling(false);
        await refreshBookings('');
        return true;
      } else {
        // API returned failure
        setCancelling(false);
        Get.showToast("${response['message']}", type: ToastType.error);
        return false;
      }
    } catch (e) {
      setCancelling(false);
      // Catch network or other errors
      if (kDebugMode) {
        print('cancelBooking Error: $e');
      }
      Get.showToast("Something went wrong", type: ToastType.error);
      return false;
    }
  }

  // ======================== RESCHEDULE LOGIC ========================

  DateTime _selectedRescheduleDate = DateTime.now();
  String? _selectedRescheduleTime;
  final Map<String, List<DaySlot>> _dayAvailability = {};
  bool _isAvailabilityLoading = false;

  DateTime get selectedRescheduleDate => _selectedRescheduleDate;
  String? get selectedRescheduleTime => _selectedRescheduleTime;
  bool get isAvailabilityLoading => _isAvailabilityLoading;

  List<Map<String, String>> get quickDates {
    List<Map<String, String>> dates = [];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    for (int i = 0; i < 4; i++) {
      DateTime date = DateTime.now().add(Duration(days: i));
      dates.add({
        'day': days[date.weekday - 1],
        'date': date.day.toString(),
        'month': months[date.month - 1],
      });
    }
    return dates;
  }

  List<String> get availableTimesForSelectedDay {
    final dayName = _getDayName(_selectedRescheduleDate);
    final slots = _dayAvailability[dayName];

    if (slots == null || slots.isEmpty) return [];

    List<String> times = [];
    for (var slot in slots) {
      if (slot.from != null && slot.to != null) {
        DateTime startTime = _parseTime(slot.from!);
        DateTime endTime = _parseTime(slot.to!);

        // Generate hourly slots
        DateTime current = startTime;
        while (!current.isAfter(endTime)) {
          times.add(_formatTime(current));
          current = current.add(const Duration(hours: 1));
        }
      }
    }
    return times;
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    return DateTime(0, 0, 0, int.parse(parts[0]), int.parse(parts[1]));
  }

  String _formatTime(DateTime time) {
    int displayHour = time.hour % 12;
    if (displayHour == 0) displayHour = 12;
    final minuteStr = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$displayHour:$minuteStr $period';
  }

  String _getDayName(DateTime date) {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return days[date.weekday - 1].toLowerCase();
  }

  void selectRescheduleDate(DateTime date) {
    _selectedRescheduleDate = DateTime(date.year, date.month, date.day);
    _selectedRescheduleTime = null;
    notifyListeners();
  }

  void selectRescheduleTime(String time) {
    _selectedRescheduleTime = time;
    notifyListeners();
  }

  Future<void> fetchAvailability(String bookingId) async {
    try {
      _isAvailabilityLoading = true;
      notifyListeners();

      final response = await _repository.fetchRescheduleAvailabilityApi(
        bookingId,
      );

      if (response.vendorAvailability?.days != null) {
        final rawDays = response.vendorAvailability!.days!;
        _dayAvailability.clear();
        rawDays.forEach((key, value) {
          _dayAvailability[key.toLowerCase()] = value;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching availability: $e');
      }
    } finally {
      _isAvailabilityLoading = false;
      notifyListeners();
    }
  }

  bool _isScheduleAgain = false;
  int? _scheduleAgainBookingId;
  bool get isScheduleAgain => _isScheduleAgain;
  int? get scheduleAgainBookingId => _scheduleAgainBookingId;

  void setScheduleAgain(bool value, {int? id}) {
    _isScheduleAgain = value;
    _scheduleAgainBookingId = id;
    notifyListeners();
  }

  Future<bool> rescheduleBooking(int bookingId, BuildContext context) async {
    try {
      setScheduleAgain(true); // Reusing isCancelling for progress state
      notifyListeners();

      if (_selectedRescheduleTime == null) {
        throw Exception("Time not selected");
      }

      final dayName = _getDayName(_selectedRescheduleDate);
      final slots = _dayAvailability[dayName] ?? [];

      DaySlot? selectedSlot;
      for (var slot in slots) {
        if (slot.from != null && slot.to != null) {
          DateTime startTime = _parseTime(slot.from!);
          DateTime endTime = _parseTime(slot.to!);

          DateTime current = startTime;
          while (!current.isAfter(endTime)) {
            if (_formatTime(current) == _selectedRescheduleTime) {
              // Create a 1-hour slot for the selection
              String fromStr =
                  "${current.hour.toString().padLeft(2, '0')}:${current.minute.toString().padLeft(2, '0')}";
              DateTime nextHour = current.add(const Duration(hours: 1));
              String toStr =
                  "${nextHour.hour.toString().padLeft(2, '0')}:${nextHour.minute.toString().padLeft(2, '0')}";
              selectedSlot = DaySlot(from: fromStr, to: toStr);
              break;
            }
            current = current.add(const Duration(hours: 1));
          }
        }
        if (selectedSlot != null) break;
      }

      if (selectedSlot == null) {
        throw Exception("Selected slot not found");
      }

      final Map<String, dynamic> data = {
        "booking_id": bookingId,
        "service_date": _selectedRescheduleDate
            .toIso8601String()
            .split('T')
            .first,
        "service_day": dayName,
        "service_time": selectedSlot.from,
      };

      final response = await _repository.rescheduleBookingApi(data);

      if (response != null && response['status'] == true) {
        Get.showToast(
          'Booking Rescheduled Successfully',
          type: ToastType.success,
        );

        // Refresh details
        await getBookingDetails(bookingId);

        Navigator.pop(context);
        selectedSlot.from = null;
        selectedSlot.to = null;
        _selectedRescheduleDate = DateTime.now();
        _selectedRescheduleTime = null;

        setScheduleAgain(false);
        return true;
      } else {
        Get.showToast(
          response?['message'] ?? 'Reschedule failed',
          type: ToastType.error,
        );
        return false;
      }
    } catch (e) {
      Get.showToast('Reschedule Failed', type: ToastType.error);
      return false;
    } finally {
      setCancelling(false);
      notifyListeners();
    }
  }

  bool _isReviewLoading = false;
  bool get isReviewLoading => _isReviewLoading;

  Future<bool> submitReview(
    String vendorId,
    String rating,
    String review,
  ) async {
    _isReviewLoading = true;
    notifyListeners();
    try {
      var body = {"vendor_id": vendorId, "review": review, "rating": rating};

      final response = await _repository.submitReviewApi(body);
      if (response != null && response['status'] == true) {
        Get.showToast(
          response['message'] ?? 'Review submitted successfully',
          type: ToastType.success,
        );
        return true;
      } else {
        Get.showToast(
          response?['message'] ?? 'Failed to submit review',
          type: ToastType.error,
        );
        return false;
      }
    } catch (e) {
      Get.showToast('Something went wrong', type: ToastType.error);
      return false;
    } finally {
      _isReviewLoading = false;
      notifyListeners();
    }
  }

  bool _isBookAgainLoading = false;
  int? _bookAgainBookingId;
  bool get isBookAgainLoading => _isBookAgainLoading;
  int? get bookAgainBookingId => _bookAgainBookingId;

  Future<bool> bookAgain(int bookingId , BuildContext context) async {
    _isBookAgainLoading = true;
    _bookAgainBookingId = bookingId;
    notifyListeners();
    try {
      final response = await _repository.bookAgainApi(bookingId);
      if (response != null && response['status'] == true) {
        navigatorKey.currentContext!.read<NavigationProvider>().setIndex(
          1,
          navigatorKey.currentContext!,
        );
        Get.showToast(
          response['message'] ?? 'Items added to cart successfully',
          type: ToastType.success,
        );
        return true;
      } else {
        Get.showToast(
          response?['message'] ?? 'Failed to add items to cart',
          type: ToastType.error,
        );
        _showErrorDialog(context, response?['message']);
        return false;
      }
    } catch (e) {
      dev.log('BookAgain Error: $e');
      // Get.showToast(
      //   e.toString(),
      //   type: ToastType.error,
      // );
      _showErrorDialog(context, e.toString(),);

      return false;
    } finally {
      _isBookAgainLoading = false;
      _bookAgainBookingId = null;
      notifyListeners();
    }
  }

  bool _sendLoading = false;
  bool get sendLoading => _sendLoading;
  updateSendLoading(bool value) {
    _sendLoading = value;
    notifyListeners();
  }

  Future<String?> getUserId() async {
    String myUserId = await UserPreference.returnUserId() ?? '';
    return myUserId;
  }

  Future<void> sendMessage(String receiverId) async {
    if (sendLoading) return;
    updateSendLoading(true);
    SocketController socket = navigatorKey.currentContext!.read();
    String? userId = await getUserId();
    socket.sendMessage(AppUrls.checkConversationEvent, {
      "senderId": userId ?? '',
      "receiverId": receiverId,
    });

    socket.listenToEvent(AppUrls.checkConversationEvent, (p0) {
      socket.off(AppUrls.checkConversationEvent);
      if (p0 is String) {
        final data = jsonDecode(p0);
        // use data['key']
        if (kDebugMode) {
          print("data string is $data");
        }
      } else if (p0 is Map) {
        final data = p0 as Map<String, dynamic>;
        CheckConverstionModel conversion = CheckConverstionModel.fromJson(data);
        if (conversion.status == true && conversion.data?.sId != null) {
          Navigator.pushNamed(
            navigatorKey.currentContext!,
            AppRoutes.messageDetailsScreen,
            arguments: {"conversion_id": conversion.data?.sId},
          );
        }

        if (kDebugMode) {
          print("data Map is $data");
        }
      }
      updateSendLoading(false);
    });
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red),
              wBox(10),
              Text(
                "Error",
                style: AppFontStyle.text_18_600(
                  AppColors.black,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
            ],
          ),
          content: Text(
            maxLines: 4,
            message.replaceAll('Exception: ', ''),
            style: AppFontStyle.text_14_400(AppColors.darkText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: AppFontStyle.text_14_600(
                  AppColors.grey,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
            ),
            CustomButton(
              width: 100,
              height: 35,
              text: "View Cart",
              color: AppColors.primary,
              textStyle: AppFontStyle.text_12_600(
                Colors.white,
                fontFamily: AppFontFamily.semiBold,
              ),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NavigationTabScreen(initialIndex: 1),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

}
