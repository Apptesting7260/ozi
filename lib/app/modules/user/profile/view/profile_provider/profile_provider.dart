import 'package:ozi/app/core/appExports/app_export.dart';
import '../../../../../data/repository/repository.dart';
import '../../../../../data/storage/user_preference.dart';
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
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.splashScreen,
                (route) => false,
          );
        }
      } else {
        _errorMessage = response.message ?? 'Logout failed';
        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> fetchUserProfile() async {
    _isProfileLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      String? storedToken = await UserPreference.returnAccessToken();
      print('=== TOKEN DEBUG ===');
      print('Stored token: $storedToken');

      dynamic response = await _repository.getProfileApi();

      _userProfile = UserProfileModel.fromJson(response);
      _isProfileLoading = false;
      notifyListeners();

      if (_userProfile?.status != true) {
        _errorMessage = _userProfile?.message ?? 'Failed to fetch profile';
        notifyListeners();
      }
    } catch (e) {
      _isProfileLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      print('Error fetching profile: $_errorMessage');
    }
  }

  Future<void> refreshProfile() async {
    await fetchUserProfile();
  }
}
