import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/data/repository/repository.dart';
import 'package:ozi/app/modules/user/cart/booking%20confirmed/view/BookingConfirmScreen.dart';
import 'package:ozi/app/modules/user/cart/schedule_service/Model/bookservicemodel.dart';
import 'package:ozi/app/data/response/api_response.dart';
import '../Model/bookingcompletemodel.dart';

class ScheduleProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  String? _selectedTime;
  BookServiceModel? _bookService;
  // Map<String, List<DaySlot>> _dayAvailability = {};
  Map<String, List<DaySlot>> _dayAvailability = {};

  // Get next 4 days for quick selection
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

  // Getters
  DateTime get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;
  BookServiceModel? get bookService => _bookService;
  // Returns the available time slots for the selected day
  List<String> get availableTimesForSelectedDay {
    final dayName = _getDayName(_selectedDate);
    final slots = _dayAvailability[dayName];

    if (slots == null || slots.isEmpty) return [];

    // Convert API DaySlot to displayable time strings (From - To)
    List<String> times = [];
    for (var slot in slots) {
      if (slot.from != null && slot.to != null) {
        times.add(_formatSlotForDisplay(slot));
      }
    }
    return times;
  }

  String _formatSlotForDisplay(DaySlot slot) {
    if (slot.from == null || slot.to == null) return "";

    String formatTime(String timeStr) {
      DateTime time = _parseTime(timeStr);
      int displayHour = time.hour % 12;
      if (displayHour == 0) displayHour = 12;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.hour >= 12 ? 'PM' : 'AM';
      return '$displayHour:$minute $period';
    }

    return "${formatTime(slot.from!)} - ${formatTime(slot.to!)}";
  }

  // --- Helpers ---
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

  DateTime _parseTime(String time) {
    // Assumes HH:mm (24-hour format)
    final parts = time.split(':');
    return DateTime(0, 0, 0, int.parse(parts[0]), int.parse(parts[1]));
  }

  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    _selectedTime = null; // reset selected time
    notifyListeners();
  }

  void selectTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  Future<void> scheduleService() async {
    try {
      _bookService = await _repository.scheduleServiceApi();

      if (_bookService?.vendorAvailability?.days != null) {
        final rawDays = _bookService!.vendorAvailability!.days!;
        rawDays.forEach((key, value) {
          _dayAvailability[key.toLowerCase()] = value;
        });
      }

      // Force validation of current date
      _validateSelectedDate();

      notifyListeners();
    } catch (e) {
      Get.showToast(
        e.toString() ?? 'Something went wrong',
        type: ToastType.error,
      );
      print('Error scheduling service: $e');
    }
  }

  void _validateSelectedDate() {
    final dayName = _getDayName(_selectedDate);

    if (!_dayAvailability.containsKey(dayName)) {
      _selectedTime = null; // no service that day
    }
  }

  bool _isBookingLoading = false;
  bool get isBookingLoading => _isBookingLoading;

  Future<bool> bookServiceApi({
    required BuildContext context,
    required int addressId,
    required String paymentMethod,
  }) async {
    try {
      _isBookingLoading = true;
      notifyListeners();

      /// 🔹 Selected time validation
      if (_selectedTime == null) {
        throw Exception("Time not selected");
      }

      // Find the matching slot from availability to get exact from/to times
      final dayName = _getDayName(_selectedDate);
      final slots = _dayAvailability[dayName] ?? [];

      DaySlot? selectedSlot;
      for (var slot in slots) {
        if (slot.from != null && slot.to != null) {
          if (_formatSlotForDisplay(slot) == _selectedTime) {
            selectedSlot = slot;
            break;
          }
        }
      }

      if (selectedSlot == null) {
        throw Exception("Selected slot not found");
      }

      /// 🔹 API body (MATCHING POSTMAN)
      final Map<String, dynamic> data = {
        "vendor_id": _bookService?.vendorId,
        "service_date": _selectedDate.toIso8601String().split('T').first,
        "service_day": _getDayName(_selectedDate),
        "service_time": {"from": selectedSlot.from, "to": selectedSlot.to},
        "address_id": addressId,
        "payment_method": paymentMethod,
      };

      debugPrint("BOOK SERVICE REQUEST ADDRESS_ID => $addressId");
      debugPrint("BOOK SERVICE REQUEST DATA => $data");

      final response = await _repository.completescheduleServiceApi(data);

      debugPrint("BOOK SERVICE RESPONSE => $response");

      if (response['status'] == true) {
        Get.showToast(
          response['message'] ?? 'Booking Placed Sucessfully',
          type: ToastType.success,
        );
        notifyListeners();

        BookingconfirmerdModel bookingModel = BookingconfirmerdModel.fromJson(
          response,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BookingConfirmScreen(bookingModel: bookingModel),
          ),
        );
        return true;
      } else {
        Get.showToast(
          e.toString() ?? 'Booking Placed Failed',
          type: ToastType.error,
        );
        throw Exception(response['message'] ?? "Booking failed");
      }
    } catch (e) {
      debugPrint("BOOK SERVICE ERROR => $e");
      Get.showToast(
        e.toString() ?? 'Booking Placed Failed',
        type: ToastType.error,
      );
      return false;
    } finally {
      _isBookingLoading = false;
      notifyListeners();
    }
  }
}
