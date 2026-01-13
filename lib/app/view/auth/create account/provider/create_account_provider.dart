import 'package:flutter/cupertino.dart';
import 'package:ozi/app/modules/vendor/navigation%20tab/view/vendor_navigation_tab_screen.dart';

import '../../../../core/appExports/app_export.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../data/network/network_api_services.dart';
import '../../../../data/storage/user_preference.dart';
import '../../../../modules/user/navigation tab/view/navigation_tab_screen.dart';

class CreateAccountProvider with ChangeNotifier{

  final NetworkApiServices _apiService = NetworkApiServices();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  bool _loading = false;
  bool get loading => _loading;
  updateLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  Future<void> createAccount(String userId)async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) =>   NavigationTabScreen(),
    //   ),
    // );

    updateLoading(true);

    try {
      final response = await _apiService.postApiWithoutToken(
        {
          "user_id": userId,
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "email": emailController.text,
        },
        AppUrls.completeRegistration,
      );
      updateLoading(false);
      print(response);//data['api_token'],data['role']
      loginWithSaveTokenRedirection(response['data']['user_role']?.toString(),response['data']['api_token']?.toString());
      // ChooseRoleModel.fromJson(response);
    } catch (e) {
      updateLoading(false);
    }

  }

  Future<void> loginWithSaveTokenRedirection(String? role,String? token) async {
    if(role==null||token==null){
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
     Navigator.push(
       navigatorKey.currentContext!,
       MaterialPageRoute(
         builder: (_) =>   VendorNavigationTabScreen(),
       ),
     );
   }

  }


}