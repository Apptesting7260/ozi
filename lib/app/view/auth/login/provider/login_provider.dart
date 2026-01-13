import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/constants/app_urls.dart';
import '../model/login_model.dart';


class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  LoginModel? _loginResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginModel? get loginResponse => _loginResponse;

  Future<bool> sendOtp({
    required String phoneNumber,
    required String countryCode,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse(AppUrls.login);

      final requestBody = {
        'mobile': phoneNumber,
        'country_code': countryCode,
      };

      print('🔵 Sending OTP request to: $url');
      print('📤 Request body: ${json.encode(requestBody)}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'OziService-App',
        },
        body: json.encode(requestBody),
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please check your internet connection.');
        },
      );

      print('📥 Response status code: ${response.statusCode}');
      print('📥 Response body: ${response.body}');
      print('📥 Response headers: ${response.headers}');

      // Handle different status codes
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final responseData = json.decode(response.body);
          _loginResponse = LoginModel.fromJson(responseData);

          _isLoading = false;

          if (_loginResponse?.status == true) {
            print('✅ OTP sent successfully');
            notifyListeners();
            return true;
          } else {
            _errorMessage = _loginResponse?.message ?? 'Failed to send OTP';
            print('❌ API returned false status: $_errorMessage');
            notifyListeners();
            return false;
          }
        } catch (e) {
          _isLoading = false;
          _errorMessage = 'Invalid response format from server';
          print('❌ JSON parsing error: $e');
          notifyListeners();
          return false;
        }
      } else if (response.statusCode == 302) {
        // Handle redirect - this is the issue you're facing
        _isLoading = false;
        _errorMessage = 'Server configuration issue. Please contact support.';
        print('❌ 302 Redirect detected. Location: ${response.headers['location']}');
        notifyListeners();
        return false;
      } else if (response.statusCode == 400) {
        _isLoading = false;
        try {
          final responseData = json.decode(response.body);
          _errorMessage = responseData['message'] ?? 'Invalid phone number or country code';
        } catch (e) {
          _errorMessage = 'Invalid request';
        }
        print('❌ Bad request: $_errorMessage');
        notifyListeners();
        return false;
      } else if (response.statusCode == 401) {
        _isLoading = false;
        _errorMessage = 'Unauthorized access';
        print('❌ 401 Unauthorized');
        notifyListeners();
        return false;
      } else if (response.statusCode == 422) {
        _isLoading = false;
        try {
          final responseData = json.decode(response.body);
          _errorMessage = responseData['message'] ?? 'Validation error';
        } catch (e) {
          _errorMessage = 'Validation error';
        }
        print('❌ Validation error: $_errorMessage');
        notifyListeners();
        return false;
      } else if (response.statusCode == 500) {
        _isLoading = false;
        _errorMessage = 'Server error. Please try again later.';
        print('❌ 500 Server error');
        notifyListeners();
        return false;
      } else {
        _isLoading = false;
        _errorMessage = 'Error ${response.statusCode}: ${response.reasonPhrase}';
        print('❌ Unexpected status code: ${response.statusCode}');
        notifyListeners();
        return false;
      }
    } on http.ClientException catch (e) {
      _isLoading = false;
      _errorMessage = 'Network error. Please check your internet connection.';
      print('❌ ClientException: $e');
      notifyListeners();
      return false;
    } on FormatException catch (e) {
      _isLoading = false;
      _errorMessage = 'Invalid response from server';
      print('❌ FormatException: $e');
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Something went wrong. Please try again.';
      print('❌ General Exception: $e');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _loginResponse = null;
    notifyListeners();
  }
}
