import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ozi/app/view/user_role/choose_your_role/view/provider/RoleProvider.dart';
import '../../../../core/appExports/app_export.dart';
import '../../../auth/create account/view/create_account_screen.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen( {super.key, this.userId});
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoleProvider(),
      child: Consumer<RoleProvider>(builder: (context, provider, child) {
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

                Text(
                  "Select how you want to use the app.",
                  style: AppFontStyle.text_16_400(AppColors.grey),
                ),

                hBox(30),

                _roleTile(
                  imagePath: ImageConstants.userIcon,
                  text: "I'm a User",
                  isSelected: provider.selectedRole == "user",
                  onTap: () => provider.selectRole("user"),
                ),
                hBox(16),
                _roleTile(
                  imagePath: ImageConstants.vendorIcon,
                  text: "I'm a Vendor",
                  isSelected: provider.selectedRole == "vendor",
                  onTap: () => provider.selectRole("vendor"),
                ),

                hBox(30),

                CustomButton(
                  text: provider.isLoading ? "Please wait..." : "Continue",
                  isLoading: provider.isLoading,
                  onPressed: () async {
                    if (!provider.hasSelectedRole) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a role"),
                        ),
                      );
                      return;
                    }

                    _onContinuePressed(
                      context,
                      context.read<RoleProvider>(),
                    );
                  },
                ),

              ],
            ),
          ),
        );
      },),
    );
  }


  Future<void> _onContinuePressed(
      BuildContext context,
      RoleProvider provider,
      ) async {
    if (provider.isLoading) return;

    final result = await provider.chooseRole(userId: userId??'');

    if (result?.status == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CreateAccountScreen(userId: userId??'',
          ),
        ),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result?.message ??
                provider.errorMessage ??
                "Something went wrong",
          ),
        ),
      );
    }
  }

  Widget _roleTile({
    required String imagePath,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isSvg = imagePath.toLowerCase().endsWith(".svg");

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.3),
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
              colorFilter:  ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            )
                : Image.asset(
              imagePath,
              height: 22,
              width: 22,
              color: AppColors.primary,
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

// class ChooseRoleContent extends StatelessWidget {
//   const ChooseRoleContent({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<RoleProvider>();
//
//     return ;
//   }
//
//
// }
