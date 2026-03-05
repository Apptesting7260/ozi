import 'package:ozi/app/modules/user/profile/view/profile_provider/profile_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../core/constants/app_urls.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_bottom_shit.dart';
import '../../../../../shared/widgets/custom_image_path_helper.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';
import '../provider/EditProfileProvider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  void initState(BuildContext context) {
    final profileProvider = context.read<ProfileProvider>();
    profileProvider.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EditProfileProvider>();

    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(title: "Edit Profile"),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  hBox(10),

                  // PROFILE SECTION
                  _profileSection(provider, context),

                  hBox(30),

                  // FIELDS
                  _inputFields(provider, context),

                  hBox(30),

                  CustomButton(
                    borderRadius: BorderRadius.circular(60),
                    text: provider.isUpdating
                        ? "Updating..."
                        : "Update Profile",
                    onPressed: provider.isUpdating
                        ? null
                        : () => provider.updateProfile(context),
                    height: 54,
                  ),

                  hBox(30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── PROFILE SECTION ───────────────────

  Widget _profileSection(EditProfileProvider provider, context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              height: 110,
              width: 110,
              // padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 3),
              ),
              // child:
              child: ClipOval(
                child: provider.pickedImage != null
                    ? Image.file(
                        File(provider.pickedImage!.path),
                        fit: BoxFit.cover,
                        height: 110,
                        width: 110,
                      )
                    : Image.network(
                        "${AppUrls.imageBaseUrl}${provider.networkImage ?? ''}",
                        height: 110,
                        width: 110,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                provider.firstNameController.text.isNotEmpty
                                    ? provider.firstNameController.text[0]
                                          .toUpperCase()
                                    : "?",
                                style: AppFontStyle.text_28_600(
                                  AppColors.darkText,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            //  ClipOval( child: provider.pickedImage != null
            //       ? Image.file(
            //           File(provider.pickedImage!.path),
            //           fit: BoxFit.cover,
            //         )
            //       : CustomImage(
            //           path: ImagePathHelper.getFullImageUrl(
            //             provider.networkImage,
            //             AppUrls.imageBaseUrl,
            //           ),
            //           fit: BoxFit.cover,
            //         ),
            // ),

            //+ CAMERA BUTTON
            GestureDetector(
              onTap: () => _showPicker(context),
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        hBox(10),
        Text(
          "Change Photo",
          style: AppFontStyle.text_14_500(AppColors.primary),
        ),
      ],
    );
  }

  void _showPicker(BuildContext context) {
    final provider = Provider.of<EditProfileProvider>(context, listen: false);

    CustomBottomSheet.show(
      context: context,
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            hBox(5),

            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                provider.pickCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                provider.pickGallery();
              },
            ),

            hBox(10),
          ],
        ),
      ),
    );
  }

  Widget _inputFields(EditProfileProvider provider, BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          label: "First Name",
          hintText: "Alex",
          controller: provider.firstNameController,
          prefix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomImage(
              path: ImageConstants.userIcon,
              height: 14,
              width: 14,
            ),
          ),
        ),

        hBox(16),

        CustomTextFormField(
          label: "Last Name",
          hintText: "Johnson",
          controller: provider.lastNameController,
          prefix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomImage(
              path: ImageConstants.userIcon,
              height: 14,
              width: 14,
            ),
          ),
        ),

        hBox(16),

        // CustomTextFormField(
        //   label: "Email Address",
        //   hintText: "yourname@gmail.com",
        //   controller: provider.emailController,
        //   prefix: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 10),
        //     child: CustomImage(
        //       path: ImageConstants.mail,
        //       height: 14,
        //       width: 14,
        //     ),
        //   ),
        // ),
        CustomTextFormField(
          controller: provider.emailController,
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
            provider.validateEmail(val);
          },
          suffix: Padding(
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
              onTap:
                  (provider.isEmailValid &&
                      !provider.isEmailVerified &&
                      !provider.isloading)
                  ? () async {
                      try {
                        final response = await provider.emailSendOtpApi({
                          "email": provider.emailController.text.trim(),
                        });
                        if (response['status'] == true ||
                            response['status'] == 200) {
                          _showOtpDialog(context, provider);
                        } else {
                          Get.showToast(
                            response['message'] ?? "Something went wrong",
                            type: ToastType.warning,
                          );
                        }
                      } catch (e) {
                        Get.showToast(e.toString(), type: ToastType.error);
                      }
                    }
                  : null,
              child: provider.isloading
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : provider.isEmailVerified
                  ? Icon(Icons.check_circle, color: AppColors.primary, size: 20)
                  : Text(
                      "Verify",
                      style: AppFontStyle.text_14_400(
                        provider.isEmailValid
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
      ],
    );
  }

  void _showOtpDialog(BuildContext context, EditProfileProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _OtpDialogContent(provider: provider);
      },
    );
  }
}

class _OtpDialogContent extends StatefulWidget {
  final EditProfileProvider provider;

  const _OtpDialogContent({required this.provider});

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
              "Enter the 6-digit OTP sent to your email.",
              textAlign: TextAlign.center,
              style: AppFontStyle.text_14_400(AppColors.grey),
            ),
            hBox(20),
            PinCodeTextField(
              appContext: context,
              length: 6,
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
              // enableActiveFill: true,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.circle,
                fieldHeight: 48,
                fieldWidth: 48,
                activeFillColor: AppColors.fieldBgColor,
                inactiveFillColor: AppColors.fieldBgColor,
                selectedFillColor: AppColors.fieldBgColor,
                activeColor: AppColors.primary,
                inactiveColor: Colors.transparent,
                selectedColor: AppColors.primary,
                borderWidth: 0,
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
            if (secondsRemaining > 0)
              Center(
                child: Text(
                  "Resend OTP in $timerText",
                  style: AppFontStyle.text_12_400(AppColors.grey),
                ),
              )
            else
              Center(
                child: isResending
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppColors.primary,
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          try {
                            setState(() => isResending = true);
                            final response = await widget.provider
                                .emailSendOtpApi({
                                  "email": widget.provider.emailController.text
                                      .trim(),
                                });
                            if (response['status'] == true ||
                                response['status'] == 200) {
                              startTimer(clearSuccess: false);
                              setState(() {
                                successMessage = "OTP resent successfully";
                              });
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
                        },
                        child: Text(
                          "Resend OTP",
                          style: AppFontStyle.text_14_600(
                            AppColors.primary,
                          ).copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
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
                            if (otpCode.length == 6) {
                              try {
                                final response = await widget.provider
                                    .verifyEmailApi({"otp": otpCode});
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
                                errorMessage = "Please enter a 6-digit OTP";
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
