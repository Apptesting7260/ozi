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


  bool _pageLoading = false;
  bool get pageLoading => _pageLoading;

  void updatePageLoading(bool value) {
    _pageLoading = value;
    notifyListeners();
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

    if (slots.isEmpty) {
      slots.add(TimeSlot(from: "09:00", to: "10:00"));
      notifyListeners();
      return;
    }

    final last = slots.last;

    int start = _toMinutes(last.to);
    int end = start + 60;

    if (end > 24 * 60) {
      _error("No more time slots can be added for this day");
      return;
    }

    slots.add(TimeSlot(
      from: _fromMinutes(start),
      to: _fromMinutes(end),
    ));

    notifyListeners();
  }

  int _toMinutes(String time) {
    final p = time.split(':');
    return int.parse(p[0]) * 60 + int.parse(p[1]);
  }

  String _fromMinutes(int minutes) {
    int h = minutes ~/ 60;
    int m = minutes % 60;
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}";
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
    final slots = availability[day]!.slots;

    String newFrom = from ?? slot.from;
    String newTo = to ?? slot.to;

    int fromMin = _toMinutes(newFrom);
    int toMin = _toMinutes(newTo);


    if (fromMin >= toMin) {
      _error("Please select an end time after the start time");
      return;
    }

// ❗ Rule 2: prevent overlap
    for (int i = 0; i < slots.length; i++) {
      if (i == index) continue;

      int eFrom = _toMinutes(slots[i].from);
      int eTo = _toMinutes(slots[i].to);
      if (fromMin < eTo && toMin > eFrom) {
        _error("This time conflicts with another slot. Please choose a different time");

        fromMin = eTo;
        toMin = fromMin + 60;

        newFrom = _fromMinutes(fromMin);
        newTo = _fromMinutes(toMin);
      }
    }

// ✅ apply
    slot.from = newFrom;
    slot.to = newTo;

// ✅ keep sorted (important)
    slots.sort((a, b) =>
        _toMinutes(a.from).compareTo(_toMinutes(b.from)));

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
      if (kDebugMode) {
        print(fields);
      }
      final response = await _apiService.postApiMultiPart(AppUrls.saveAvailabilityVendor,fields,{});
      if (kDebugMode) {
        print(response);
      }
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
    updatePageLoading(true);
    try {
      final response = await _apiService.getApi(AppUrls.getAvailabilityVendor);
      VendorAvailability fetchedAvailability = VendorAvailability.fromJson(response);
      fetchedAvailability.vendorAvailability?.forEach((key, value) {
        if (value != null && value.isNotEmpty) {
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
      if (kDebugMode) {
        print(response);
      }
    } catch (e) {
      showCustomToast(navigatorKey.currentContext!, e.toString());
    }
    finally {
      updatePageLoading(false);
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

void _error(String message) {
  Get.showToast(
    message,
    type: ToastType.warning
  );
}


class DayAvailability {
  bool enabled;
  List<TimeSlot> slots;

  DayAvailability({
    this.enabled = false,
    List<TimeSlot>? slots,
  }) : slots = slots ?? [TimeSlot()];
}