import 'package:firebase_auth/firebase_auth.dart';

import '../../core/appExports/app_export.dart';
import '../../routes/app_routes.dart';
import '../storage/user_preference.dart';

class AppExceptions implements Exception {
  final String? _message;
  final String? _prefix;

  AppExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? message]) : super(message, '');
}

class UnauthenticatedException extends AppExceptions {
  UnauthenticatedException([String? message])
      : super(message, "Token has been invalidated. Please login again.") {
    

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleLogout();
    });
  }

  void _handleLogout() async {
    await UserPreference.clearSharedPreference();

    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (route) => false,
      );
    }
  }
}

enum AuthFlowType {
  sendOtp,
  verifyOtp,
  resendOtp,
}

String mapFirebaseError(
    FirebaseAuthException e, {
      required AuthFlowType flow,
      int otpTimeoutSeconds = 60,
    }) {
  switch (e.code) {

  // PHONE INPUT ERRORS

    case 'invalid-phone-number':
      return "Please enter a valid phone number.";

    case 'missing-phone-number':
      return "Phone number is required.";

  // OTP VERIFICATION ERRORS

    case 'invalid-verification-code':
      return "The OTP you entered is incorrect.";

    case 'session-expired':
      return "OTP expired after $otpTimeoutSeconds seconds. Please request a new one.";

    case 'invalid-verification-id':
      return "Session expired. Please request a new OTP.";

    case 'code-expired':
      return "OTP has expired. Please request a new one.";

  // RATE LIMIT / TEMP BLOCK

    case 'too-many-requests':
      return "Too many attempts. Please try again later.";

    case 'quota-exceeded':
      return "OTP request limit reached. Please try again later.";

    case 'captcha-check-failed':
      return "Verification failed. Please try again.";

  // NETWORK / SYSTEM

    case 'network-request-failed':
      return "No internet connection. Please check your network.";

    case 'app-not-authorized':
      return "Authentication service is not available right now.";

    case 'internal-error':
      return "Something went wrong. Please try again.";

    case 'invalid-app-credential':
      return "App verification failed. Please restart the app.";

    case 'missing-verification-code':
      return "Please enter the OTP code.";

    case 'missing-verification-id':
      return "Verification session expired. Please request a new OTP.";

  // DEFAULT FLOW AWARE MESSAGE

    default:
      return _defaultFlowMessage(flow);
  }
}

String _defaultFlowMessage(AuthFlowType flow) {
  switch (flow) {
    case AuthFlowType.sendOtp:
      return "Failed to send OTP. Please try again.";

    case AuthFlowType.verifyOtp:
      return "OTP verification failed. Please try again.";

    case AuthFlowType.resendOtp:
      return "Failed to resend OTP. Please try again.";
  }
}