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

  static const Map<String, Map<String, dynamic>> countryPhoneConfig = {
    '1': {'length': 10, 'name': 'USA/Canada'}, // USA, Canada
    '7': {'length': 10, 'name': 'Russia'}, // Russia
    '20': {'length': 10, 'name': 'Egypt'}, // Egypt
    '27': {'length': 9, 'name': 'South Africa'}, // South Africa
    '30': {'length': 10, 'name': 'Greece'}, // Greece
    '31': {'length': 9, 'name': 'Netherlands'}, // Netherlands
    '32': {'length': 9, 'name': 'Belgium'}, // Belgium
    '33': {'length': 9, 'name': 'France'}, // France
    '34': {'length': 9, 'name': 'Spain'}, // Spain
    '36': {'length': 9, 'name': 'Hungary'}, // Hungary
    '39': {'length': 10, 'name': 'Italy'}, // Italy
    '40': {'length': 10, 'name': 'Romania'}, // Romania
    '41': {'length': 9, 'name': 'Switzerland'}, // Switzerland
    '43': {'length': 10, 'name': 'Austria'}, // Austria
    '44': {'length': 10, 'name': 'UK'}, // United Kingdom
    '45': {'length': 8, 'name': 'Denmark'}, // Denmark
    '46': {'length': 9, 'name': 'Sweden'}, // Sweden
    '47': {'length': 8, 'name': 'Norway'}, // Norway
    '48': {'length': 9, 'name': 'Poland'}, // Poland
    '49': {'length': 10, 'name': 'Germany'}, // Germany
    '51': {'length': 9, 'name': 'Peru'}, // Peru
    '52': {'length': 10, 'name': 'Mexico'}, // Mexico
    '53': {'length': 8, 'name': 'Cuba'}, // Cuba
    '54': {'length': 10, 'name': 'Argentina'}, // Argentina
    '55': {'length': 11, 'name': 'Brazil'}, // Brazil
    '56': {'length': 9, 'name': 'Chile'}, // Chile
    '57': {'length': 10, 'name': 'Colombia'}, // Colombia
    '58': {'length': 10, 'name': 'Venezuela'}, // Venezuela
    '60': {'length': 9, 'name': 'Malaysia'}, // Malaysia (9-10)
    '61': {'length': 9, 'name': 'Australia'}, // Australia
    '62': {'length': 10, 'name': 'Indonesia'}, // Indonesia (9-12)
    '63': {'length': 10, 'name': 'Philippines'}, // Philippines
    '64': {'length': 9, 'name': 'New Zealand'}, // New Zealand
    '65': {'length': 8, 'name': 'Singapore'}, // Singapore
    '66': {'length': 9, 'name': 'Thailand'}, // Thailand
    '81': {'length': 10, 'name': 'Japan'}, // Japan
    '82': {'length': 10, 'name': 'South Korea'}, // South Korea
    '84': {'length': 9, 'name': 'Vietnam'}, // Vietnam
    '86': {'length': 11, 'name': 'China'}, // China
    '90': {'length': 10, 'name': 'Turkey'}, // Turkey
    '91': {'length': 10, 'name': 'India'}, // India
    '92': {'length': 10, 'name': 'Pakistan'}, // Pakistan
    '93': {'length': 9, 'name': 'Afghanistan'}, // Afghanistan
    '94': {'length': 9, 'name': 'Sri Lanka'}, // Sri Lanka
    '95': {'length': 9, 'name': 'Myanmar'}, // Myanmar
    '98': {'length': 10, 'name': 'Iran'}, // Iran
    '212': {'length': 9, 'name': 'Morocco'}, // Morocco
    '213': {'length': 9, 'name': 'Algeria'}, // Algeria
    '216': {'length': 8, 'name': 'Tunisia'}, // Tunisia
    '218': {'length': 10, 'name': 'Libya'}, // Libya
    '220': {'length': 7, 'name': 'Gambia'}, // Gambia
    '221': {'length': 9, 'name': 'Senegal'}, // Senegal
    '222': {'length': 8, 'name': 'Mauritania'}, // Mauritania
    '223': {'length': 8, 'name': 'Mali'}, // Mali
    '224': {'length': 9, 'name': 'Guinea'}, // Guinea
    '225': {'length': 10, 'name': 'Ivory Coast'}, // Ivory Coast
    '226': {'length': 8, 'name': 'Burkina Faso'}, // Burkina Faso
    '227': {'length': 8, 'name': 'Niger'}, // Niger
    '228': {'length': 8, 'name': 'Togo'}, // Togo
    '229': {'length': 8, 'name': 'Benin'}, // Benin
    '230': {'length': 8, 'name': 'Mauritius'}, // Mauritius
    '231': {'length': 9, 'name': 'Liberia'}, // Liberia
    '232': {'length': 8, 'name': 'Sierra Leone'}, // Sierra Leone
    '233': {'length': 9, 'name': 'Ghana'}, // Ghana
    '234': {'length': 10, 'name': 'Nigeria'}, // Nigeria
    '235': {'length': 8, 'name': 'Chad'}, // Chad
    '236': {'length': 8, 'name': 'Central African Republic'}, // Central African Republic
    '237': {'length': 9, 'name': 'Cameroon'}, // Cameroon
    '238': {'length': 7, 'name': 'Cape Verde'}, // Cape Verde
    '239': {'length': 7, 'name': 'Sao Tome and Principe'}, // Sao Tome and Principe
    '240': {'length': 9, 'name': 'Equatorial Guinea'}, // Equatorial Guinea
    '241': {'length': 7, 'name': 'Gabon'}, // Gabon
    '242': {'length': 9, 'name': 'Congo'}, // Congo
    '243': {'length': 9, 'name': 'DR Congo'}, // DR Congo
    '244': {'length': 9, 'name': 'Angola'}, // Angola
    '245': {'length': 9, 'name': 'Guinea-Bissau'}, // Guinea-Bissau
    '246': {'length': 7, 'name': 'British Indian Ocean Territory'}, // British Indian Ocean Territory
    '247': {'length': 4, 'name': 'Ascension Island'}, // Ascension Island
    '248': {'length': 7, 'name': 'Seychelles'}, // Seychelles
    '249': {'length': 9, 'name': 'Sudan'}, // Sudan
    '250': {'length': 9, 'name': 'Rwanda'}, // Rwanda
    '251': {'length': 9, 'name': 'Ethiopia'}, // Ethiopia
    '252': {'length': 8, 'name': 'Somalia'}, // Somalia
    '253': {'length': 8, 'name': 'Djibouti'}, // Djibouti
    '254': {'length': 10, 'name': 'Kenya'}, // Kenya
    '255': {'length': 9, 'name': 'Tanzania'}, // Tanzania
    '256': {'length': 9, 'name': 'Uganda'}, // Uganda
    '257': {'length': 8, 'name': 'Burundi'}, // Burundi
    '258': {'length': 9, 'name': 'Mozambique'}, // Mozambique
    '260': {'length': 9, 'name': 'Zambia'}, // Zambia
    '261': {'length': 9, 'name': 'Madagascar'}, // Madagascar
    '262': {'length': 10, 'name': 'Reunion'}, // Reunion
    '263': {'length': 9, 'name': 'Zimbabwe'}, // Zimbabwe
    '264': {'length': 9, 'name': 'Namibia'}, // Namibia
    '265': {'length': 9, 'name': 'Malawi'}, // Malawi
    '266': {'length': 8, 'name': 'Lesotho'}, // Lesotho
    '267': {'length': 8, 'name': 'Botswana'}, // Botswana
    '268': {'length': 8, 'name': 'Swaziland'}, // Swaziland
    '269': {'length': 7, 'name': 'Comoros'}, // Comoros
    '290': {'length': 4, 'name': 'Saint Helena'}, // Saint Helena
    '291': {'length': 7, 'name': 'Eritrea'}, // Eritrea
    '297': {'length': 7, 'name': 'Aruba'}, // Aruba
    '298': {'length': 6, 'name': 'Faroe Islands'}, // Faroe Islands
    '299': {'length': 6, 'name': 'Greenland'}, // Greenland
    '350': {'length': 8, 'name': 'Gibraltar'}, // Gibraltar
    '351': {'length': 9, 'name': 'Portugal'}, // Portugal
    '352': {'length': 9, 'name': 'Luxembourg'}, // Luxembourg
    '353': {'length': 9, 'name': 'Ireland'}, // Ireland
    '354': {'length': 7, 'name': 'Iceland'}, // Iceland
    '355': {'length': 9, 'name': 'Albania'}, // Albania
    '356': {'length': 8, 'name': 'Malta'}, // Malta
    '357': {'length': 8, 'name': 'Cyprus'}, // Cyprus
    '358': {'length': 9, 'name': 'Finland'}, // Finland
    '359': {'length': 9, 'name': 'Bulgaria'}, // Bulgaria
    '370': {'length': 8, 'name': 'Lithuania'}, // Lithuania
    '371': {'length': 8, 'name': 'Latvia'}, // Latvia
    '372': {'length': 8, 'name': 'Estonia'}, // Estonia
    '373': {'length': 8, 'name': 'Moldova'}, // Moldova
    '374': {'length': 8, 'name': 'Armenia'}, // Armenia
    '375': {'length': 9, 'name': 'Belarus'}, // Belarus
    '376': {'length': 6, 'name': 'Andorra'}, // Andorra
    '377': {'length': 8, 'name': 'Monaco'}, // Monaco
    '378': {'length': 10, 'name': 'San Marino'}, // San Marino
    '380': {'length': 9, 'name': 'Ukraine'}, // Ukraine
    '381': {'length': 9, 'name': 'Serbia'}, // Serbia
    '382': {'length': 8, 'name': 'Montenegro'}, // Montenegro
    '383': {'length': 8, 'name': 'Kosovo'}, // Kosovo
    '385': {'length': 9, 'name': 'Croatia'}, // Croatia
    '386': {'length': 8, 'name': 'Slovenia'}, // Slovenia
    '387': {'length': 8, 'name': 'Bosnia and Herzegovina'}, // Bosnia and Herzegovina
    '389': {'length': 8, 'name': 'Macedonia'}, // Macedonia
    '420': {'length': 9, 'name': 'Czech Republic'}, // Czech Republic
    '421': {'length': 9, 'name': 'Slovakia'}, // Slovakia
    '423': {'length': 7, 'name': 'Liechtenstein'}, // Liechtenstein
    '500': {'length': 5, 'name': 'Falkland Islands'}, // Falkland Islands
    '501': {'length': 7, 'name': 'Belize'}, // Belize
    '502': {'length': 8, 'name': 'Guatemala'}, // Guatemala
    '503': {'length': 8, 'name': 'El Salvador'}, // El Salvador
    '504': {'length': 8, 'name': 'Honduras'}, // Honduras
    '505': {'length': 8, 'name': 'Nicaragua'}, // Nicaragua
    '506': {'length': 8, 'name': 'Costa Rica'}, // Costa Rica
    '507': {'length': 8, 'name': 'Panama'}, // Panama
    '508': {'length': 6, 'name': 'Saint Pierre and Miquelon'}, // Saint Pierre and Miquelon
    '509': {'length': 8, 'name': 'Haiti'}, // Haiti
    '590': {'length': 9, 'name': 'Guadeloupe'}, // Guadeloupe
    '591': {'length': 8, 'name': 'Bolivia'}, // Bolivia
    '592': {'length': 7, 'name': 'Guyana'}, // Guyana
    '593': {'length': 9, 'name': 'Ecuador'}, // Ecuador
    '594': {'length': 9, 'name': 'French Guiana'}, // French Guiana
    '595': {'length': 9, 'name': 'Paraguay'}, // Paraguay
    '596': {'length': 9, 'name': 'Martinique'}, // Martinique
    '597': {'length': 7, 'name': 'Suriname'}, // Suriname
    '598': {'length': 8, 'name': 'Uruguay'}, // Uruguay
    '599': {'length': 7, 'name': 'Netherlands Antilles'}, // Netherlands Antilles
    '670': {'length': 8, 'name': 'East Timor'}, // East Timor
    '672': {'length': 6, 'name': 'Antarctica'}, // Antarctica
    '673': {'length': 7, 'name': 'Brunei'}, // Brunei
    '674': {'length': 7, 'name': 'Nauru'}, // Nauru
    '675': {'length': 8, 'name': 'Papua New Guinea'}, // Papua New Guinea
    '676': {'length': 5, 'name': 'Tonga'}, // Tonga
    '677': {'length': 7, 'name': 'Solomon Islands'}, // Solomon Islands
    '678': {'length': 7, 'name': 'Vanuatu'}, // Vanuatu
    '679': {'length': 7, 'name': 'Fiji'}, // Fiji
    '680': {'length': 7, 'name': 'Palau'}, // Palau
    '681': {'length': 6, 'name': 'Wallis and Futuna'}, // Wallis and Futuna
    '682': {'length': 5, 'name': 'Cook Islands'}, // Cook Islands
    '683': {'length': 4, 'name': 'Niue'}, // Niue
    '685': {'length': 7, 'name': 'Samoa'}, // Samoa
    '686': {'length': 5, 'name': 'Kiribati'}, // Kiribati
    '687': {'length': 6, 'name': 'New Caledonia'}, // New Caledonia
    '688': {'length': 6, 'name': 'Tuvalu'}, // Tuvalu
    '689': {'length': 8, 'name': 'French Polynesia'}, // French Polynesia
    '690': {'length': 4, 'name': 'Tokelau'}, // Tokelau
    '691': {'length': 7, 'name': 'Micronesia'}, // Micronesia
    '692': {'length': 7, 'name': 'Marshall Islands'}, // Marshall Islands
    '850': {'length': 10, 'name': 'North Korea'}, // North Korea
    '852': {'length': 8, 'name': 'Hong Kong'}, // Hong Kong
    '853': {'length': 8, 'name': 'Macau'}, // Macau
    '855': {'length': 9, 'name': 'Cambodia'}, // Cambodia
    '856': {'length': 10, 'name': 'Laos'}, // Laos
    '880': {'length': 10, 'name': 'Bangladesh'}, // Bangladesh
    '886': {'length': 9, 'name': 'Taiwan'}, // Taiwan
    '960': {'length': 7, 'name': 'Maldives'}, // Maldives
    '961': {'length': 8, 'name': 'Lebanon'}, // Lebanon
    '962': {'length': 9, 'name': 'Jordan'}, // Jordan
    '963': {'length': 9, 'name': 'Syria'}, // Syria
    '964': {'length': 10, 'name': 'Iraq'}, // Iraq
    '965': {'length': 8, 'name': 'Kuwait'}, // Kuwait
    '966': {'length': 9, 'name': 'Saudi Arabia'}, // Saudi Arabia
    '967': {'length': 9, 'name': 'Yemen'}, // Yemen
    '968': {'length': 8, 'name': 'Oman'}, // Oman
    '970': {'length': 9, 'name': 'Palestine'}, // Palestine
    '971': {'length': 9, 'name': 'UAE'}, // UAE
    '972': {'length': 9, 'name': 'Israel'}, // Israel
    '973': {'length': 8, 'name': 'Bahrain'}, // Bahrain
    '974': {'length': 8, 'name': 'Qatar'}, // Qatar
    '975': {'length': 8, 'name': 'Bhutan'}, // Bhutan
    '976': {'length': 8, 'name': 'Mongolia'}, // Mongolia
    '977': {'length': 10, 'name': 'Nepal'}, // Nepal
    '992': {'length': 9, 'name': 'Tajikistan'}, // Tajikistan
    '993': {'length': 8, 'name': 'Turkmenistan'}, // Turkmenistan
    '994': {'length': 9, 'name': 'Azerbaijan'}, // Azerbaijan
    '995': {'length': 9, 'name': 'Georgia'}, // Georgia
    '996': {'length': 9, 'name': 'Kyrgyzstan'}, // Kyrgyzstan
    '998': {'length': 9, 'name': 'Uzbekistan'}, // Uzbekistan
  };

  int getExpectedPhoneLength(String countryCode) {
    final config = countryPhoneConfig[countryCode];
    return config?['length'] ?? 10; // Default to 10 if not found
  }

  /// Get country name for a country code
  String getCountryName(String countryCode) {
    final config = countryPhoneConfig[countryCode];
    return config?['name'] ?? 'Unknown';
  }

  /// Validate phone number based on country code
  String? validatePhoneNumber(String phoneNumber, String countryCode) {
    if (phoneNumber.trim().isEmpty) {
      return 'Please enter phone number';
    }

    // Remove any spaces, dashes, or special characters
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanNumber.isEmpty) {
      return 'Please enter a valid phone number';
    }

    // Check if phone number contains only digits
    if (!RegExp(r'^\d+$').hasMatch(cleanNumber)) {
      return 'Phone number should contain only digits';
    }

    final expectedLength = getExpectedPhoneLength(countryCode);
    final countryName = getCountryName(countryCode);

    if (cleanNumber.length < expectedLength) {
      return '$countryName requires $expectedLength digits. You entered ${cleanNumber.length}';
    }

    if (cleanNumber.length > expectedLength) {
      return '$countryName allows only $expectedLength digits. You entered ${cleanNumber.length}';
    }

    return null; // Valid
  }

  Future<bool> sendOtp({
    required String phoneNumber,
    required String countryCode,
  }) async {
    final cleanCountryCode = countryCode.replaceAll('+', '');

    final validationError = validatePhoneNumber(phoneNumber, cleanCountryCode);
    if (validationError != null) {
      _errorMessage = validationError;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse(AppUrls.login);

      final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

      final requestBody = {
        'mobile': cleanPhone,
        'country_code': '+$cleanCountryCode',
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