import 'dart:async';
import 'package:flutter/gestures.dart';
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
                        "Create an account to continue.",
                        style: AppFontStyle.text_16_400(AppColors.grey),
                      ),

                      hBox(30),

                      /// FIRST NAME
                      CustomTextFormField(
                        controller: value.firstNameController,
                        label: "First Name",
                        hintText: "Enter first name",
                        onChanged: (val) => value.updateUI(),
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
                        onChanged: (val) => value.updateUI(),
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
                                    !value.isloading)
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
                            child: value.isloading
                                ? SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : value.isEmailVerified
                                ? Icon(
                                    Icons.check_circle,
                                    color: AppColors.green,
                                    size: 20,
                                  )
                                : Text(
                                    "Verify",
                                    style: AppFontStyle.text_14_400(
                                      value.isEmailValid
                                          ? AppColors.primary
                                          : AppColors.grey,
                                    ),
                                  ),
                          ),
                        ),
                        borderRadius: 60,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Email is required";
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
                        onPressed:
                            (value.loading ||
                                !value.isEmailVerified ||
                                value.firstNameController.text.trim().isEmpty ||
                                value.lastNameController.text.trim().isEmpty)
                            ? null
                            : () {
                                if (value.formKey.currentState?.validate() ??
                                    false) {
                                  value.createAccount(userId, context);
                                }
                              },
                        color:
                            (value.isEmailVerified &&
                                value.firstNameController.text
                                    .trim()
                                    .isNotEmpty &&
                                value.lastNameController.text.trim().isNotEmpty)
                            ? AppColors.primary
                            : AppColors.primary.withOpacity(0.5),
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _OtpDialogContent(provider: provider, userId: userId);
      },
    );
  }
}

class _OtpDialogContent extends StatefulWidget {
  final CreateAccountProvider provider;
  final String userId;

  const _OtpDialogContent({required this.provider, required this.userId});

  @override
  State<_OtpDialogContent> createState() => _OtpDialogContentState();
}

class _OtpDialogContentState extends State<_OtpDialogContent> {
  String otpCode = "";
  String? errorMessage;
  String? successMessage;
  bool isResending = false;
  int secondsRemaining = 180;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer({bool clearSuccess = true}) {
    timer?.cancel();
    setState(() {
      secondsRemaining = 180;
      errorMessage = null;
      if (clearSuccess) successMessage = null;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get timerText {
    int minutes = secondsRemaining ~/ 60;
    int seconds = secondsRemaining % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      contentPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                if (errorMessage != null || successMessage != null) {
                  setState(() {
                    errorMessage = null;
                    successMessage = null;
                  });
                }
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
            if (errorMessage != null) ...[
              hBox(8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  errorMessage!,
                  style: AppFontStyle.text_12_400(AppColors.red),
                ),
              ),
            ],
            hBox(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Didn't receive the OTP? ",
                    style: AppFontStyle.text_12_400(AppColors.grey),
                    children: [
                      if (isResending)
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: SizedBox(
                              height: 12,
                              width: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        )
                      else
                        TextSpan(
                          text: "Resend OTP",
                          style: AppFontStyle.text_12_600(
                            secondsRemaining == 0
                                ? AppColors.primary
                                : AppColors.grey,
                          ).copyWith(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = secondsRemaining == 0
                                ? () async {
                                    try {
                                      setState(() => isResending = true);
                                      final response = await widget.provider
                                          .emailSendApi({
                                            "email": widget
                                                .provider
                                                .emailController
                                                .text
                                                .trim(),
                                            "user_id": widget.userId,
                                          });
                                      if (response['status'] == true ||
                                          response['status'] == 200) {
                                        startTimer(clearSuccess: false);
                                        setState(() {
                                          successMessage =
                                              "OTP resent successfully";
                                        });
                                       // Navigator.pop(context);
                                      } else {
                                        setState(() {
                                          errorMessage =
                                              response['message'] ??
                                              "Failed to resend OTP";
                                        });
                                      }
                                    } catch (e) {
                                      setState(() {
                                        errorMessage = e.toString();
                                      });
                                    } finally {
                                      setState(() => isResending = false);
                                    }
                                  }
                                : null,
                        ),
                    ],
                  ),
                ),
                Text(
                  timerText,
                  style: AppFontStyle.text_12_600(AppColors.darkText),
                ),
              ],
            ),
            if (successMessage != null) ...[
              hBox(8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  successMessage!,
                  style: AppFontStyle.text_12_400(AppColors.green),
                ),
              ),
            ],
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
                  child: widget.provider.otpLoading
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
                                final response = await widget.provider
                                    .verifyEmailApi({
                                      "email": widget
                                          .provider
                                          .emailController
                                          .text
                                          .trim(),
                                      "otp": otpCode,
                                      "user_id": widget.userId,
                                    });
                                if (response['status'] == true ||
                                    response['status'] == 200) {
                                  Navigator.pop(context);
                                  Get.showToast(
                                    "Email verified successfully",
                                    type: ToastType.success,
                                  );
                                } else {
                                  setState(() {
                                    errorMessage =
                                        response['message'] ?? "Invalid OTP";
                                  });
                                }
                              } catch (e) {
                                setState(() {
                                  errorMessage = e.toString();
                                });
                              }
                            } else {
                              setState(() {
                                errorMessage = "Please enter a 4-digit OTP";
                              });
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
  }
}
