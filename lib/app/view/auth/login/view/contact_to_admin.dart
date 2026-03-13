import 'package:flutter/material.dart';
import 'package:ozi/app/core/appExports/app_export.dart';
import 'package:ozi/app/core/constants/image_constant.dart';
import 'package:ozi/app/core/utils/get_utils.dart';
import 'package:ozi/app/core/utils/sizedBox.dart';
import 'package:ozi/app/shared/widgets/auth_guard.dart';
import 'package:ozi/app/shared/widgets/custom_app_bar.dart';
import 'package:ozi/app/shared/widgets/custom_text_form_field.dart';
import 'package:ozi/app/view/auth/login/provider/contact_provider.dart';

class ContactToAdmin extends StatefulWidget {
  const ContactToAdmin({super.key});

  @override
  State<ContactToAdmin> createState() => _ContactToAdminState();
}

class _ContactToAdminState extends State<ContactToAdmin> {
  ContactProvider provider = ContactProvider();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Contact To Admin"),
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: provider,
          child: _supportWidget(context, provider),
        ),
      ),
    );
  }

  Widget _supportWidget(BuildContext context, ContactProvider provider) {
    // final contact = provider.contactInfo;
    return Consumer<ContactProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _inputBox(
                  "Full Name",
                  "Enter full name",
                  provider.nameController,
                ),
                hBox(16),
                _inputBox(
                  "Email Address",
                  "Enter email address",
                  provider.emailController,
                ),
                hBox(16),
                _inputBox(
                  "Subject",
                  "Enter your subject",
                  provider.subjectController,
                ),
                hBox(16),
                _largeInput(
                  "Message",
                  "Write your message...",
                  provider.messageController,
                ),
                hBox(16),
                CustomButton(
                  isLoading: provider.isLoading,
                  text: "Send Message",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      provider.sendToAdmin({
                        "full_name": provider.nameController.text.trim(),
                        "email": provider.emailController.text.trim(),
                        "subject": provider.subjectController.text.trim(),
                        "message": provider.messageController.text.trim(),
                      }, context);
                    }
                  },
                  height: 50,
                  borderRadius: BorderRadius.circular(60),
                ),
                hBox(24),
              ],
            ),
          ),
        );
      },
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
