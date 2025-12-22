import 'package:ozi/shared/widgets/custom_button.dart';
import '../../../../core/appExports/app_export.dart';
import 'package:country_picker/country_picker.dart';

import '../../../navigation tab/view/navigation_tab_screen.dart';
import '../../verification_screen/view/VerificationScreen.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
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
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "9876543210",
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VerificationScreen(phone: "+1 Phone Number"),
                    ),
                  );
                },
              ),

              hBox(14),

              CustomButton(
                text: "Skip",
                textStyle: AppFontStyle.text_14_600(AppColors.black, fontFamily: AppFontFamily.semiBold),
                color: AppColors.lightGrey2,
                isOutlined: true,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => NavigationTabScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
