import 'package:ozi/app/shared/widgets/custom_app_bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/appExports/app_export.dart';
import '../provider/VerificationProvider.dart';

class VerificationScreen extends StatelessWidget {
  final String phone;
  final String verificationId;

  const VerificationScreen({
    super.key,
    required this.phone,
    required this.verificationId,
  });


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = VerificationProvider(verificationId);
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
                      maxLines: 3,
                      provider.errorMessage!,
                      style: AppFontStyle.text_14_400(Colors.red),
                    ),
                  ],
                  hBox(16),
                  CustomButton(
                    text: provider.isLoading ? "Verifying..." : "Verify",
                    onPressed: () {
                      if (provider.isLoading) return;
                      provider.verifyOtpMethod(phone);

                      if (kDebugMode) {
                        print("Error After send Otp : ${provider.errorMessage}");
                      }

                    },
                  ),
                  hBox(24),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Didn't receive code? ",
                style: AppFontStyle.text_14_400(AppColors.grey),
              ),
              Builder(
                builder: (_) {
                  final bool isLoading = provider.isLoading;
                  final bool isTimerActive = provider.resendTime > 0;
                  final bool isEnabled = !isTimerActive && !isLoading;

                  Color resendColor;

                  if (isLoading) {
                    resendColor = AppColors.grey;
                  } else if (isTimerActive) {
                    resendColor = AppColors.primary.withOpacity(0.6);
                  } else {
                    resendColor = AppColors.primary;
                  }

                  return InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: isEnabled
                        ? () => provider.resendOtp(phone)
                        : null,
                    child: Text(
                      isTimerActive
                          ? "Resend in ${provider.resendTime}s"
                          : "Resend now",
                      style: AppFontStyle.text_14_600(resendColor),
                    ),
                  );
                },
              ),
            ],
          ),
        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}