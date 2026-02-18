import '../../../../../core/appExports/app_export.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../data/models/vendor_availability.dart';
import '../../../../../data/network/network_api_services.dart';
import '../../../../../data/storage/user_preference.dart';
import '../view/identity_verification_screen.dart';



class AvailabilityProvider extends ChangeNotifier {

  AvailabilityProvider(bool isFromProfile) {
    if (isFromProfile) {
      // Profile edit → Load from API
      getAvailability();
    } else {
      // Registration → Enable all days by default
      availability.forEach((key, value) {
        value.enabled = true;
      });
    }
  }


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
    final slots = availability[day]!.slots;

    if (slots.isNotEmpty) {
      final lastSlot = slots.last;

      // Convert last "to" time to minutes
      final parts = lastSlot.to.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      // Start new slot from last slot's end
      int newFromHour = hour;
      int newFromMinute = minute;

      // Default 1 hour duration
      int newToHour = newFromHour + 1;
      int newToMinute = newFromMinute;

      // Prevent overflow after 23:59
      if (newToHour >= 24) {
        return; // stop adding if day ends
      }

      String newFrom =
          "${newFromHour.toString().padLeft(2, '0')}:${newFromMinute.toString().padLeft(2, '0')}";

      String newTo =
          "${newToHour.toString().padLeft(2, '0')}:${newToMinute.toString().padLeft(2, '0')}";

      slots.add(TimeSlot(from: newFrom, to: newTo));
    } else {
      slots.add(TimeSlot(from: "09:00", to: "10:00"));
    }

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
    final slot = availability[day]!.slots[index];

    int convertToMinutes(String time) {
      final parts = time.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    }

    if (from != null) {
      int fromMinutes = convertToMinutes(from);
      int toMinutes = convertToMinutes(slot.to);

      if (fromMinutes < toMinutes) {
        slot.from = from;
      } else {
        return; // prevent invalid
      }
    }

    if (to != null) {
      int toMinutes = convertToMinutes(to);
      int fromMinutes = convertToMinutes(slot.from);

      if (toMinutes > fromMinutes) {
        slot.to = to;
      } else {
        return; // prevent invalid
      }
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

  Future<void> saveAvailability(bool isFromProfile)async {
    updateSubmitLoading(true);
    try {
      Map<String,String> fields = {
        'availability': jsonEncode(formatAvailability(availability))
      };
      print(fields);
      final response = await _apiService.postApiMultiPart(AppUrls.saveAvailabilityVendor,fields,{});
      print(response);
      if(isFromProfile==false){
        await UserPreference.saveStep('3');
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => IdentityVerificationScreen(isFromProfile: false,),
          ),
        );
      }else{
        Navigator.pop(navigatorKey.currentContext!);
      }
      updateSubmitLoading(false);
    } catch (e) {
      updateSubmitLoading(false);
      showCustomToast(navigatorKey.currentContext!, e.toString());
    }
  }

  Future<void> getAvailability()async {
    try {
      final response = await _apiService.getApi(AppUrls.getAvailabilityVendor);
      VendorAvailability fetchedAvailability = VendorAvailability.fromJson(response);
      fetchedAvailability.vendorAvailability?.forEach((key, value) {
        if (key != null && value != null && value.isNotEmpty) {
          List<TimeSlot> slots = [];
          value.forEach((e) {
            slots.add(
              TimeSlot(
                from: e['from'] ?? '',
                to: e['to'] ?? '',
              ),
            );
          });

          availability[capitalizeFirstLetter(key)] = DayAvailability(
            enabled: true,
            slots: slots,
          );
        }
      });
      notifyListeners();
      print(response);
    } catch (e) {
      showCustomToast(navigatorKey.currentContext!, e.toString());
    }
  }

  String capitalizeFirstLetter(String str) {
    if (str.isEmpty) {
      return str;
    }
    return str[0].toUpperCase() + str.substring(1);
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