import '../../../../core/appExports/app_export.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../data/network/network_api_services.dart';
import '../model/verify_otp.dart';

class VerificationProvider extends ChangeNotifier {
  final TextEditingController otpController = TextEditingController();
  final NetworkApiServices _apiService = NetworkApiServices();

  int resendTime = 55;
  Timer? timer;
  bool isLoading = false;
  String? errorMessage;

  void startTimer() {
    timer?.cancel();
    resendTime = 55;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTime > 0) {
        resendTime--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  String? userId;

  Future<bool> verifyOtpMethod(String phone) async {
    if (otpController.text.length != 6) {
      errorMessage = "Please enter a valid 6-digit OTP";
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      String countryCode = "+91";
      String mobile = phone;

      if (phone.startsWith("+")) {
        int spaceIndex = phone.indexOf(" ");
        if (spaceIndex > 0) {
          countryCode = phone.substring(0, spaceIndex);
          mobile = phone.substring(spaceIndex + 1);
        }
      }

      Map<String, dynamic> requestData = {
        "country_code": countryCode,
        "mobile": mobile,
        "otp": otpController.text,
      };

      verifyOtp response = await verificationUser(requestData);
      userId = response.userId;

      isLoading = false;

      if (response.status == true) {
        notifyListeners();
        return true;
      } else {
        errorMessage = response.message ?? "Verification failed";
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      errorMessage = "Wrong otp. Please try again.";
      notifyListeners();
      return false;
    }
  }

  Future<verifyOtp> verificationUser(Map<String, dynamic> data) async {
    try {
      dynamic response = await _apiService.postApiWithoutToken(
        data,
        AppUrls.verification,
      );
      return verifyOtp.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> resendOtp(String phone) async {
    if (resendTime > 0) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      String countryCode = "+91";
      String mobile = phone;

      if (phone.startsWith("+")) {
        int spaceIndex = phone.indexOf(" ");
        if (spaceIndex > 0) {
          countryCode = phone.substring(0, spaceIndex);
          mobile = phone.substring(spaceIndex + 1);
        }
      }

      Map<String, dynamic> requestData = {
        "country_code": countryCode,
        "mobile": mobile,
      };

      dynamic response = await _apiService.postApiWithoutToken(
        requestData,
        AppUrls.login,
      );

      isLoading = false;

      if (response['status'] == true) {
        startTimer();
        errorMessage = null;
      } else {
        errorMessage = response['message'] ?? "Failed to resend OTP";
      }
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to resend OTP. Please try again.";
      notifyListeners();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }
}