import 'package:ozi/app/modules/auth/vendor/signup/view/signup_screen.dart';
import 'package:ozi/app/view/user_role/choose_your_role/view/provider/RoleProvider.dart';
import '../../../../core/appExports/app_export.dart';
import '../../../../modules/auth/user/create account/view/create_account_screen.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoleProvider(),
      child: const ChooseRoleContent(),
    );
  }
}

class ChooseRoleContent extends StatelessWidget {
  const ChooseRoleContent({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RoleProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            hBox(30),
            Text(
              "Choose Your Role",
              style: AppFontStyle.text_28_600(
                AppColors.darkText,
                fontFamily: AppFontFamily.extraBold,
              ),
            ),

            hBox(10),

            /// SUBTITLE
            Text(
              maxLines: 2,
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
              style: AppFontStyle.text_16_400(AppColors.grey),
            ),

            hBox(30),

            /// USER OPTION
            roleOptionTile(
              imagePath: ImageConstants.userIcon,
              text: "I'm a User",
              isSelected: provider.selectedRole == "user",
              onTap: () => provider.selectRole("user"),
            ),

            hBox(16),

            roleOptionTile(
              imagePath: ImageConstants.vendorIcon,
              text: "I'm a Vendor",
              isSelected: provider.selectedRole == "vendor",
              onTap: () => provider.selectRole("vendor"),
            ),

            hBox(16),

            CustomButton(
              text: "Continue",
              onPressed: () {
                if (provider.selectedRole == "user") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateAccountScreen(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SignupScreen(), // VENDOR SCREEN
                    ),
                  );
                }
              },
            ),

          ],
        ),
      ),
    );
  }
  Widget roleOptionTile({
    required String imagePath,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    bool isSvg = imagePath.toLowerCase().endsWith(".svg");
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.30),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSvg
                ? SvgPicture.asset(
              imagePath,
              height: 22,
              width: 22,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.primary : AppColors.primary,
                BlendMode.srcIn,
              ),
            )
                : Image.asset(
              imagePath,
              height: 22,
              width: 22,
              color: isSelected ? AppColors.primary : AppColors.primary,
            ),

            wBox(10),

            Text(
              text,
              style: AppFontStyle.text_16_600(
                isSelected ? AppColors.primary : AppColors.black,
                fontFamily: AppFontFamily.semiBold,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
