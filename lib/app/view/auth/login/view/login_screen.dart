import 'package:flutter/services.dart';
import 'package:ozi/app/view/user_role/choose_your_role/view/choose_role.dart';
import '../../../../core/appExports/app_export.dart';
import '../../verification_screen/view/verification_screen.dart';
import '../provider/login_provider.dart';

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
    _selectedCountry = Country.parse('IN');
    _updateMaxPhoneLength();
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
      _showSnackBar(validationError);
      return;
    }

    // Send OTP
    final success = await loginProvider.sendOtp(
      phoneNumber: phoneNumber,
      countryCode: '+$countryCode',
    );

    if (success) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationScreen(
              phone: "+$countryCode $phoneNumber",
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        _showSnackBar(loginProvider.errorMessage ?? 'Failed to send OTP');
      }
    }
  }

  void _handleSkip() {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    if (loginProvider.isLoading) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChooseRoleScreen(),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
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
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
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
                                  _phoneController.clear();
                                  _updateMaxPhoneLength();
                                });
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "+${_selectedCountry?.phoneCode}",
                                style: AppFontStyle.text_16_600(AppColors.darkText),
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
                              FilteringTextInputFormatter.digitsOnly, // Only digits
                              LengthLimitingTextInputFormatter(_maxPhoneLength), // Limit length
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone Number ($_maxPhoneLength digits)",
                              hintStyle: AppFontStyle.text_16_400(AppColors.grey),
                              counterText: "", // Hide default counter
                            ),
                            style: AppFontStyle.text_16_400(AppColors.darkText),
                            onChanged: (value) {
                              // Optional: Show real-time validation
                              if (value.length == _maxPhoneLength) {
                                // Valid length reached
                                print('✅ Valid phone number length');
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
                    onPressed: _handleSkip,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}