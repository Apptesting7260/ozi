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

  @override
  void initState() {
    super.initState();
    _selectedCountry = Country.parse('IN');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleContinue() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Prevent action if already loading
    if (loginProvider.isLoading) return;

    // Validate phone number
    if (_phoneController.text.trim().isEmpty) {
      _showSnackBar('Please enter phone number');
      return;
    }

    if (_phoneController.text.trim().length < 10) {
      _showSnackBar('Please enter a valid phone number');
      return;
    }

    // Send OTP
    final success = await loginProvider.sendOtp(
      phoneNumber: _phoneController.text.trim(),
      countryCode: '+${_selectedCountry?.phoneCode ?? '91'}',
    );

    if (success) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationScreen(
              phone: "+${_selectedCountry?.phoneCode} ${_phoneController.text.trim()}",
            ),
          ),
        );
      }
    } else {
      // Show error message
      if (mounted) {
        _showSnackBar(loginProvider.errorMessage ?? 'Failed to send OTP');
      }
    }
  }

  void _handleSkip() {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Prevent action if loading
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
                              setState(() => _selectedCountry = country);
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone Number",
                            hintStyle: AppFontStyle.text_16_400(AppColors.grey),
                          ),
                          style: AppFontStyle.text_16_400(AppColors.darkText),
                        ),
                      ),
                    ],
                  ),
                ),

                hBox(24),

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
          );
        },
      ),
    );
  }
}