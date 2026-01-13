import 'package:flutter/material.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../data/network/network_api_services.dart';
import '../../model/choose_role_model.dart';

class RoleProvider extends ChangeNotifier {
  final NetworkApiServices _apiService = NetworkApiServices();

  /// 🔹 No default selection
  String? selectedRole;

  bool isLoading = false;
  String? errorMessage;

  void selectRole(String role) {
    selectedRole = role;
    notifyListeners();
  }

  bool get hasSelectedRole => selectedRole != null;

  Future<ChooseRoleModel?> chooseRole({
    required String userId,
  }) async {
    if (selectedRole == null) {
      errorMessage = "Please select a role";
      notifyListeners();
      return null;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.postApiWithoutToken(
        {
          "user_id": userId,
          "user_role": selectedRole,
        },
        AppUrls.chooseRole,
      );

      isLoading = false;
      notifyListeners();

      return ChooseRoleModel.fromJson(response);
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }
}
