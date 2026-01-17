import 'package:flutter/material.dart';
import 'package:ozi/app/core/appExports/app_export.dart';
import '../../../../../data/repository/repository.dart';
import '../../../../../data/storage/user_preference.dart';
import '../model/logout_model.dart';
import '../../../../../routes/app_routes.dart';

class ProfileProvider extends ChangeNotifier {
  final _repository = Repository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      LogoutModel response = await _repository.logoutApi();

      _isLoading = false;
      notifyListeners();

      if (response.status == true) {
        await UserPreference.clearSharedPreference();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.splashScreen,
                (route) => false,
          );
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(response.message ?? 'Logged out successfully'),
          //     backgroundColor: Colors.green,
          //   ),
          // );
        }
      } else {
        _errorMessage = response.message ?? 'Logout failed';
        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


}