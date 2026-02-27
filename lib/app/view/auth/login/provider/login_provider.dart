import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/core/device%20info/datainfoservices.dart';
import 'package:ozi/app/core/push%20notification/push_notification.dart';
import 'package:ozi/app/data/repository/repository.dart';
import 'package:ozi/app/data/storage/user_preference.dart';
import 'package:ozi/app/modules/auth/vendor/signup/view/identity_verification_screen.dart';
import 'package:ozi/app/modules/auth/vendor/signup/view/set_availability.dart';
import 'package:ozi/app/modules/user/navigation%20tab/view/navigation_tab_screen.dart';
import 'package:ozi/app/modules/vendor/navigation%20tab/view/vendor_navigation_tab_screen.dart';
import 'package:ozi/app/shared/widgets/customoverlayloader.dart';
import 'package:ozi/app/view/user_role/choose_your_role/view/choose_role.dart';
import 'dart:convert';
import '../../../../core/constants/app_urls.dart';
import '../../../../data/Exception/app_exceptions.dart';
import '../../../../data/models/otp_session.dart';
import '../model/login_model.dart';
import '../../../../modules/auth/vendor/signup/view/service_category.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  LoginModel? _loginResponse;
  Repository _repository = Repository();

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
    '236': {
      'length': 8,
      'name': 'Central African Republic',
    }, // Central African Republic
    '237': {'length': 9, 'name': 'Cameroon'}, // Cameroon
    '238': {'length': 7, 'name': 'Cape Verde'}, // Cape Verde
    '239': {
      'length': 7,
      'name': 'Sao Tome and Principe',
    }, // Sao Tome and Principe
    '240': {'length': 9, 'name': 'Equatorial Guinea'}, // Equatorial Guinea
    '241': {'length': 7, 'name': 'Gabon'}, // Gabon
    '242': {'length': 9, 'name': 'Congo'}, // Congo
    '243': {'length': 9, 'name': 'DR Congo'}, // DR Congo
    '244': {'length': 9, 'name': 'Angola'}, // Angola
    '245': {'length': 9, 'name': 'Guinea-Bissau'}, // Guinea-Bissau
    '246': {
      'length': 7,
      'name': 'British Indian Ocean Territory',
    }, // British Indian Ocean Territory
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
    '387': {
      'length': 8,
      'name': 'Bosnia and Herzegovina',
    }, // Bosnia and Herzegovina
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
    '508': {
      'length': 6,
      'name': 'Saint Pierre and Miquelon',
    }, // Saint Pierre and Miquelon
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
    '599': {
      'length': 7,
      'name': 'Netherlands Antilles',
    }, // Netherlands Antilles
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

  String? _loginErrorInvalidCredentialsMessage;

  String? get loginErrorInvalidCredentialsMessage =>
      _loginErrorInvalidCredentialsMessage;

  setloginErrorInvalidCredentialsMessage(String? value) {
    _loginErrorInvalidCredentialsMessage = value;
    notifyListeners();
  }

  String? _emailNotFoundMessage;

  String? get emailNotFoundMessage => _emailNotFoundMessage;

  setEmailNotFoundMessage(String? value) {
    _emailNotFoundMessage = value;
    notifyListeners();
  }

  int getExpectedPhoneLength(String countryCode) {
    final config = countryPhoneConfig[countryCode];
    return config?['length'] ?? 10; // Default to 10 if not found
  }

  // Get country name for a country code
  String getCountryName(String countryCode) {
    final config = countryPhoneConfig[countryCode];
    return config?['name'] ?? 'Unknown';
  }

  // Validate phone number based on country code
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

    return null;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId = '';
  String? errorMessageFirebase;
  OtpSession? _otpSession;

  OtpSession? get otpSession => _otpSession;


  Future<bool> sendOtp(String phone) async {
    final Completer<bool> completer = Completer();

    notifyListeners();
    print("inside send otp 1");

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await _auth.signInWithCredential(credential);
        } catch (_) {}
      },

      verificationFailed: (FirebaseAuthException e) {
        _isLoading = false;
        errorMessageFirebase = mapFirebaseError(e, flow: AuthFlowType.sendOtp);
        notifyListeners();
        completer.complete(false);
      },

      codeSent: (String verId, int? resendToken) {
        verificationId = verId;

        // Create OTP session (60s expiry)
        _otpSession = OtpSession(
          verificationId: verId,
          sentAt: DateTime.now(),
          validFor: const Duration(seconds: 60),
        );

        _isLoading = false;
        notifyListeners();
        completer.complete(true);
      },

      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
    print("inside send otp 1");

    return completer.future;
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      CustomOverlayLoader.show(context);

      final GoogleSignIn signIn = GoogleSignIn.instance;

      // Optional: If not initialized globally in main.dart, do it here
      // await signIn.initialize(serverClientId: 'your-server-client-id-if-using-backend');

      final GoogleSignInAccount? googleUser = await signIn.authenticate(
        scopeHint: ['email', 'profile'], // or add more scopes if needed
      );

      if (googleUser == null) {
        CustomOverlayLoader.hide();
        return; // User canceled
      }
      String displayName = googleUser.displayName ?? '';
      String firstName = '';
      String lastName = '';

      if (displayName.isNotEmpty) {
        List<String> nameParts = displayName.split(' ');
        firstName = nameParts.first;
        lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      debugPrint(
        'Google user ID: ${googleUser.id} & Google idToken: ${googleAuth.idToken}',
      );
      if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
        Get.showToast(
          'Failed to retrieve Google ID token',
          type: ToastType.error,
        );
        CustomOverlayLoader.hide();
        return;
      }

      debugPrint(
        'Google idToken (prefix): ${googleAuth.idToken!.substring(0, 20)}...',
      );

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final timing = await userCredential.user?.getIdTokenResult();
      print("token expire timing ${timing?.issuedAtTime}");
      final issuedAt = timing?.issuedAtTime;

      if (issuedAt != null) {
        final utcDateTime = issuedAt.toUtc();

        print("Token issued at (UTC): ${utcDateTime.toIso8601String()}");

        final formatter = DateFormat("yyyy-MM-dd HH:mm:ss 'UTC'");
        print("Token issued at (UTC): ${formatter.format(utcDateTime)}");

        final expiresAt = utcDateTime.add(const Duration(hours: 1));
        print("Token expires at (UTC): ${formatter.format(expiresAt)}");
      }

      final String? firebaseIdToken = await userCredential.user?.getIdToken();

      if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
        Get.showToast('Failed to get Firebase ID token', type: ToastType.error);
        CustomOverlayLoader.hide();
        return;
      }

      debugPrint(
        'Firebase ID token (prefix): ${firebaseIdToken.substring(0, 20)}...',
      );

      await socialLoginApi(
        navigatorKey.currentContext!,
        firebaseIdToken,
        googleUser.id,
        issuedAt.toString(),
        firstName,
        lastName,
        googleUser.email,
      );

      CustomOverlayLoader.hide();
    } on FirebaseAuthException catch (e) {
      CustomOverlayLoader.hide();
      String msg = 'Firebase login failed: ${e.message ?? e.code}';
      if (e.code == 'account-exists-with-different-credential') {
        msg = 'Account exists with another sign-in method';
      } else if (e.code == 'invalid-credential') {
        msg = 'Invalid Google credential – check Firebase/Google config';
      }
      debugPrint('FirebaseAuthException: $e');
      Get.showToast(msg, type: ToastType.error);
    } on GoogleSignInException catch (e) {
      CustomOverlayLoader.hide();
      if (e.code == GoogleSignInExceptionCode.canceled) return;
      debugPrint('GoogleSignInException: ${e.code} – ${e.description}');
      Get.showToast('Google Sign-In canceled or failed', type: ToastType.error);
    } on PlatformException catch (e) {
      CustomOverlayLoader.hide();
      debugPrint('PlatformException: $e');
      Get.showToast(
        'Sign-in error – check Firebase/Google setup',
        type: ToastType.error,
      );
    } catch (e) {
      CustomOverlayLoader.hide();
      debugPrint('Unexpected error: $e');
      Get.showToast('Login failed. Please try again.', type: ToastType.error);
    }
  }

  //using
  // Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     CustomOverlayLoader.show(context);

  //     final GoogleSignIn signIn = GoogleSignIn.instance; // It's now a singleton

  //     // If you didn't initialize globally  in main.dart, do it here (but prefer main)
  //     // await signIn.initialize(serverClientId: '...');

  //     // Use authenticate() — it throws on cancel/error instead of returning null
  //     final GoogleSignInAccount? googleUser = await signIn.authenticate(
  //       scopeHint: ['email', 'profile'], // Optional, but good to include
  //     );

  //     if (googleUser == null) {
  //       CustomOverlayLoader.hide();
  //       return;
  //     }

  //     // Get the authentication details (idToken only!)
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     debugPrint('Google user ID: ${googleUser.id}');
  //     debugPrint(
  //       'idToken: ${googleAuth.idToken}',
  //     ); // ← This MUST be a long string like "eyJhbGciOi... . payload . signature"

  //     if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
  //       Get.showToast(
  //         'Failed to retrieve Google ID token',
  //         type: ToastType.error,
  //       );
  //       CustomOverlayLoader.hide();
  //       return;
  //     }

  //     // Send the REAL idToken (JWT) to your backend
  //     await socialLoginApi(
  //       navigatorKey.currentContext!,
  //       googleAuth.idToken!,
  //       googleUser.id,
  //     );

  //     CustomOverlayLoader.hide();
  //   } on GoogleSignInException catch (e) {
  //     CustomOverlayLoader.hide();
  //     if (e.code == GoogleSignInExceptionCode.canceled) {
  //       return;
  //     }
  //     debugPrint('Google Sign-In error: ${e.code} – ${e.description}');
  //     Get.showToast(
  //       'Google Sign-In failed: ${e.description ?? "Unknown"}',
  //       type: ToastType.error,
  //     );
  //   } on PlatformException catch (e) {
  //     CustomOverlayLoader.hide();
  //     debugPrint('Platform error: ${e.message}');
  //     Get.showToast(
  //       'Google Sign-In failed. Check configuration.',
  //       type: ToastType.error,
  //     );
  //   } catch (e) {
  //     CustomOverlayLoader.hide();
  //     debugPrint('Unexpected error: $e');
  //     Get.showToast('Login failed. Please try again.', type: ToastType.error);
  //   }
  // }

  bool _isLoader = false;

  bool get isLoader => _isLoader;

  updateLoading(bool value) {
    _isLoader = value;
    notifyListeners();
  }

  Future<void> socialLoginApi(
    BuildContext context,
    String idToken,
    String googleId,
    String utcTime,
    String firstName,
    String lastName,
    String email,
  ) async {
    updateLoading(true);

    try {
      String deviceName = await DeviceIdService.getDeviceName();

      final value = await _repository.socialLoginApi({
        "id_token": idToken,
        "device_name": deviceName,
        "device_type": Platform.isAndroid ? "android" : "ios",
        "fcm_token": PushNotificationService.fcmToken ?? "",
        "google_id": googleId,
        "utc_time": utcTime,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
      });

      // Only interact with context if widget is still mounted
      if (context.mounted) {
        if (value['status'] == true) {
          await UserPreference.saveToken(value['accessToken']);
          await UserPreference.saveUserId(value['user']['id']);
          await UserPreference.saveRefreshToken(value['user']['refreshToken']);
          await UserPreference.saveLoginStatus(true);
          if (navigatorKey.currentContext!.mounted) {
            if (value['stepCompleted'] == '0') {
              Navigator.pushReplacement(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                  builder: (_) => ChooseRoleScreen(userId: value['user']['id']),
                ),
              );
            }
            // else if (value['stepCompleted'] == '1'){
            //
            // }
            else if (value['stepCompleted'] == '1' &&
                value['role'] == 'vendor') {
              await saveLogin(value['role'], value['token']);
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => ServiceCategory()),
              );
            } else if (value['stepCompleted'] == '2' &&
                value['role'] == 'vendor') {
              await saveLogin(value['role'], value['token']);
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => SetAvailabilityScreen(false)),
              );
            } else if (value['stepCompleted'] == '3' &&
                value['role'] == 'vendor') {
              await saveLogin(value['role'], value['token']);
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                  builder: (_) =>
                      IdentityVerificationScreen(isFromProfile: false),
                ),
              );
            }

            Get.showToast(
              value['message']?.toString() ?? 'Login Successfully',
              type: ToastType.success,
            );

            // if (value['user']['is_profile_completed'] == true) {
            //   Get.offAllNamed(Routes.home);
            // } else {
            //   Get.offAllNamed(Routes.completeProfile);
            // }
          } else {
            Get.showToast(
              value['message']?.toString() ?? 'Failed to login',
              type: ToastType.error,
            );
          }
        }
      }
    } catch (error) {
      if (context.mounted) {
        if (error.toString() == 'Invalid credentials.') {
          setloginErrorInvalidCredentialsMessage(error.toString());
        } else if (error.toString() == 'Email not found.') {
          setEmailNotFoundMessage(error.toString());
        } else {
          Get.showToast(error.toString(), type: ToastType.error);
        }
      }

      Get.consoleLog(error.toString(), "error while COMPLETE PROFILE");
    } finally {
      updateLoading(false);
    }
  }

  Future<void> saveLogin(String? role, String? token) async {
    if (role == null || token == null) {
      return;
    }
    await UserPreference.isLoggedIn(true);
    await UserPreference.saveAccessToken(token);
    await UserPreference.saveRole(role);
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
