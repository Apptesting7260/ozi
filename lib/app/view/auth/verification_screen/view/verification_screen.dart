import 'package:ozi/app/shared/widgets/custom_app_bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/appExports/app_export.dart';
import '../../../user_role/choose_your_role/view/choose_role.dart';
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
      body: Column(
        children: [
          SafeArea(child: const CustomAppBar(title: "")),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    phone,
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
                    autoDisposeControllers: false,
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
                      inactiveFillColor: AppColors.lightGrey,
                      selectedFillColor: AppColors.lightGrey,
                      activeFillColor: AppColors.lightGrey,
                      borderWidth: 0,
                    ),
                    onChanged: (value) {
                      provider.errorMessage = null;
                    },
                  ),
                  if (provider.errorMessage != null) ...[
                    hBox(8),
                    Text(
                      provider.errorMessage!,
                      style: AppFontStyle.text_14_400(Colors.red),
                    ),
                  ],
                  hBox(16),
                  CustomButton(
                    text: provider.isLoading ? "Verifying..." : "Verify",
                    onPressed: () {
                      if (provider.isLoading) return;

                      provider.verifyOtpMethod(phone).then((success) {
                        if (success && context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChooseRoleScreen(),
                            ),
                          );
                        }
                      });
                    },
                  ),
                  hBox(24),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive code? ",
                          style: AppFontStyle.text_14_400(AppColors.grey),
                        ),
                        GestureDetector(
                          onTap: provider.resendTime > 0 || provider.isLoading
                              ? null
                              : () => provider.resendOtp(phone),
                          child: Text(
                            provider.resendTime > 0
                                ? "Resend in ${provider.resendTime}s"
                                : "Resend now",
                            style: AppFontStyle.text_14_600(
                              provider.resendTime > 0
                                  ? AppColors.grey
                                  : AppColors.darkText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}