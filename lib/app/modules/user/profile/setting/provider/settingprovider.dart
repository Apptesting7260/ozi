import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/core/device%20info/get_device_Info.dart';
import 'package:ozi/app/data/repository/repository.dart';
import 'package:ozi/app/data/storage/user_preference.dart';
import 'package:ozi/app/routes/app_routes.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../core/utils/location_permission_helper.dart';
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

      String finalLat = lat;
      String finalLng = lng;

      // Check if the provided lat/lng are invalid or empty
      bool locationMissing = finalLat.isEmpty ||
          finalLat == "null" ||
          finalLng.isEmpty ||
          finalLng == "null";

      if (locationMissing) {
        // 1. Try to use stored current location if available
        if (_currentLocation != null) {
          finalLat = _currentLocation!.latitude.toString();
          finalLng = _currentLocation!.longitude.toString();
          city = _currentLocation!.locality;
          state = _currentLocation!.adminArea;
          country = _currentLocation!.country;
          locationMissing = false;
        } else {
          // 2. Try to fetch current location from GPS if permission is granted
          bool hasPermission = await LocationPermissionHelper.handleLocationPermission(context);
          if (hasPermission) {
            Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              timeLimit: const Duration(seconds: 10),
            );
            finalLat = position.latitude.toString();
            finalLng = position.longitude.toString();
            locationMissing = false;
          }
        }
      }

      // If we now have valid coordinates, try to get address details if they are still missing
      if (!locationMissing && (city.isEmpty || state.isEmpty)) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            double.parse(finalLat),
            double.parse(finalLng),
          ).timeout(const Duration(seconds: 5));

          if (placemarks.isNotEmpty) {
            city = placemarks.first.locality ?? "";
            state = placemarks.first.administrativeArea ?? "";
            country = placemarks.first.country ?? "";

            // Update local state so we have it for next time
            _currentLocation = CurrentLocationInfo(
              latitude: double.parse(finalLat),
              longitude: double.parse(finalLng),
              locality: city,
              adminArea: state,
              country: country,
              featureName: placemarks.first.name ?? "",
            );
            notifyListeners();
          }
        } catch (e) {
          debugPrint("syncHomeLocation geocoding error: $e");
        }
      }

      // Only send to backend if we have a valid location now
      if (finalLat.isNotEmpty && finalLat != "null" && finalLng.isNotEmpty && finalLng != "null") {
        if (context.mounted) {
          await locationSendToBackend(context, finalLat, finalLng, city, state, country);
        }
      } else {
        debugPrint("syncHomeLocation: Still no location after attempts. Not sending to backend.");
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
