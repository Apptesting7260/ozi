import 'package:flutter/material.dart';
import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/core/constants/image_constant.dart';
import 'package:ozi/app/core/utils/get_utils.dart';
import 'package:ozi/app/core/utils/sizedBox.dart';
import 'package:ozi/app/shared/widgets/auth_guard.dart';
import 'package:ozi/app/shared/widgets/custom_text_form_field.dart';

class ContactToAdmin extends StatefulWidget {
  const ContactToAdmin({super.key});

  @override
  State<ContactToAdmin> createState() => _ContactToAdminState();
}

class _ContactToAdminState extends State<ContactToAdmin> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  Widget _supportWidget(BuildContext context, HelpUserProvider provider) {
    // final contact = provider.contactInfo;
    return SingleChildScrollView(
      padding: REdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _inputBox("Full Name", "Enter full name", _emailController),
          hBox(16),
          _inputBox("Email Address", "Enter email address", _emailController),
          hBox(16),

          _inputBox("Subject", "Enter your subject", _subjectController),
          hBox(16),

          _largeInput("Message", "Write your message...", _messageController),
          hBox(16),

          CustomButton(
            text: provider.isLoading ? "Sending..." : "Send Message",
            onPressed: provider.isLoading
                ? null
                : () async {
                    final bool allowed = await AuthGuard.requireLogin(context);

                    if (!allowed) return;

                    if (_emailController.text.trim().isEmpty ||
                        _subjectController.text.trim().isEmpty ||
                        _messageController.text.trim().isEmpty) {
                      Get.showToast(
                        "Please fill all fields",
                        type: ToastType.error,
                      );
                      return;
                    }

                    if (!Get.isValidEmail(_emailController.text.trim())) {
                      Get.showToast(
                        "Please enter a valid email address",
                        type: ToastType.error,
                      );
                      return;
                    }

                    provider.sendSupportMessage(
                      email: _emailController.text.trim(),
                      subject: _subjectController.text.trim(),
                      message: _messageController.text.trim(),
                    );
                  },
            height: 50,
            borderRadius: BorderRadius.circular(60),
          ),

          hBox(24),

          Text(
            "Quick Actions",
            style: AppFontStyle.text_16_600(AppColors.darkText),
          ),

          hBox(12),
          // if (contact?.callUs != null)
          _quickActionCard(
            imagePath: ImageConstants.call,
            title: "Call Us",
            subtitle: provider.helpModel?.actions?.callUs.toString() ?? "",
            buttonText: "Call Now",
            onTap: () async {
              final bool allowed = await AuthGuard.requireLogin(context);

              if (!allowed) return;

              Get.dialCall(
                provider.helpModel?.actions?.callUs.toString() ?? "",
              );
            },
          ),

          // _quickActionCard(
          //   imagePath: ImageConstants.call,
          //   title: "Call Us",
          //   subtitle: provider.helpModel?.data?[0].callUs.toString() ?? "",
          //   buttonText: "Call Now",
          //   onTap: () {
          //     if (provider.helpModel?.data?[0].callUs != null) {
          //       Get.dialCall(provider.helpModel!.data![0].callUs!.toString());
          //     }
          //   },
          // ),
          hBox(12),

          _quickActionCard(
            imagePath: ImageConstants.mail,
            title: "Email Us",
            subtitle: provider.helpModel?.actions?.emailUs ?? "",
            buttonText: "Send Email",
            onTap: () async {
              final bool allowed = await AuthGuard.requireLogin(context);

              if (!allowed) return;

              final email = provider.helpModel?.actions?.emailUs?.trim();
              if (email != null && email.isNotEmpty) {
                Get.sendEmail(email);
              } else {
                Get.showToast(
                  "Email address not available",
                  type: ToastType.error,
                );
              }
            },
          ),

          hBox(40),
        ],
      ),
    );
  }

  Widget _inputBox(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return CustomTextFormField(
      label: label,
      hintText: hint,
      controller: controller,
      borderRadius: 12,
      textInputAction: TextInputAction.next,
      width: double.infinity,
      height: null,
      maxLines: 1,
      minLines: 1,
      textInputType: label.toLowerCase().contains("email")
          ? TextInputType.emailAddress
          : TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }
        if (label.toLowerCase().contains("email")) {
          if (!Get.isValidEmail(value.trim())) {
            return "Enter a valid email address";
          }
        }
        return null;
      },
    );
  }

  Widget _quickActionCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          /// ICON CONTAINER
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: CustomImage(path: imagePath, color: AppColors.primary),
            ),
          ),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFontStyle.text_14_600(AppColors.darkText),
                ),
                SizedBox(height: 2),
                Text(subtitle, style: AppFontStyle.text_12_400(AppColors.grey)),
              ],
            ),
          ),

          SizedBox(width: 8),

          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                buttonText,
                style: AppFontStyle.text_12_600(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _largeInput(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return CustomTextFormField(
      label: label,
      hintText: hint,
      controller: controller,
      borderRadius: 12,
      textInputType: TextInputType.multiline,
      maxLines: 5,
      minLines: 5,
      contentPadding: EdgeInsets.all(14),
      textInputAction: TextInputAction.newline,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }
        return null;
      },
    );
  }
}
