import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ozi/app/modules/auth/vendor/signup/view/signup_screen_first.dart';
import 'package:provider/provider.dart';
import 'package:ozi/app/shared/widgets/custom_check_box.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';
import '../provider/signup_provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupProvider(),
      child: const SignupScreenContent(),
    );
  }
}

class SignupScreenContent extends StatelessWidget {
  const SignupScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              hBox(30),

              /// Title
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
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                maxLines: 2,
                style: AppFontStyle.text_16_400(AppColors.grey),
              ),

              hBox(30),

              /// FIRST NAME
              CustomTextFormField(
                label: "First Name",
                hintText: "Enter first name",
                prefix: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    ImageConstants.userIcon,
                    height: 20,
                    width: 20,
                    colorFilter:  ColorFilter.mode(
                      AppColors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                borderRadius: 40,
              ),

              hBox(16),

              /// LAST NAME
              CustomTextFormField(
                label: "Last Name",
                hintText: "Enter last name",
                prefix: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    ImageConstants.userIcon,
                    height: 20,
                    width: 20,
                    colorFilter:  ColorFilter.mode(
                      AppColors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                borderRadius: 40,
              ),

              hBox(16),

              /// EMAIL
              CustomTextFormField(
                label: "Email Address",
                hintText: "Enter email address",
                prefix: Padding(
                  padding:  EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    ImageConstants.mail,
                    height: 20,
                    width: 20,
                    colorFilter:  ColorFilter.mode(
                      AppColors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                borderRadius: 40,
              ),

              hBox(30),

              /// BUTTON
              CustomButton(
                onPressed: () {
                  if (!provider.agree) {
                    errorToast(context, "Please accept Terms & Privacy Policy");
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SignupScreenFirst(),
                    ),
                  );
                },
                text: "Create Account",
              ),

              hBox(10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCheckbox(
                    value: provider.agree,
                    onChanged: (val) {
                      provider.toggleAgree(val);
                    },
                    width: 22,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "I agree to the ",
                        style: AppFontStyle.text_14_400(AppColors.black),
                        children: [
                          TextSpan(
                            text: "Terms of Service",
                            style: AppFontStyle.text_14_500(AppColors.primary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {},
                          ),
                          const TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: AppFontStyle.text_14_500(AppColors.primary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
