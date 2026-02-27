import 'package:flutter/material.dart';
import '../../data/storage/user_preference.dart';
import '../widgets/login_required_dialog.dart';

class AuthGuard {

  static Future<bool> requireLogin(BuildContext context) async {
    bool? loggedIn = await UserPreference.returnIsLoggedIn();

    if (loggedIn == true) {
      return true;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const LoginRequiredDialog(),
    );

    return false;
  }
}

class AuthGuestProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> loadStatus() async {
    _isLoggedIn = await UserPreference.returnIsLoggedIn() ?? false;
    notifyListeners();
  }

  void updateLogin(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
}