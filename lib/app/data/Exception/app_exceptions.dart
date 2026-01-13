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