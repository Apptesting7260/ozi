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
      return "Invalid phone number.";

    case 'missing-phone-number':
      return "Phone number is required.";

  // OTP VERIFICATION ERRORS

    case 'invalid-verification-code':
      return "Incorrect OTP.";

    case 'session-expired':
      return "OTP expired after $otpTimeoutSeconds seconds. Request a new one.";

    case 'invalid-verification-id':
      return "Session expired. Request a new OTP.";

  // RATE LIMIT / TEMP BLOCK

    case 'too-many-requests':
      return "Too many attempts. Temporarily restricted. Try again later.";

    case 'quota-exceeded':
      return "OTP limit reached. Try again later.";

  // SYSTEM / NETWORK

    case 'network-request-failed':
      return "No internet connection.";

    case 'app-not-authorized':
      return "Authentication not allowed.";

    case 'captcha-check-failed':
      return "Verification failed. Try again.";

  // DEFAULT (FLOW AWARE)

    default:
      switch (flow) {
        case AuthFlowType.sendOtp:
          return "Failed to send OTP. Try again.";
        case AuthFlowType.verifyOtp:
          return "OTP verification failed. Try again.";
        case AuthFlowType.resendOtp:
          return "Failed to resend OTP. Try again.";
      }
  }
}