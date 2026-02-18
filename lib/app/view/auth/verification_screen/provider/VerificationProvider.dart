import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/appExports/app_export.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../core/device info/get_device_Info.dart';
import '../../../../core/push notification/push_notification.dart';
import '../../../../data/network/network_api_services.dart';
import '../../../../data/storage/user_preference.dart';
import '../../../../modules/auth/vendor/signup/view/identity_verification_screen.dart';
import '../../../../modules/auth/vendor/signup/view/service_category.dart';
import '../../../../modules/auth/vendor/signup/view/set_availability.dart';
import '../../../../modules/user/navigation tab/view/navigation_tab_screen.dart';
import '../../../../modules/vendor/navigation tab/view/vendor_navigation_tab_screen.dart';
import '../../../user_role/choose_your_role/view/choose_role.dart';
import '../model/verify_otp.dart';

class VerificationProvider extends ChangeNotifier {

  final String verificationId;

  VerificationProvider(this.verificationId);

  final TextEditingController otpController = TextEditingController();
  final NetworkApiServices _apiService = NetworkApiServices();
 // String? token = PushNotificationService.fcmToken;


  int resendTime = 55;
  Timer? timer;
  bool isLoading = false;
  String? errorMessage;
  String? userId;

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

  // Future<void> verifyOtpMethod(String phone) async {
  //   final deviceInfo = await getDeviceInfo();
  //
  //   if (otpController.text.length != 6) {
  //     errorMessage = "Please enter a valid 6-digit OTP";
  //     notifyListeners();
  //     return;
  //   }
  //
  //   isLoading = true;
  //   errorMessage = null;
  //   notifyListeners();
  //
  //   try {
  //     String countryCode = "+91";
  //     String mobile = phone;
  //
  //     if (phone.startsWith("+")) {
  //       int spaceIndex = phone.indexOf(" ");
  //       if (spaceIndex > 0) {
  //         countryCode = phone.substring(0, spaceIndex);
  //         mobile = phone.substring(spaceIndex + 1);
  //       }
  //     }
  //
  //     Map<String, dynamic> requestData = {
  //       "country_code": countryCode,
  //       "mobile": mobile,
  //       "otp": otpController.text,
  //       "fcm_token":PushNotificationService.fcmToken ?? "",
  //       "device_name": deviceInfo["device_name"] ?? "",
  //       "device_type": deviceInfo["device_type"] ?? "",
  //     };
  //
  //     // Use the verificationUser method
  //     verifyOtp response = await verificationUser(requestData);
  //
  //     isLoading = false;
  //
  //     if (response.status == true) {
  //       if (navigatorKey.currentContext!.mounted) {
  //         if(response.stepCompleted=='0'){
  //           Navigator.pushReplacement(
  //             navigatorKey.currentContext!,
  //             MaterialPageRoute(
  //               builder: (_) => ChooseRoleScreen(userId: response.userId,),
  //             ),
  //           );
  //         }else if(response.stepCompleted=='1'&&response.role=='vendor'){
  //           await saveLogin(response.role,response.token);
  //           Navigator.push(
  //             navigatorKey.currentContext!,
  //             MaterialPageRoute(
  //               builder: (_) => ServiceCategory(),
  //             ),
  //           );
  //         }else if(response.stepCompleted=='2'&&response.role=='vendor'){
  //           await saveLogin(response.role,response.token);
  //           Navigator.push(
  //             navigatorKey.currentContext!,
  //             MaterialPageRoute(
  //               builder: (_) => SetAvailabilityScreen(false),
  //             ),
  //           );
  //         }else if(response.stepCompleted=='3'&&response.role=='vendor'){
  //           await saveLogin(response.role,response.token);
  //           Navigator.push(
  //             navigatorKey.currentContext!,
  //             MaterialPageRoute(
  //               builder: (_) => IdentityVerificationScreen(isFromProfile: false,),
  //             ),
  //           );
  //         }else{
  //           if(response.role!=null&&response.token!=null){
  //             loginWithSaveTokenRedirection(response.role,response.token);
  //           }
  //         }
  //       }
  //       notifyListeners();
  //       return ;
  //     } else {
  //       // Wrong OTP - show error but DON'T navigate
  //       errorMessage = response.message ?? "Invalid OTP. Please try again.";
  //       notifyListeners();
  //       return ;
  //     }
  //   } catch (e) {
  //     isLoading = false;
  //     Get.showToast(e.toString(), type: ToastType.error);
  //     // Error occurred - show error but DON'T navigate
  //     errorMessage = "Wrong OTP. Please try again.";
  //     notifyListeners();
  //     return ;
  //   }
  // }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //String verificationId = '';

  Future<void> verifyOtpMethod(String phone) async {
    final deviceInfo = await getDeviceInfo();

    if (otpController.text.length != 6) {
      errorMessage = "Please enter a valid 6-digit OTP";
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Create Firebase credential
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text.trim(),
      );

      // Sign in with Firebase
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user == null) {
        if (kDebugMode) {
          print("Firebase User =========================================================> $user");
        }
        throw Exception("Firebase user is null");
      }

      // Get Firebase ID token
      // String idToken = (await user.getIdToken())!;

          String countryCode = "+91";
          String mobile = phone;

          if (phone.startsWith("+")) {
            int spaceIndex = phone.indexOf(" ");
            if (spaceIndex > 0) {
              countryCode = phone.substring(0, spaceIndex);
              mobile = phone.substring(spaceIndex + 1);
            }
          }

      //  Prepare backend request
      Map<String, dynamic> requestData = {
        "country_code": countryCode,
        "mobile": mobile,
        "fcm_token":PushNotificationService.fcmToken ?? "",
        "device_name": deviceInfo["device_name"] ?? "",
        "device_type": deviceInfo["device_type"] ?? "",
      };

      // Call your backend API
      verifyOtp response = await verificationUser(requestData);

      isLoading = false;

      if (response.status == true) {

        // Optional: Save token locally
        if (response.token != null) {
          await saveLogin(response.role, response.token);
        }

              if (navigatorKey.currentContext!.mounted) {
                if(response.stepCompleted=='0'){
                  Navigator.pushReplacement(
                    navigatorKey.currentContext!,
                    MaterialPageRoute(
                      builder: (_) => ChooseRoleScreen(userId: response.userId,),
                    ),
                  );
                }else if(response.stepCompleted=='1'&&response.role=='vendor'){
                  await saveLogin(response.role,response.token);
                  Navigator.push(
                    navigatorKey.currentContext!,
                    MaterialPageRoute(
                      builder: (_) => ServiceCategory(),
                    ),
                  );
                }else if(response.stepCompleted=='2'&&response.role=='vendor'){
                  await saveLogin(response.role,response.token);
                  Navigator.push(
                    navigatorKey.currentContext!,
                    MaterialPageRoute(
                      builder: (_) => SetAvailabilityScreen(false),
                    ),
                  );
                }else if(response.stepCompleted=='3'&&response.role=='vendor'){
                  await saveLogin(response.role,response.token);
                  Navigator.push(
                    navigatorKey.currentContext!,
                    MaterialPageRoute(
                      builder: (_) => IdentityVerificationScreen(isFromProfile: false,),
                    ),
                  );
                }

          else {
            loginWithSaveTokenRedirection(
                response.role, response.token);
          }
        }

        notifyListeners();
      } else {
        errorMessage =
            response.message ?? "Login failed. Please try again.";
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      isLoading = false;

      if (e.code == 'invalid-verification-code') {
        errorMessage = "Invalid OTP. Please try again.";
      } else if (e.code == 'session-expired') {
        errorMessage = "OTP expired. Please request again.";
      } else {
        errorMessage = e.message ?? "Verification failed.";
      }

      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Something went wrong. Please try again.";
      notifyListeners();
    }
  }




  Future<void> saveLogin(String? role,String? token)async {
    if(role==null||token==null){
      return;
    }
    await UserPreference.isLoggedIn(true);
    await UserPreference.saveAccessToken(token);
    await UserPreference.saveRole(role);
  }

  Future<void> loginWithSaveTokenRedirection(String? role,String? token) async {
    if(role==null||token==null){
      return;
    }
    await saveLogin(role,token);
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

  Future<verifyOtp> verificationUser(Map<String, dynamic> data) async {
    try {
      dynamic response = await _apiService.postApiWithoutToken(
        data,
        AppUrls.verificationFirebase,
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

  // Clear error message
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  // Clear OTP field
  void clearOtp() {
    otpController.clear();
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }
}