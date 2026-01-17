import 'package:dio/dio.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'dart:convert';
import 'dart:io';

import '../../core/appExports/app_export.dart';
import '../../core/utils/get_utils.dart';
import '../../routes/app_routes.dart';
import '../Exception/app_exceptions.dart';
import '../storage/user_preference.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  final Dio _dio = Dio();

  NetworkApiServices() {
    // Add Chucker as an interceptor for logging
    _dio.interceptors.add(ChuckerDioInterceptor());
  }

  Future<String?> getAccessTokenFromStorage() async {
    return await UserPreference.returnAccessToken();
  }

  @override
  Future<dynamic> getApi(String url, String token) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      return returnResponse(response, url);
    }on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<dynamic> getApiWithPerms(
      Map<String, dynamic> data, String url, String token) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: data,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      return returnResponse(response, url);
    }on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  @override
  Future<dynamic> postApi(var data, String url, String token) async {
    try {
      final response = await _dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );
      return returnResponse(response, url);
    }on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<dynamic> patchApi(var data, String url, String token) async {
    try {
      final response = await _dio.patch(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
        ),
      );
      return returnResponse(response, url);
    }on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<dynamic> patchMultipartApi(
      Map<String, String> fields,
      String url,
      String token,
      ) async {
    try {
      FormData formData = FormData.fromMap(fields);

      final response = await _dio.patch(
        url,
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      return returnResponse(response, url);
    }on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<dynamic> postApiWithoutToken(var data, String url) async {
    try {
      final response = await _dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      return returnResponse(response, url);
    }on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<dynamic> getApiWithoutToken(String url) async {
    try {
      final response = await _dio.get(
        url,
      );
      return returnResponse(response, url);
    }on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<dynamic> deleteApi(var data, String url, String token) async {
    try {
      final response = await _dio.delete(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
        ),
      );
      return returnResponse(response, url);
    }on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<dynamic> deleteApiWithoutData(String url, String token) async {
    try {
      final response = await _dio.delete(
        url,
        options: Options(
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
        ),
      );
      return returnResponse(response, url);
    }on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<dynamic> putApi(var data, String url, String token) async {
    try {
      final response = await _dio.put(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
        ),
      );
      return returnResponse(response, url);
    }on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  Future<dynamic> postApiMultiPart(
      String url,
      String token,
      Map<String, String> fields,
      Map<String, dynamic> files,
      ) async {
    try {
      FormData formData = FormData.fromMap(fields);

      files.forEach((key, value) async {
        if (value is String) {
          formData.files.add(MapEntry(key, await MultipartFile.fromFile(value)));
        } else if (value is File) {
          formData.files.add(MapEntry(key, await MultipartFile.fromFile(value.path)));
        } else {
          throw Exception("Unsupported file input type for key '$key'");
        }
      });

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      return returnResponse(response, url);
    } on DioException catch  (e) {
      return _handleDioError(e);
    }
  }

  Future<dynamic> postApiMultiPartBytes(
      String url,
      String token,
      Map<String, String> fields,
      Map<String, dynamic> files,
      ) async {
    try {
      FormData formData = FormData.fromMap(fields);

      files.forEach((key, value) async {
        if (value is Uint8List) {
          formData.files.add(MapEntry(key, MultipartFile.fromBytes(value)));
        } else if (value is File) {
          formData.files.add(MapEntry(key, await MultipartFile.fromFile(value.path)));
        } else {
          throw Exception("Unsupported file input type for key '$key'");
        }
      });

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      return returnResponse(response, url);
    }  on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  dynamic returnResponse(Response response, String url) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else if (response.statusCode == 401) {
      _handleLogout();
      throw UnauthenticatedException();
    } else {
      throw FetchDataException(response.data['message'] ?? 'Error ${response.statusCode}');
    }
  }

  dynamic returnResponseMultiPart(
      Response response, String responseBody, String url) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else if (response.statusCode == 401) {
      _handleLogout();
      throw UnauthenticatedException();
    } else {
      throw FetchDataException(
          response.data['message']?.toString() ?? 'Error ${response.statusCode}');
    }
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

  dynamic _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw Exception("Request Time Out..");
    } else if (e.type == DioExceptionType.unknown) {
      throw Exception("Internet Connection Issue..");
    } else {
      throw Exception("Something went wrong: $e");
    }
  }
}
