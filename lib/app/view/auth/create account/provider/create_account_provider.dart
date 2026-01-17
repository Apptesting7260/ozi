import 'package:flutter/cupertino.dart';
import 'package:ozi/app/modules/vendor/navigation%20tab/view/vendor_navigation_tab_screen.dart';

import '../../../../core/appExports/app_export.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../data/network/network_api_services.dart';
import '../../../../data/storage/user_preference.dart';
import '../../../../modules/auth/vendor/signup/view/service_category.dart';
import '../../../../modules/user/navigation tab/view/navigation_tab_screen.dart';

class CreateAccountProvider with ChangeNotifier {
  final NetworkApiServices _apiService = NetworkApiServices();

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool _loading = false;
  bool get loading => _loading;

  updateLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> createAccount(String userId) async {
    // Validate form before API call
    if (!formKey.currentState!.validate()) {
      return;
    }

    updateLoading(true);

    try {
      final response = await _apiService.postApiWithoutToken(
        {
          "user_id": userId,
          "first_name": firstNameController.text.trim(),
          "last_name": lastNameController.text.trim(),
          "email": emailController.text.trim(),
        },
        AppUrls.completeRegistration,
      );
      updateLoading(false);
      print(response);
      loginWithSaveTokenRedirection(
        response['data']['user_role']?.toString(),
        response['data']['api_token']?.toString(),
      );
    } catch (e) {
      updateLoading(false);
    }
  }

  Future<void> loginWithSaveTokenRedirection(String? role, String? token) async {
    if (role == null || token == null) {
      return;
    }
   await UserPreference.isLoggedIn(true);
   await UserPreference.saveAccessToken(token);
   await UserPreference.saveRole(role);
   if(role=='user'){
     Navigator.push(
       navigatorKey.currentContext!,
       MaterialPageRoute(
         builder: (_) =>   NavigationTabScreen(),
       ),
     );
   }else if(role=='vendor'){
     // Navigator.push(
     //   navigatorKey.currentContext!,
     //   MaterialPageRoute(
     //     builder: (_) =>   VendorNavigationTabScreen(),
     //   ),
     // );
     Navigator.push(
       navigatorKey.currentContext!,
       MaterialPageRoute(
         builder: (_) =>   ServiceCategory(),
       ),
     );
   }

    if (role == 'user') {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => NavigationTabScreen(),
        ),
      );
    } else if (role == 'vendor') {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => VendorNavigationTabScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}