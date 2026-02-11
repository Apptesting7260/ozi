import 'package:flutter/material.dart';
import 'package:ozi/app/data/repository/repository.dart';
import '../model/login_detail_model.dart';
import '../model/logout_user_model.dart';

class LoginDetailsProvider extends ChangeNotifier {
  final Repository _repo = Repository();

  bool _isLoading = false;
  bool _isLogoutLoading = false;
  String? _error;

  CurrentUserLoginModel? _loginModel;

  bool get isLoading => _isLoading;
  bool get isLogoutLoading => _isLogoutLoading;
  String? get error => _error;

  List<Data> get devices => _loginModel?.data ?? [];

  // Fetching login Device

  Future<void> fetchLoginDetails() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repo.fetchCurrentUserLoginDetails();
      _loginModel = response;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }



  // Logout from device

  Future<bool> logoutFromDevice(String tokenId) async {
    _isLogoutLoading = true;
    notifyListeners();

    try {
      LogoutUsersModel response =
      await _repo.logoutUserFromOtherDevice(tokenId);

      if (response.status == true) {
        await fetchLoginDetails();
        return true;
      } else {
        _error = response.message ?? "Logout failed";
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLogoutLoading = false;
      notifyListeners();
    }
  }
}
