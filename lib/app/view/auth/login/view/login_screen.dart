import '../../../../core/appExports/app_export.dart';
import '../../../../modules/user/navigation tab/view/navigation_tab_screen.dart';
import '../../verification_screen/view/verification_screen.dart';
import '../provider/login_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Country? _selectedCountry;
  final TextEditingController _phoneController = TextEditingController();
  int _maxPhoneLength = 10; // Default max length

  @override
  void initState() {
    super.initState();
    _selectedCountry = Country.parse('IN'); // Set default immediately
    _loadInitialCountry();
    _updateMaxPhoneLength();
  }

  Future<void> _loadInitialCountry() async {
    try {
      // 1. Try to get from device locale first (fast and no permission needed)
      final Locale deviceLocale =
          WidgetsBinding.instance.platformDispatcher.locale;
      final String? deviceCountryCode = deviceLocale.countryCode;

      if (deviceCountryCode != null) {
        try {
          final country = Country.parse(deviceCountryCode);
          setState(() {
            _selectedCountry = country;
            _updateMaxPhoneLength();
          });
        } catch (_) {}
      }

      // 2. Request accurate location from GPS
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      // If we have permission, get the actual position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 5),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && placemarks.first.isoCountryCode != null) {
        final String? locCountryCode = placemarks.first.isoCountryCode;
        if (locCountryCode != null) {
          try {
            final country = Country.parse(locCountryCode);
            setState(() {
              _selectedCountry = country;
              _updateMaxPhoneLength();
            });
          } catch (_) {}
        }
      }
    } catch (e) {
      debugPrint("Error detecting country: $e");
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Update max phone length based on selected country
  void _updateMaxPhoneLength() {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    setState(() {
      _maxPhoneLength = loginProvider.getExpectedPhoneLength(
        _selectedCountry?.phoneCode ?? '91',
      );
    });
  }

  void _handleContinue() async {
    if (kDebugMode) {
      print("Button pressed");
    }
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    if (loginProvider.isLoading) return;

    loginProvider.clearError();

    // Validate phone number (provider will validate length based on country)
    final phoneNumber = _phoneController.text.trim();
    final countryCode = _selectedCountry?.phoneCode ?? '91';

    final validationError = loginProvider.validatePhoneNumber(
      phoneNumber,
      countryCode,
    );

    if (validationError != null) {
      // _showSnackBar(validationError);
      Get.showToast(validationError, type: ToastType.warning);
      return;
    }

    final success = await loginProvider.handleContinue(
      context,
      phoneNumber,
      countryCode,
    );

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerificationScreen(
            phone: "$phoneNumber",
            countryCode: countryCode,
            verificationId: loginProvider.verificationId,
          ),
        ),
      );
    } else {
      if (!success && mounted) {
        if (kDebugMode) {

          print("object");
        }
        if (loginProvider.restoreCancelled) return;
        Get.showToast(
          loginProvider.errorMessageFirebase ??
              "Failed to send OTP. Please try again.",
          type: ToastType.warning,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginProvider>(
        builder: (context, loginProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back!",
                    style: AppFontStyle.text_30_600(
                      AppColors.darkText,
                      fontFamily: AppFontFamily.extraBold,
                    ),
                  ),

                  hBox(10),

                  Text(
                    maxLines: 2,
                    "Please enter your mobile number to proceed.",
                    style: AppFontStyle.text_16_400(
                      AppColors.grey,
                      fontFamily: AppFontFamily.regular,
                    ),
                  ),

                  hBox(30),

                  Text(
                    "Phone Number",
                    style: AppFontStyle.text_16_600(
                      AppColors.darkText,
                      fontFamily: AppFontFamily.semiBold,
                    ),
                  ),

                  hBox(12),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: loginProvider.isLoading
                              ? null
                              : () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: true,
                                    onSelect: (Country country) {
                                      setState(() {
                                        _selectedCountry = country;
                                        // _phoneController.clear();
                                        _updateMaxPhoneLength();
                                      });
                                    },
                                  );
                                },
                          child: Row(
                            children: [
                              Text(
                                "+${_selectedCountry?.phoneCode}",
                                style: AppFontStyle.text_16_600(
                                  AppColors.darkText,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down, size: 20),
                            ],
                          ),
                        ),

                        wBox(14),

                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            enabled: !loginProvider.isLoading,
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // Only digits
                              LengthLimitingTextInputFormatter(
                                _maxPhoneLength,
                              ), // Limit length
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  "Phone Number ($_maxPhoneLength digits)",
                              hintStyle: AppFontStyle.text_16_400(
                                AppColors.grey,
                              ),
                              counterText: "", // Hide default counter
                            ),
                            style: AppFontStyle.text_16_400(AppColors.darkText),
                            onChanged: (value) {
                              // Optional: Show real-time validation
                              if (value.length == _maxPhoneLength) {
                                // Valid length reached
                                if (kDebugMode) {
                                  print('✅ Valid phone number length');
                                }
                              }
                            },
                          ),
                        ),

                        // Show digit counter
                        if (_phoneController.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            // child: Text(
                            //   "${_phoneController.text.length}/$_maxPhoneLength",
                            //   style: AppFontStyle.text_12_400(
                            //     _phoneController.text.length == _maxPhoneLength
                            //         ? Colors.green
                            //         : AppColors.grey,
                            //   ),
                            // ),
                          ),
                      ],
                    ),
                  ),

                  hBox(8),

                  // Helper text showing expected format
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Enter exactly $_maxPhoneLength digits for ${loginProvider.getCountryName(_selectedCountry?.phoneCode ?? '91')}",
                      style: AppFontStyle.text_12_400(
                        AppColors.grey,
                        fontFamily: AppFontFamily.regular,
                      ),
                    ),
                  ),

                  hBox(16),

                  CustomButton(
                    text: "Continue",
                    isLoading: loginProvider.isLoading,
                    onPressed: _handleContinue,
                  ),

                  hBox(14),

                  CustomButton(
                    text: "Skip",
                    textStyle: AppFontStyle.text_14_600(
                      AppColors.black,
                      fontFamily: AppFontFamily.semiBold,
                    ),
                    color: AppColors.lightGrey2,
                    isOutlined: true,
                    onPressed: () {
                      Navigator.push(
                        navigatorKey.currentContext!,
                        MaterialPageRoute(
                          builder: (_) => NavigationTabScreen(),
                        ),
                      );
                    },
                  ),

                  hBox(35),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.lightGrey2.withValues(alpha: 0.5),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Or continue with",
                          style: AppFontStyle.text_14_400(
                            AppColors.grey,
                            fontFamily: AppFontFamily.regular,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.lightGrey2.withValues(alpha: 0.5),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  hBox(35),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton(
                        imagePath: "assets/images/Google.png",
                        onTap: () {
                          if (kDebugMode) {
                            print("click on google");
                          }
                          loginProvider.signInWithGoogle(context);
                        },
                      ),
                      wBox(20),
                      _socialButton(
                        imagePath: "assets/images/gg--facebook 1.png",
                        onTap: () {
                          // Handle Facebook login
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _socialButton({
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 56.h,
        width: 56.h,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(16),
        child: CustomImage(
          path: imagePath,
          fit: BoxFit.contain,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}
