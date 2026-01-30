import 'package:flutter/material.dart';
import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/data/repository/repository.dart';
import 'package:ozi/app/data/storage/user_preference.dart';
import 'package:ozi/app/routes/app_routes.dart';
import '../model/settingsmodel.dart';

class Settingprovider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  settingsModel? _settingsModel;
  settingsModel? get settingsData => _settingsModel;

  Future<void> settingsApi() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _repository.settingsApi();
      if (response.status == true) {
        _settingsModel = response;
      }
    } catch (e) {
      print('Error in settingsApi: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteProfile(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _repository.deleteProfile();
      if (response != null && response['status'] == true) {
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
      print('Error in deleteProfile: $e');
      return false;
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> updateNotificationApi(BuildContext context, bool value) async {
    try {
      int status = value ? 1 : 0;

      final response = await _repository.updateNotificationApi(status);

      if (response != null && response['status'] == true) {
        // Update local model
        if (_settingsModel?.data != null) {
          _settingsModel!.data!.isNotificationOn = value;
          notifyListeners();
        }
        if (context.mounted) {
          Get.showToast("${response['message']}", type: ToastType.success);
          // successToast(
          //   context,
          //   response['message'] ?? "Notification updated successfully",
          // );
        }
      } else {
        if (context.mounted) {
          Get.showToast("${response['message']}", type: ToastType.error);
        }
      }
    } catch (e) {
      print('Error in updateNotificationApi: $e');
      if (context.mounted) {
        Get.showToast("Something went wrong", type: ToastType.error);
      }
    }
  }
}
