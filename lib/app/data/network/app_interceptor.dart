import 'package:dio/dio.dart';

import '../../core/appExports/app_export.dart';
import '../../routes/app_routes.dart';
import '../storage/user_preference.dart';

class AppInterceptor extends Interceptor {


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 🔹 Get token from secure storage
    String? token = await UserPreference.returnAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    debugPrint("➡️ Request[${options.method}] => PATH: ${options.uri}");
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint("✅ Response[${response.statusCode}] => DATA: ${response.data}");
    return handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint("❌ Error[${err.response?.statusCode}] => ${err.message}");

    if (err.response?.statusCode == 401) {
      if( await UserPreference.returnAccessToken() != ''){
        await UserPreference.clearSharedPreference();
        final context = navigatorKey.currentContext;
        if (context != null && context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
                (route) => false,
          );
        }
        debugPrint("⚠️ Unauthorized! Maybe refresh token or force logout.");
      }
    }

    return handler.next(err);
  }
}