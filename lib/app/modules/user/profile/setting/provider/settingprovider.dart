import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/core/device%20info/get_device_Info.dart';
import 'package:ozi/app/data/repository/repository.dart';
import 'package:ozi/app/data/storage/user_preference.dart';
import 'package:ozi/app/routes/app_routes.dart';

import 'package:geocoding/geocoding.dart';
import 'package:ozi/app/core/device info/datainfoservices.dart';
import '../model/settingsmodel.dart';

class CurrentLocationInfo {
  final double latitude;
  final double longitude;
  final String locality;
  final String adminArea;
  final String country;
  final String featureName;

  CurrentLocationInfo({
    required this.latitude,
    required this.longitude,
    required this.locality,
    required this.adminArea,
    required this.country,
    required this.featureName,
  });
}

class Settingprovider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  settingsModel? _settingsModel;
  settingsModel? get settingsData => _settingsModel;

  CurrentLocationInfo? _currentLocation;
  CurrentLocationInfo? get currentLocation => _currentLocation;

  Future<void> syncHomeLocation(
    BuildContext context,
    String lat,
    String lng,
  ) async {
    try {
      String city = "";
      String state = "";
      String country = "";

      if (lat.isNotEmpty && lng.isNotEmpty && lat != "null" && lng != "null") {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          double.parse(lat),
          double.parse(lng),
        );
        if (placemarks.isNotEmpty) {
          city = placemarks.first.locality ?? "";
          state = placemarks.first.administrativeArea ?? "";
          country = placemarks.first.country ?? "";
        }
      }
      String deviceName = await DeviceIdService.getDeviceName();
      if (context.mounted) {
        await locationSendToBackend(context, lat, lng, city, state, country);
      }
    } catch (e) {
      if (kDebugMode) {
        print("syncHomeLocation error: $e");
      }
    }
  }

  void fetchCurrentLocation({
    required double latitude,
    required double longitude,
    required String locality,
    required String adminArea,
    required String country,
    required String featureName,
  }) {
    try {
      _currentLocation = CurrentLocationInfo(
        latitude: latitude,
        longitude: longitude,
        locality: locality,
        adminArea: adminArea,
        country: country,
        featureName: featureName,
      );
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error updating location: $e");
      }
    }
  }

  Future<void> settingsApi() async {
    final role = await UserPreference.returnRole();
    if (role == "guest") return;

    _isLoading = true;
    notifyListeners();
    try {
      final response = await _repository.settingsApi();
      if (response.status == true) {
        _settingsModel = response;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in settingsApi: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> locationSendToBackend(
    BuildContext context,
    String lat,
    String lng,
    String city,
    String state,
    String country,
  ) async {
    _isLoading = true;
    notifyListeners();

    final deviceInfo = await getDeviceInfo();
    try {
      Map<String, String> body = {
        "latitude": lat,
        "longitude": lng,
        "city": city,
        "state": state,
        "country": country,
        "device_name": deviceInfo["device_name"]?.toString() ?? "",
      };
      final response = await _repository.locationSendToBackend(body);
      if (response != null && response['status'] == true) {
        print("locationSendToBackend suucess ");
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in locationSendToBackend: $e');
      }
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> deleteProfile(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _repository.deleteProfile();
      if (response != null && response['status'] == true) {
        print("Account Delete suucess ");
        _isLoading = false;
        notifyListeners();

        await UserPreference.clearSharedPreference();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error in deleteProfile: $e');
      }
      return false;
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> updateNotificationApi(
    BuildContext context, {
    bool? pushValue,
    bool? emailValue,
  }) async {
    try {
      // Use provided value or fallback to current state from model
      bool currentPush = _settingsModel?.data?.isNotificationOn ?? false;
      bool currentEmail = _settingsModel?.data?.emailnotification ?? false;

      bool newPush = pushValue ?? currentPush;
      bool newEmail = emailValue ?? currentEmail;

      int status = newPush ? 1 : 0;
      int emailstatus = newEmail ? 1 : 0;

      final response = await _repository.updateNotificationApi(
        status,
        emailstatus,
      );

      if (response != null && response['status'] == true) {
        // Update local model
        if (_settingsModel?.data != null) {
          _settingsModel!.data!.isNotificationOn = newPush;
          _settingsModel!.data!.emailnotification = newEmail;
          notifyListeners();
        }
        if (context.mounted) {
          Get.showToast("${response['message']}", type: ToastType.success);
        }
      } else {
        if (context.mounted) {
          Get.showToast("${response['message']}", type: ToastType.error);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in updateNotificationApi: $e');
      }
      if (context.mounted) {
        Get.showToast("Something went wrong", type: ToastType.error);
      }
    }
  }
}
