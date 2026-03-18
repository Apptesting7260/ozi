import 'package:firebase_auth/firebase_auth.dart';
import 'package:ozi/app/core/device%20info/datainfoservices.dart';
import '../../../../core/appExports/app_export.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../core/device info/get_device_Info.dart';
import '../../../../core/push notification/push_notification.dart';
import '../../../../data/Exception/app_exceptions.dart';
import '../../../../data/network/network_api_services.dart';
import '../../../../data/storage/user_preference.dart';
import '../../../../modules/auth/vendor/signup/view/identity_verification_screen.dart';
import '../../../../modules/auth/vendor/signup/view/ready_to_go_livescreen.dart';
import '../../../../modules/auth/vendor/signup/view/service_category.dart';
import '../../../../modules/auth/vendor/signup/view/set_availability.dart';
import '../../../../modules/user/navigation tab/view/navigation_tab_screen.dart';
import '../../../../modules/vendor/navigation tab/view/vendor_navigation_tab_screen.dart';
import '../../../../shared/widgets/auth_guard.dart';
import '../../../user_role/choose_your_role/view/choose_role.dart';
import '../model/verify_otp.dart';
import '../../create account/view/create_account_screen.dart';

class VerificationProvider extends ChangeNotifier {
  String verificationId;

  VerificationProvider(this.verificationId) {
    _otpSentAt = DateTime.now();
    startTimer();
  }
  final TextEditingController otpController = TextEditingController();
  final NetworkApiServices _apiService = NetworkApiServices();
  // String? token = PushNotificationService.fcmToken;
  int? _resendToken;

  int resendTime = 60;
  Timer? timer;
  bool isLoading = false;
  String? errorMessage;
  String? userId;

  void startTimer() {
    timer?.cancel();

    resendTime = otpSecondsRemaining;
    notifyListeners();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (isOtpExpired) {
        resendTime = 0;
        t.cancel();
      } else {
        resendTime = otpSecondsRemaining;
      }
      notifyListeners();
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
  //String verificationId = '';//  OTP Session
  DateTime? _otpSentAt;
  final Duration _otpValidFor = const Duration(seconds: 60);

  bool get isOtpExpired {
    if (_otpSentAt == null) return true;
    return DateTime.now().difference(_otpSentAt!) > _otpValidFor;
  }

  int get otpSecondsRemaining {
    if (_otpSentAt == null) return 0;
    final remaining = _otpValidFor - DateTime.now().difference(_otpSentAt!);
    return remaining.inSeconds > 0 ? remaining.inSeconds : 0;
  }

  Future<void> verifyOtpMethod(String phone, String countryCode) async {
    if (isLoading) return;

    if (isOtpExpired) {
      errorMessage = "OTP expired. Please resend code.";
      notifyListeners();
      return;
    }

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
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      User? user = userCredential.user;

      if (user == null) {
        if (kDebugMode) {
          print(
            "Firebase User =========================================================> $user",
          );
        }
        throw Exception("Firebase user is null");
      }
      String deviceName = await DeviceIdService.getDeviceName();
      String finalDeviceId = await DeviceIdService.getFinalUniqueId();
      // Get Firebase ID token
      String idToken = (await user.getIdToken())!;

      // String countryCode = "+91";
      // String mobile = phone;

      // if (phone.startsWith("+")) {
      //   int spaceIndex = phone.indexOf(" ");
      //   if (spaceIndex > 0) {
      //     countryCode = phone.substring(0, spaceIndex);
      //     mobile = phone.substring(spaceIndex + 1);
      //   }
      // }

      //  Prepare backend request
      Map<String, dynamic> requestData = {
        "country_code": countryCode,
        "mobile": phone,
        "fcm_token": await PushNotificationService.getToken() ?? "",
        "id_token": idToken,
        "device_name": deviceInfo["device_name"] ?? "",
        "device_type": deviceInfo["device_type"] ?? "",
        "device_id": finalDeviceId,
      };

      // Call your backend API
      VerifyOtp response = await verificationUser(requestData);

      isLoading = false;

      if (response.status == true) {
        await UserPreference.saveLoginStatus(response.isLoggedIn ?? false);
        await UserPreference.saveIsRoleSelected(
          response.isRoleSelected ?? false,
        );
        await saveLogin(response.nextStep, response.token);
        await UserPreference.saveUserId(response.userId ?? "");
        await UserPreference.saveStep(response.stepCompleted ?? "0");
        await UserPreference.saveMobile(phone);
        await UserPreference.saveIsMobileVerified(true);
        await UserPreference.saveIsDocumentVerified(
          response.isVerifiedByAdmin ?? false,
        );

        //  Debug Prints
        if (kDebugMode) {
          final savedLogin = await UserPreference.returnIsLoggedIn();
          final savedToken = await UserPreference.returnAccessToken();
          final savedRole = await UserPreference.returnRole();
          final savedStep = await UserPreference.returnStep();
          final savedUserId = await UserPreference.returnUserId();
          final savedIsRoleSelected =
              await UserPreference.returnIsRoleSelected();

          print("========== AFTER SAVE ==========");
          print("API Role: ${response.nextStep}");
          print("API Token: ${response.token}");
          print("API Step: ${response.stepCompleted}");
          print("API UserId: ${response.userId}");
          print("API IsRoleSelected: ${response.isRoleSelected}");
          print("--------------------------------");
          print("Saved isLogin: $savedLogin");
          print("Saved Role: $savedRole");
          print("Saved Token: $savedToken");
          print("Saved Step: $savedStep");
          print("Saved UserId: $savedUserId");
          print("Saved IsRoleSelected: $savedIsRoleSelected");
          print("================================");
        }

        await _auth.signOut();
        if (kDebugMode) {
          print(
            "Successfully session clear =====================> ${_auth.currentUser}",
          );
        }
        if (navigatorKey.currentContext!.mounted) {
          if (response.isRoleSelected != true) {
            Navigator.pushReplacement(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (_) => ChooseRoleScreen(
                  userId: response.userId,
                  phoneNumber: phone,
                  isMobileVerified: true,
                ),
              ),
            );
          } else if (response.stepCompleted == '0') {
            Navigator.pushReplacement(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (_) => CreateAccountScreen(
                  userId: response.userId ?? "",
                  phoneNumber: phone,
                  isMobileVerified: true,
                ),
              ),
            );
          } else if (response.stepCompleted == '1' &&
              response.role == 'vendor') {
            await saveLogin(response.role, response.token);
            Navigator.pushReplacement(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => ServiceCategory()),
            );
          } else if (response.stepCompleted == '2' &&
              response.role == 'vendor') {
            await saveLogin(response.role, response.token);
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => SetAvailabilityScreen(false)),
            );
          } else if (response.stepCompleted == '3' &&
              response.role == 'vendor') {
            await saveLogin(response.role, response.token);
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (_) =>
                    IdentityVerificationScreen(isFromProfile: false),
              ),
            );
          } else if (response.stepCompleted == '4' &&
              response.role == 'vendor' &&
              !(response.isVerifiedByAdmin ?? false)) {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => ReadyToGoLiveScreen()),
            );
          } else {
            loginWithSaveTokenRedirection(response.role, response.token);
          }
        }

        notifyListeners();
      } else {
        errorMessage = response.message ?? "Login failed. Please try again.";
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      errorMessage = mapFirebaseError(e, flow: AuthFlowType.verifyOtp);
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> saveLogin(String? role, String? token) async {
    if (role != null) {
      await UserPreference.saveRole(role);
    }

    // Save token only if available
    if (token != null) {
      await UserPreference.saveAccessToken(token);
    }

    // Always mark login true after OTP success
    await UserPreference.isLoggedIn(true);
  }

  Future<void> loginWithSaveTokenRedirection(
    String? role,
    String? token,
  ) async {
    if (role == null || token == null) {
      return;
    }
    await saveLogin(role, token);
    if (role == 'user') {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => NavigationTabScreen()),
      );
    } else if (role == 'vendor') {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => VendorNavigationTabScreen()),
      );
    }
  }

  Future<VerifyOtp> verificationUser(Map<String, dynamic> data) async {
    try {
      dynamic response = await _apiService.postApiWithoutToken(
        data,
        AppUrls.verificationFirebase,
      );
      return VerifyOtp.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> resendOtp(String phone, String countryCode) async {
    if (resendTime > 0) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      String fullPhone = "$countryCode$phone";

      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhone,
        forceResendingToken: _resendToken,
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          // Optional: Auto verify (Android only)
        },

        verificationFailed: (FirebaseAuthException e) {
          isLoading = false;
          errorMessage = mapFirebaseError(e, flow: AuthFlowType.resendOtp);
          notifyListeners();
        },

        codeSent: (String newVerificationId, int? resendToken) {
          verificationId = newVerificationId;
          _resendToken = resendToken;

          //  Reset OTP Session
          _otpSentAt = DateTime.now();

          isLoading = false;
          startTimer();
          notifyListeners();
        },

        codeAutoRetrievalTimeout: (String newVerificationId) {
          verificationId = newVerificationId;
        },
      );
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
