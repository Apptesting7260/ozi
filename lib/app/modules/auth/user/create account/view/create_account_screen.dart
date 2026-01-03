

import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';
import '../../../../user/navigation tab/view/navigation_tab_screen.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

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
                maxLines: 2,
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                style: AppFontStyle.text_16_400(AppColors.grey),
              ),

              hBox(30),

              /// FIRST NAME
              CustomTextFormField(
                label: "First Name",
                hintText: "Enter first name",
                prefix: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CustomImage(
                    path:  ImageConstants.userIcon,
                    height: 20,
                    width: 20,
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
                  child: CustomImage(
                    path:  ImageConstants.userIcon,
                    height: 20,
                    width: 20,
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
                  padding: const EdgeInsets.all(12),
                  child: CustomImage(
                    path:  ImageConstants.mail,
                    height: 20,
                    width: 20,
                  ),
                ),
                borderRadius: 40,
              ),

              hBox(30),

              /// BUTTON
              CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>   NavigationTabScreen(),
                    ),
                  );
                },
                text: "Create Account",

              ),
            ],
          ),
        ),
      ),
    );
  }
}
