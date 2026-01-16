import '../../../../core/appExports/app_export.dart';
import '../../../../modules/user/navigation tab/view/navigation_tab_screen.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Form(
                  key: value.formKey,
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
                        borderRadius: 40,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Email address is required";
                          }
                          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(val.trim())) {
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
                          if (value.formKey.currentState?.validate() ?? false) {
                            value.createAccount(userId);
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
}