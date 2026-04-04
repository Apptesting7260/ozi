import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/appExports/app_export.dart';

class UserPreference {
  static final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  static saveAccessToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("accessToken", token);
  }

  static Future<String?> returnAccessToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString("accessToken");
    return token;
  }

  static saveRefreshToken(String token) async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.setString("refresh_token", token);

    secureStorage.write(key: "refresh_token", value: token);
  }

  static saveIsLoggedIn(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isLoggedIn", value);
    // Also set isLogin for compatibility if needed, but we should migrate to isLoggedIn
    pref.setBool("isLogin", value);
  }

  static saveLoginStatus(bool isLogin) async {
    await saveIsLoggedIn(isLogin);
  }

  static isLoggedIn(bool value) async {
    await saveIsLoggedIn(value);
  }

  static saveIsDocumentVerified(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isDocumentVerified", value);
  }

  static Future<bool?> returnIsDocumentVerified() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("isDocumentVerified");
  }

  static Future<bool?> returnIsLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? isLoggedIn = pref.getBool("isLoggedIn");
    return isLoggedIn;
  }

  static saveRole(String role) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("role", role);
  }

  static Future<String?> returnRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? role = pref.getString("role");
    return role;
  }

  static saveStep(String step) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("step", step);
  }

  static Future<String?> returnStep() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? step = pref.getString("step");
    return step;
  }

  static saveToken(String token) async {
    secureStorage.write(key: "token", value: token);
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.setString("token", token);
  }

  static saveUserId(String userId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("userid", userId);
  }

  static Future<String?> returnUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = pref.getString("userid");
    return userId;
  }

  static saveFirstName(String firstName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("firstName", firstName);
  }

  static Future<String?> returnFirstName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("firstName");
  }

  static saveLastName(String lastName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("lastName", lastName);
  }

  static Future<String?> returnLastName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("lastName");
  }

  static saveEmail(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("email", email);
  }

  static Future<String?> returnEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("email");
  }

  static saveMobile(String mobile) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("mobile", mobile);
  }

  static Future<String?> returnMobile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("mobile");
  }

  static saveIsMobileVerified(bool isVerified) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isMobileVerified", isVerified);
  }

  static Future<bool?> returnIsMobileVerified() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("isMobileVerified");
  }

  static saveIsEmailVerified(bool isVerified) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isEmailVerified", isVerified);
  }

  static Future<bool?> returnIsEmailVerified() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("isEmailVerified");
  }

  static saveVerifiedEmail(String verifiedEmail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("verifiedEmail", verifiedEmail);
  }

  static Future<String?> returnVerifiedEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("verifiedEmail");
  }

  static saveVerifiedCountryCode(String countryCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("verifiedCountryCode", countryCode);
  }

  static Future<String?> returnVerifiedCountryCode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("verifiedCountryCode");
  }

  static saveIsRoleSelected(bool isSelected) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isRoleSelected", isSelected);
  }

  static Future<bool?> returnIsRoleSelected() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("isRoleSelected");
  }

  static saveLocationConsent(bool hasConsented) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("location_consent", hasConsented);
  }

  static Future<bool?> returnLocationConsent() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("location_consent");
  }

  static clearSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('accessToken');
    pref.remove('isLoggedIn');
    pref.remove('role');
    pref.remove('step');
    pref.remove('userid');
    pref.remove('firstName');
    pref.remove('lastName');
    pref.remove('email');
    pref.remove('verifiedEmail');
    pref.remove('isEmailVerified');
    pref.remove('mobile');
    pref.remove('isMobileVerified');
    pref.remove('verifiedCountryCode');
    pref.remove('isRoleSelected');
    pref.remove('location_consent');
    pref.remove('isDocumentVerified');
  }
}
