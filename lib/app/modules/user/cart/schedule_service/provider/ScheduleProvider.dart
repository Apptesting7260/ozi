import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/data/repository/repository.dart';
import 'package:ozi/app/modules/user/cart/booking%20confirmed/view/BookingConfirmScreen.dart';
import 'package:ozi/app/modules/user/cart/schedule_service/Model/bookservicemodel.dart';
import '../../chnge payment method/provider/PaymentMethodProvider.dart';
import '../Model/bookingcompletemodel.dart';
import '../../../profile/save address/model/user_address_model.dart'
    as address_model;

class ScheduleProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  PaymentModel? _selectedPaymentMethod;
  PaymentModel? get selectedPaymentMethod => _selectedPaymentMethod;

  void setPaymentMethod(PaymentModel method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime? _customSelectedDate;
  String? _selectedTime;
  BookServiceModel? _bookService;
  // Map<String, List<DaySlot>> _dayAvailability = {};
  final Map<String, List<DaySlot>> _dayAvailability = {};

  // Get next 4 days for quick selection
  List<DateTime> get quickDates {
    List<DateTime> dates = [];
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // Default 4 days
    for (int i = 0; i < 4; i++) {
      dates.add(today.add(Duration(days: i)));
    }

    // If a custom date is selected and it's not in the default 4 days,
    // Add it to the list (at index 1 as requested)
    if (_customSelectedDate != null) {
      bool alreadyExists = dates.any(
        (d) =>
            d.year == _customSelectedDate!.year &&
            d.month == _customSelectedDate!.month &&
            d.day == _customSelectedDate!.day,
      );

      if (!alreadyExists) {
        // Show at index 0 as requested.
        dates.insert(0, _customSelectedDate!);
      }
    }

    return dates;
  }

  String formatDatePart(DateTime date, String part) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
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

    if (part == 'day') return days[date.weekday % 7];
    if (part == 'date') return date.day.toString();
    if (part == 'month') return months[date.month - 1];
    return "";
  }

  // Getters
  DateTime get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;
  BookServiceModel? get bookService => _bookService;
  // Returns the available time slots for the selected day
  bool get isToday {
    final selected = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return selected == today;
  }

  List<String> get availableTimesForSelectedDay {
    final dayName = _getDayName(_selectedDate);
    final slots = _dayAvailability[dayName] ?? [];

    if (slots.isEmpty) return [];

    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;

    // Debug prints (remove later if you want)
    print('Time slots debug ───────────────────────────────');
    print('Selected: ${_selectedDate.toString().substring(0, 10)}');
    print('Today:    ${now.toString().substring(0, 10)}');
    print('isToday:  $isToday');
    print(
      'Now:      ${now.hour}:${now.minute.toString().padLeft(2, '0')} ($nowMinutes min)',
    );

    List<String> times = [];

    for (var slot in slots) {
      if (slot.from == null || slot.to == null) continue;

      DateTime start = _parseTime(slot.from!);
      DateTime end = _parseTime(slot.to!);

      DateTime current = start;

      while (!current.add(const Duration(hours: 1)).isAfter(end)) {
        final slotMinutes = current.hour * 60 + current.minute;

        bool shouldShow = true;

        const bufferInMinutes = 15;

        // Main condition: hide past slots and those within 15 mins
        if (isToday && slotMinutes <= (nowMinutes + bufferInMinutes)) {
          shouldShow = false;
          print(
            '   Hidden: ${_formatTime(current)} ($slotMinutes min)  ≤  ${nowMinutes + bufferInMinutes}',
          );
        }

        // Alternative stricter version (uncomment if you want buffer)
        // if (isToday && slotMinutes < now.hour * 60 + 30) {
        //   shouldShow = false;
        //   print('   Hidden (buffer): ${_formatTime(current)}');
        // }

        if (shouldShow) {
          times.add(_formatTime(current));
        }

        current = current.add(const Duration(hours: 1));
      }
    }

    print('Shown (${times.length}): $times');
    print('─────────────────────────────────────────────────');

    return times;
  }

  // List<String> get availableTimesForSelectedDay {
  //   final dayName = _getDayName(_selectedDate);
  //   final slots = _dayAvailability[dayName];

  //   if (slots == null || slots.isEmpty) return [];

  //   List<String> times = [];
  //   final now = DateTime.now();

  //   // Check if selected date is today (Comparing only year, month, day)
  //   final isToday =
  //       _selectedDate.year == now.year &&
  //       _selectedDate.month == now.month &&
  //       _selectedDate.day == now.day;

  //   final nowTimeInMinutes = now.hour * 60 + now.minute;

  //   if (kDebugMode && isToday) {
  //     print("--- Time Filtering Debug ---");
  //     print("Selected Date is TODAY");
  //     print("Current Time: ${now.hour}:${now.minute} ($nowTimeInMinutes min)");
  //   }

  //   for (var slot in slots) {
  //     if (slot.from != null && slot.to != null) {
  //       DateTime startTime = _parseTime(slot.from!);
  //       DateTime endTime = _parseTime(slot.to!);

  //       DateTime current = startTime;
  //       while (!current.add(const Duration(hours: 1)).isAfter(endTime)) {
  //         bool isFutureSlot = true;

  //         if (isToday) {
  //           final slotTimeInMinutes = current.hour * 60 + current.minute;

  //           // LOGIC: Hide slot if it starts at or before the current time
  //           if (slotTimeInMinutes <= nowTimeInMinutes) {
  //             isFutureSlot = false;
  //           }

  //           if (kDebugMode && !isFutureSlot) {
  //             print(
  //               "Hiding Slot: ${_formatTime(current)} ($slotTimeInMinutes min) <= Current ($nowTimeInMinutes min)",
  //             );
  //           }
  //         }

  //         if (isFutureSlot) {
  //           times.add(_formatTime(current));
  //         }
  //         current = current.add(const Duration(hours: 1));
  //       }
  //     }
  //   }
  //   return times;
  // }

  String _formatTime(DateTime time) {
    int displayHour = time.hour % 12;
    if (displayHour == 0) displayHour = 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$displayHour:$minute $period';
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
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return DateTime(
        2000,
        1,
        1,
        hour,
        minute,
      ); // Use a stable date for parsing hours/mins
    } catch (e) {
      debugPrint("Error parsing time: $time => $e");
      return DateTime(2000, 1, 1, 0, 0);
    }
  }

  void selectDate(DateTime date, {bool isCustom = false}) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    if (isCustom) {
      _customSelectedDate = _selectedDate;
    }
    _selectedTime = null; // reset selected time
    notifyListeners();
  }

  void selectTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  Future<void> scheduleService() async {
    _isLoading = true;
    notifyListeners();
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
      Get.showToast(e.toString(), type: ToastType.error);
      if (kDebugMode) {
        print('Error scheduling service: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
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
    required address_model.Data address,
    required String paymentMethod,
  }) async {
    try {
      _isBookingLoading = true;
      notifyListeners();

      ///  Selected time validation
      if (_selectedTime == null) {
        throw Exception("Time not selected");
      }

      // Find the matching slot from availability to get exact from/to times
      final dayName = _getDayName(_selectedDate);
      final slots = _dayAvailability[dayName] ?? [];

      DaySlot? selectedSlot;
      for (var slot in slots) {
        if (slot.from != null && slot.to != null) {
          DateTime startTime = _parseTime(slot.from!);
          DateTime endTime = _parseTime(slot.to!);

          DateTime current = startTime;
          while (!current.add(const Duration(hours: 1)).isAfter(endTime)) {
            if (_formatTime(current) == _selectedTime) {
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

      ///  API body (MATCHING POSTMAN)
      final Map<String, dynamic> data = {
        "vendor_id": _bookService?.vendorId,
        "service_date": _selectedDate.toIso8601String().split('T').first,
        "service_day": _getDayName(_selectedDate),
        "service_time": selectedSlot.from,
        "street_address": address.streetAddress ?? "",
        "apartment": address.apartment ?? "",
        "city": address.city ?? "",
        "zip_code": address.zipCode ?? "",
        "country": address.country ?? "",
        "latitude": address.latitude ?? "",
        "longitude": address.longitude ?? "",
        "address_type": address.addressType ?? "",
        "payment_method": paymentMethod,
      };

      // If it's a saved address, we might still want to send the ID if the backend needs it
      if (address.id != null) {
        data["address_id"] = address.id.toString();
      }

      debugPrint("BOOK SERVICE REQUEST DATA => $data");

      ///  API CALL logic changed based on payment method
      if (paymentMethod == 'cash') {
        final response = await _repository.completescheduleServiceApi(data);
        BookingconfirmerdModel bookingModel = BookingconfirmerdModel.fromJson(
          response,
        );

        if (response['status'] == true) {
          Get.showToast(
            response['message'] ?? 'Booking Placed Sucessfully',
            type: ToastType.success,
          );
          notifyListeners();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BookingConfirmScreen(bookingModel: bookingModel),
            ),
          );
          return true;
        } else {
          Get.showToast(
            response['message'] ?? 'Booking Placed Failed',
            type: ToastType.error,
          );
          return false;
        }
      } else if (paymentMethod == 'pay_online') {
        // To get client secret, we first call the booking API
        final response = await _repository.completescheduleServiceApi(data);
        BookingconfirmerdModel bookingModel = BookingconfirmerdModel.fromJson(
          response,
        );

        if (response['status'] == true) {
          try {
            await Stripe.instance.initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret:
                    bookingModel.data?.clientSecret ?? "",
                merchantDisplayName: "Ozi App",
              ),
            );
            await Stripe.instance.presentPaymentSheet();

            Get.showToast(
              response['message'] ?? 'Booking Placed Sucessfully',
              type: ToastType.success,
            );
            notifyListeners();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        BookingConfirmScreen(bookingModel: bookingModel),
              ),
            );
            return true;
          } catch (e) {
            if (e is StripeException && e.error.code == FailureCode.Canceled) {
              debugPrint("Payment Canceled");
            } else {
              debugPrint("Stripe error: $e");
            }
            // show payment failed popup on schedule service screen
            _showPaymentFailedPopup(context);
            return false;
          }
        } else {
          Get.showToast(
            response['message'] ?? 'Booking Placed Failed',
            type: ToastType.error,
          );
          return false;
        }
      }

      return false;
    } catch (error) {
      debugPrint("BOOK SERVICE ERROR => $error");
      Get.showToast(error.toString(), type: ToastType.error);
      return false;
    } finally {
      _isBookingLoading = false;
      notifyListeners();
    }
  }

  void _showPaymentFailedPopup(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Payment Failed",
              style: AppFontStyle.text_16_600(AppColors.black),
            ),
            content: Text(
              "Something went wrong with the payment or you cancelled it. Please try again.",
              style: AppFontStyle.text_14_400(AppColors.black),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "OK",
                  style: AppFontStyle.text_14_400(AppColors.primary),
                ),
              ),
            ],
          ),
    );
  }
}
