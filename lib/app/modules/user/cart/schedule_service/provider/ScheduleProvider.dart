
import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/data/repository/repository.dart';
import 'package:ozi/app/modules/user/cart/schedule_service/Model/bookservicemodel.dart';

class ScheduleProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  BookServiceModel? _bookService;

  Map<String, List<DaySlot>> _dayAvailability = {};

// Get next 4 days for quick selection
List<Map<String, String>> get quickDates {
  List<Map<String, String>> dates = [];
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

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

    // Convert API DaySlot to displayable time strings
    List<String> times = [];
    for (var slot in slots) {
      final from = slot.from;
      final to = slot.to;
      if (from != null && to != null) {
        // Convert from HH:mm strings to DateTime objects
        DateTime fromTime = _parseTime(from);
        DateTime toTime = _parseTime(to);

        // Generate times in 30-min intervals
        while (!fromTime.isAfter(toTime)) {
          final hour = fromTime.hour > 12 ? fromTime.hour - 12 : fromTime.hour;
          final minute = fromTime.minute.toString().padLeft(2, '0');
          final period = fromTime.hour >= 12 ? 'PM' : 'AM';
          times.add('$hour:$minute $period');

          fromTime = fromTime.add(Duration(minutes: 30));
        }
      }
    }
    return times;
  }

  // --- Helpers ---
  String _getDayName(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }

  DateTime _parseTime(String time) {
    // Assumes HH:mm (24-hour format)
    final parts = time.split(':');
    return DateTime(
      0, 0, 0,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
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
      _dayAvailability = _bookService!.vendorAvailability!.days!;
    }

    // Force validation of current date
    _validateSelectedDate();

    notifyListeners();
  } catch (e) {
    print('Error scheduling service: $e');
  }
}

void _validateSelectedDate() {
  final dayName = _getDayName(_selectedDate);

  if (!_dayAvailability.containsKey(dayName)) {
    _selectedTime = null; // no service that day
  }
}

}
