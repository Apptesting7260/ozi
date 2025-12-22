import 'package:ozi/features/user_role/choose_your_role/view/choose_role.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/appExports/app_export.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../provider/VerificationProvider.dart';


class VerificationScreen extends StatelessWidget {
  final String phone;

  const VerificationScreen({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = VerificationProvider();
        provider.startTimer();
        return provider;
      },
      child: VerificationContent(phone: phone),
    );
  }
}

class VerificationContent extends StatelessWidget {
  final String phone;

  const VerificationContent({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VerificationProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding:  EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 20),
                ),
              ),

              hBox(20),

              Text(
                "Verification Code",
                style: AppFontStyle.text_28_600(
                  AppColors.darkText,
                  fontFamily: AppFontFamily.extraBold,
                ),
              ),

              hBox(10),
              Text(
                "Please enter the verification code sent to",
                style: AppFontStyle.text_16_400(AppColors.grey),
              ),

              Text(
                "$phone",
                style: AppFontStyle.text_16_600(
                  AppColors.darkText,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
              hBox(30),


              Text(
                "Verification Code",
                style: AppFontStyle.text_16_600(
                  AppColors.darkText,
                  fontFamily: AppFontFamily.semiBold,
                ),
              ),
              hBox(10),

              PinCodeTextField(
                appContext: context,
                controller: provider.otpController,
                length: 6,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,

                enableActiveFill: true,

                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.circle,

                  fieldHeight: 55,
                  fieldWidth: 55,

                  inactiveColor: Colors.transparent,
                  selectedColor: Colors.transparent,
                  activeColor: Colors.transparent,

                  // ALWAYS SAME FILL COLOR
                  inactiveFillColor: AppColors.grey.withValues(alpha: 0.3),
                  selectedFillColor: AppColors.grey.withValues(alpha: 0.3),
                  activeFillColor: AppColors.grey.withValues(alpha: 0.3),

                  borderWidth: 0,
                ),

                onChanged: (value) {},
              ),

              hBox(10),
              CustomButton(
                text: "Verify",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChooseRoleScreen(),
                      ),
                  );
                },
              ),

              hBox(20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code? ",
                    style: AppFontStyle.text_14_400(AppColors.grey),
                  ),
                  Text(
                    provider.resendTime > 0
                        ? "Resend in ${provider.resendTime} s"
                        : "Resend now",
                    style: AppFontStyle.text_14_600(AppColors.darkText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
