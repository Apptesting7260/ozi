import 'package:flutter/material.dart';
import '../../data/storage/user_preference.dart';
import '../widgets/login_required_dialog.dart';

class AuthGuard {

  // Used when action requires full login (booking, payment etc)
  static Future<bool> requireLogin(BuildContext context) async {

    bool? loggedIn = await UserPreference.returnIsLoggedIn();
    String? role = await UserPreference.returnRole();

    // If logged user and not guest
    if (loggedIn == true && role != "guest") {
      return true;
    }

    // Guest OR not logged in → show login dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const LoginRequiredDialog(),
    );

    return false;
  }


  // Used when only token required (guest allowed)
  static Future<bool> allowGuest() async {
    bool? loggedIn = await UserPreference.returnIsLoggedIn();
    return loggedIn == true;
  }

}

class AuthGuestProvider extends ChangeNotifier {

  String _role = "";

  String get role => _role;
  bool get isGuest => _role == "guest";
  bool get isUser => _role == "user";

  Future<void> loadStatus() async {
    _role = await UserPreference.returnRole() ?? "";
    notifyListeners();
  }

  void updateRole(String role) {
    _role = role;
    notifyListeners();
  }
}