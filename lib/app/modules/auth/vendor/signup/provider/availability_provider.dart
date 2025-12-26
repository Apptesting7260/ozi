import '../../../../../core/appExports/app_export.dart';

class TimeSlot {
  String from;
  String to;

  TimeSlot({this.from = "09:00", this.to = "17:00"});
}

class DayAvailability {
  bool enabled;
  List<TimeSlot> slots;

  DayAvailability({
    this.enabled = false,
    List<TimeSlot>? slots,
  }) : slots = slots ?? [TimeSlot()];
}

class AvailabilityProvider extends ChangeNotifier {
  final Map<String, DayAvailability> availability = {
    "Monday": DayAvailability(),
    "Tuesday": DayAvailability(),
    "Wednesday": DayAvailability(),
    "Thursday": DayAvailability(),
    "Friday": DayAvailability(),
    "Saturday": DayAvailability(),
    "Sunday": DayAvailability(),
  };

  void toggleDay(String day, bool value) {
    availability[day]!.enabled = value;
    notifyListeners();
  }

  void addSlot(String day) {
    availability[day]!.slots.add(TimeSlot());
    notifyListeners();
  }

  void removeSlot(String day, int index) {
    // Only remove if there's more than 1 slot (keep at least 1)
    if (availability[day]!.slots.length > 1) {
      availability[day]!.slots.removeAt(index);
      notifyListeners();
    }
  }

  void updateSlotTime(String day, int index, {String? from, String? to}) {
    if (from != null) {
      availability[day]!.slots[index].from = from;
    }
    if (to != null) {
      availability[day]!.slots[index].to = to;
    }
    notifyListeners();
  }
}