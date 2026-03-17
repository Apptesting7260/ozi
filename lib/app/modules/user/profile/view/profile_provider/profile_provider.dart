import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/modules/user/home/provider/HomeScreenProvider.dart';
import '../../../../../data/repository/repository.dart';
import '../../../../../data/storage/user_preference.dart';
import '../../../../../shared/widgets/auth_guard.dart';
import '../model/logout_model.dart';
import '../../../../../routes/app_routes.dart';
import '../model/user_profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  final _repository = Repository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isProfileLoading = false;
  bool get isProfileLoading => _isProfileLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  UserProfileModel? _userProfile;
  UserProfileModel? get userProfile => _userProfile;

  ProfileData? get userData => _userProfile?.data;

  String get firstName => userData?.firstName ?? '';
  String get lastName => userData?.lastName ?? '';
  String get fullName => '$firstName $lastName'.trim();
  String get email => userData?.email ?? '';
  String get mobile => userData?.mobile ?? '';
  String get countryCode => userData?.countryCode ?? '';
  String get profileImage => userData?.proImg ?? '';
  String get phoneNumber => '$countryCode $mobile';

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
          context.read<ProfileProvider>().clearProfile();
          context.read<HomeScreenProvider>().resetState();

          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
          Get.showToast(
            response.message ?? 'Logout successfully',
            type: ToastType.success,
          );
        }
      } else {
        _errorMessage = response.message ?? 'Logout failed';
        notifyListeners();

        if (context.mounted) {
          Get.showToast(_errorMessage, type: ToastType.error);
        }
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();

      if (context.mounted) {
        Get.showToast(e.toString(), type: ToastType.error);
      }
    }
  }

  // Future<void> fetchUserProfile() async {
  //   _isProfileLoading = true;
  //   _errorMessage = '';
  //   notifyListeners();
  //
  //   try {
  //     print('=== TOKEN DEBUG ===');
  //
  //     dynamic response = await _repository.getProfileApi();
  //
  //     _userProfile = UserProfileModel.fromJson(response);
  //     UserPreference.saveUserId(_userProfile?.data?.id.toString() ?? '');
  //     _isProfileLoading = false;
  //     notifyListeners();
  //
  //     if (_userProfile?.status != true) {
  //       _errorMessage = _userProfile?.message ?? 'Failed to fetch profile';
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     _isProfileLoading = false;
  //     _errorMessage = e.toString().replaceAll('Exception: ', '');
  //     Get.showToast(
  //       e.toString() ?? 'Something went wrong',
  //       type: ToastType.error,
  //     );
  //     notifyListeners();
  //     print('Error fetching profile: $_errorMessage');
  //   }
  // }
  Future<void> fetchUserProfile() async {
    //  STEP 1: Check token first
    final role = await UserPreference.returnRole();

    // Stop API for guest users
    if (role == "guest") {
      return;
    }

    _isProfileLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      dynamic response = await _repository.getProfileApi();
      _userProfile = UserProfileModel.fromJson(response);
      UserPreference.saveUserId(_userProfile?.data?.id.toString() ?? '');

      _isProfileLoading = false;
      notifyListeners();

      if (_userProfile?.status != true) {
        _errorMessage = _userProfile?.message ?? 'Failed to fetch profile';
        notifyListeners();
      }
    } catch (e) {
      _isProfileLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      Get.showToast(_errorMessage, type: ToastType.error);
      notifyListeners();
    }
  }

  Future<void> refreshProfile() async {
    await fetchUserProfile();
  }

  void clearProfile() {
    _userProfile = null;
    notifyListeners();
  }
}
