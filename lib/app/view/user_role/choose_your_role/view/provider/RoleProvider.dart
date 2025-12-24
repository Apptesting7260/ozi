import 'package:flutter/material.dart';

class RoleProvider extends ChangeNotifier {
  String selectedRole = "user"; // default selected role

  void selectRole(String role) {
    selectedRole = role;
    notifyListeners();
  }
}
