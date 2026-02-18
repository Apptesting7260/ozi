import '../../../../core/appExports/app_export.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../data/network/network_api_services.dart';
import '../../../../data/storage/user_preference.dart';
import '../../../../modules/auth/vendor/signup/view/service_category.dart';
import '../../../../modules/user/navigation tab/view/navigation_tab_screen.dart';
import '../../../../data/repository/repository.dart';

class CreateAccountProvider with ChangeNotifier {
  final NetworkApiServices _apiService = NetworkApiServices();

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final Repository _repository = Repository();

  bool _isEmailValid = false;
  bool get isEmailValid => _isEmailValid;

  bool _isEmailVerified = false;
  bool get isEmailVerified => _isEmailVerified;

  bool _otpLoading = false;
  bool get otpLoading => _otpLoading;

  void validateEmail(String val) {
    _isEmailValid = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(val.trim());
    notifyListeners();
  }

  Future<dynamic> emailSendApi(Map<String, dynamic> data) async {
    try {
      updateLoading(true);
      final response = await _repository.emailSendApi(data);
      updateLoading(false);
      return response;
    } catch (e) {
      updateLoading(false);
      rethrow;
    }
  }

  Future<dynamic> verifyEmailApi(Map<String, dynamic> data) async {
    try {
      _otpLoading = true;
      notifyListeners();
      final response = await _repository.verifyEmailApi(data);
      _otpLoading = false;
      if (response['status'] == true ||
          response['status'] == 200 ||
          response['message']?.toString().toLowerCase().contains('success') ==
              true) {
        _isEmailVerified = true;
      }
      notifyListeners();
      return response;
    } catch (e) {
      _otpLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  bool _loading = false;
  bool get loading => _loading;

  updateLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> createAccount(String userId, BuildContext context) async {
    // Validate form before API call
    if (!formKey.currentState!.validate()) {
      return;
    }

    updateLoading(true);

    try {
      final response = await _apiService.postApiWithoutToken({
        "user_id": userId,
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "email": emailController.text.trim(),
      }, AppUrls.completeRegistration);
      updateLoading(false);
      if (kDebugMode) {
        print(response);
      }
      loginWithSaveTokenRedirection(
        response['data']['user_role']?.toString(),
        response['data']['api_token']?.toString(),
        userId,
      );
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       "$e",
      //     ),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      Get.showToast(e.toString(), type: ToastType.warning);
      updateLoading(false);
    }
  }

  Future<void> loginWithSaveTokenRedirection(
    String? role,
    String? token,
    String userId,
  ) async {
    if (role == null || token == null) {
      return;
    }
    await UserPreference.isLoggedIn(true);
    await UserPreference.saveAccessToken(token);
    await UserPreference.saveRole(role);
    await UserPreference.saveUserId(userId);
    await UserPreference.saveStep('1');
    if (role == 'user') {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => NavigationTabScreen()),
      );
    } else if (role == 'vendor') {
      // Navigator.push(
      //   navigatorKey.currentContext!,
      //   MaterialPageRoute(
      //     builder: (_) =>   VendorNavigationTabScreen(),
      //   ),
      // );
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => ServiceCategory()),
      );
    }

    // if (role == 'user') {
    //   Navigator.push(
    //     navigatorKey.currentContext!,
    //     MaterialPageRoute(
    //       builder: (_) => NavigationTabScreen(),
    //     ),
    //   );
    // } else if (role == 'vendor') {
    //   Navigator.push(
    //     navigatorKey.currentContext!,
    //     MaterialPageRoute(
    //       builder: (_) => VendorNavigationTabScreen(),
    //     ),
    //   );
    // }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
