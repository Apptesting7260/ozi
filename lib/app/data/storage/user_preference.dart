import '../../core/appExports/app_export.dart';

class UserPreference {

  static saveAccessToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("accessToken", token);
  }

  static Future<String?> returnAccessToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString("accessToken");
    return token;
  }



  static isLoggedIn(bool step) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isLoggedIn", step);
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

  static saveUserId(String userId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("userid", userId);
  }

  static Future<String?> returnUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = pref.getString("userid");
    return userId;
  }


  static clearSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('accessToken');
    pref.remove('isLoggedIn');
    pref.remove('role');
    pref.remove('step');
    pref.remove('userid');
  }
}
