import '../../../../../core/appExports/app_export.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../data/network/network_api_services.dart';
import '../../../../../data/storage/user_preference.dart';
import '../../model/choose_role_model.dart';

class RoleProvider extends ChangeNotifier {
  final NetworkApiServices _apiService = NetworkApiServices();

  // No default selection
  String? selectedRole;

  bool isLoading = false;
  String? errorMessage;

  void selectRole(String role) {
    selectedRole = role;
    notifyListeners();
  }

  bool get hasSelectedRole => selectedRole != null;

  Future<ChooseRoleModel?> chooseRole({required String userId}) async {
    if (kDebugMode) {
      print("in Choose Role 1");
    }
    if (selectedRole == null) {
      errorMessage = "lect a role";
      notifyListeners();
      return null;
    }
    if (kDebugMode) {
      print("in Choose Role 2");
    }

    isLoading = true;
    if (kDebugMode) {
      print("in Choose Role 3");
    }

    errorMessage = null;
    if (kDebugMode) {
      print("in Choose Role 4");
    }

    notifyListeners();
    if (kDebugMode) {
      print("in Choose Role 5");
    }

    try {
      final response = await _apiService.postApiWithoutToken({
        "user_id": userId,
        "user_role": selectedRole,
      }, AppUrls.chooseRole);
      if (kDebugMode) {
        print("in Choose Role 6");
      }

      final chooseRoleResponse = ChooseRoleModel.fromJson(response);

      if (chooseRoleResponse.status == true) {
        await UserPreference.saveIsRoleSelected(true);
        await UserPreference.saveRole(selectedRole!);
      }

      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print("in Choose Role 7");
      }

      return chooseRoleResponse;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }
}
