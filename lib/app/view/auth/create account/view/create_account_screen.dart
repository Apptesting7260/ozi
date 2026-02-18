import '../../../../core/appExports/app_export.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';
import '../provider/create_account_provider.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateAccountProvider(),
      child: Consumer<CreateAccountProvider>(
        builder: (context, value, child) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 50,
                ),
                child: Form(
                  key: value.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      hBox(30),

                      // Title
                      Text(
                        "Create Account",
                        style: AppFontStyle.text_28_600(
                          AppColors.darkText,
                          fontFamily: AppFontFamily.extraBold,
                        ),
                      ),

                      hBox(10),

                      /// Subtitle
                      Text(
                        maxLines: 2,
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                        style: AppFontStyle.text_16_400(AppColors.grey),
                      ),

                      hBox(30),

                      /// FIRST NAME
                      CustomTextFormField(
                        controller: value.firstNameController,
                        label: "First Name",
                        hintText: "Enter first name",
                        prefix: Padding(
                          padding: const EdgeInsets.all(12),
                          child: CustomImage(
                            path: ImageConstants.userIcon,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        borderRadius: 40,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "First name is required";
                          }
                          if (!RegExp(r'^[a-zA-Z]+$').hasMatch(val.trim())) {
                            return "First name should contain only alphabets";
                          }
                          return null;
                        },
                      ),

                      hBox(16),

                      /// LAST NAME
                      CustomTextFormField(
                        controller: value.lastNameController,
                        label: "Last Name",
                        hintText: "Enter last name",
                        prefix: Padding(
                          padding: const EdgeInsets.all(12),
                          child: CustomImage(
                            path: ImageConstants.userIcon,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        borderRadius: 40,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Last name is required";
                          }
                          if (!RegExp(r'^[a-zA-Z]+$').hasMatch(val.trim())) {
                            return "Last name should contain only alphabets";
                          }
                          return null;
                        },
                      ),

                      hBox(16),

                      /// EMAIL
                      CustomTextFormField(
                        controller: value.emailController,
                        label: "Email Address",
                        hintText: "Enter email address",
                        textInputType: TextInputType.emailAddress,
                        prefix: Padding(
                          padding: const EdgeInsets.all(12),
                          child: CustomImage(
                            path: ImageConstants.mail,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        onChanged: (val) {
                          value.validateEmail(val);
                        },
                        suffix: Padding(
                          padding: const EdgeInsets.all(12),
                          child: GestureDetector(
                            onTap:
                                (value.isEmailValid &&
                                    !value.isEmailVerified &&
                                    !value.loading)
                                ? () async {
                                    try {
                                      final response = await value
                                          .emailSendApi({
                                            "email": value.emailController.text
                                                .trim(),
                                            "user_id": userId,
                                          });
                                      if (response['status'] == true ||
                                          response['status'] == 200) {
                                        _showOtpDialog(context, value, userId);
                                      } else {
                                        Get.showToast(
                                          response['message'] ??
                                              "Something went wrong",
                                          type: ToastType.warning,
                                        );
                                      }
                                    } catch (e) {
                                      Get.showToast(
                                        e.toString(),
                                        type: ToastType.error,
                                      );
                                    }
                                  }
                                : null,
                            child: Text(
                              value.isEmailVerified ? "Verified" : "Verify",
                              style: AppFontStyle.text_15_400(
                                value.isEmailVerified
                                    ? AppColors.green
                                    : (value.isEmailValid
                                          ? AppColors.green
                                          : AppColors.grey),
                              ),
                            ),
                          ),
                        ),
                        borderRadius: 40,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Email address is required";
                          }
                          if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          ).hasMatch(val.trim())) {
                            return "Please enter a valid email (e.g., abc@gmail.com)";
                          }
                          return null;
                        },
                      ),

                      hBox(30),

                      CustomButton(
                        isLoading: value.loading,
                        onPressed: value.loading
                            ? () {}
                            : () {
                                if (value.formKey.currentState?.validate() ??
                                    false) {
                                  value.createAccount(userId, context);
                                }
                              },
                        text: "Create Account",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showOtpDialog(
    BuildContext context,
    CreateAccountProvider provider,
    String userId,
  ) {
    String otpCode = "";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              contentPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "OTP Verification",
                textAlign: TextAlign.center,
                style: AppFontStyle.text_20_600(AppColors.darkText),
              ),
              content: SizedBox(
                width: Get.width(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      "Enter the 4-digit OTP sent to your email.",
                      textAlign: TextAlign.center,
                      style: AppFontStyle.text_14_400(AppColors.grey),
                    ),
                    hBox(20),
                    PinCodeTextField(
                      appContext: context,
                      length: 4,
                      onChanged: (value) {
                        otpCode = value;
                      },
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(12),
                        fieldHeight: 55,
                        fieldWidth: 50,
                        activeFillColor: AppColors.white,
                        inactiveFillColor: AppColors.white,
                        selectedFillColor: AppColors.white,
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.borderColor,
                        selectedColor: AppColors.primary,
                        borderWidth: 1.5,
                      ),
                    ),
                    hBox(30),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              "Cancel",
                              style: AppFontStyle.text_16_600(AppColors.red),
                            ),
                          ),
                        ),
                        wBox(12),
                        Expanded(
                          child: provider.otpLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                )
                              : CustomButton(
                                  height: 50,
                                  onPressed: () async {
                                    if (otpCode.length == 4) {
                                      try {
                                        final response = await provider
                                            .verifyEmailApi({
                                              "email": provider
                                                  .emailController
                                                  .text
                                                  .trim(),
                                              "otp": otpCode,
                                            });
                                        if (response['status'] == true ||
                                            response['status'] == 200) {
                                          Navigator.pop(context);
                                          Get.showToast(
                                            "Email verified successfully",
                                            type: ToastType.success,
                                          );
                                        } else {
                                          Get.showToast(
                                            response['message'] ??
                                                "Invalid OTP",
                                            type: ToastType.warning,
                                          );
                                        }
                                      } catch (e) {
                                        Get.showToast(
                                          e.toString(),
                                          type: ToastType.error,
                                        );
                                      }
                                    } else {
                                      Get.showToast(
                                        "Please enter a 4-digit OTP",
                                        type: ToastType.warning,
                                      );
                                    }
                                  },
                                  text: "Verify",
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
