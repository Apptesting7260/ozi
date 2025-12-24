
import '../../../../../core/appExports/app_export.dart';

class ScheduleProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = '9:00 AM';

  DateTime get selectedDate => _selectedDate;
  String get selectedTime => _selectedTime;

  // Format date for display
  String get selectedDay {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[_selectedDate.weekday - 1];
  }

  String get selectedDateNumber => _selectedDate.day.toString();

  String get selectedMonth {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[_selectedDate.month - 1];
  }

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

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void selectTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }
}