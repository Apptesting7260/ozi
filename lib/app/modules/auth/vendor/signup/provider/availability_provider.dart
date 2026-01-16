import '../../../../../core/appExports/app_export.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../data/network/network_api_services.dart';
import '../../../../../data/storage/user_preference.dart';
import '../view/identity_verification_screen.dart';



class AvailabilityProvider extends ChangeNotifier {

  final NetworkApiServices _apiService = NetworkApiServices();

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

  Map<String, List<Map<String, String>>> formatAvailability(
      Map<String, DayAvailability> availability,
      ) {
      return availability.map((day, dayAvailability) {
        return MapEntry(
          day.toLowerCase(),
          dayAvailability.enabled
              ? dayAvailability.slots.map((slot) => slot.toJson()).toList()
              : <Map<String, String>>[],
        );
      });
  }

  bool _submitLoading = false;
  bool get submitLoading => _submitLoading;
  updateSubmitLoading(bool value){
    _submitLoading = value;
    notifyListeners();
  }

  Future<void> saveAvailability()async {
    updateSubmitLoading(true);
    try {
      Map<String,String> fields = {
        'availability': jsonEncode(formatAvailability(availability))
      };
      print(fields);
      final token = await UserPreference.returnAccessToken();
      final response = await _apiService.postApiMultiPart(AppUrls.saveAvailabilityVendor,token!,fields,{});
      print(response);
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => IdentityVerificationScreen(),
        ),
      );
      updateSubmitLoading(false);
    } catch (e) {
      updateSubmitLoading(false);
      showCustomToast(navigatorKey.currentContext!, e.toString());
    }

  }

}


class TimeSlot {
  String from;
  String to;

  TimeSlot({this.from = "09:00", this.to = "17:00"});

  Map<String, String> toJson() => {
    "from": from,
    "to": to,
  };
}

class DayAvailability {
  bool enabled;
  List<TimeSlot> slots;

  DayAvailability({
    this.enabled = false,
    List<TimeSlot>? slots,
  }) : slots = slots ?? [TimeSlot()];
}